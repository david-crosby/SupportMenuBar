import Foundation
import SystemConfiguration

class NetworkInfoService {
    func fetchNetworkInfo() -> NetworkInfo {
        NetworkInfo(
            ipAddress: getIPAddress(),
            subnetMask: getSubnetMask(),
            gateway: getGateway(),
            dnsServers: getDNSServers(),
            connectionQuality: getConnectionQuality(),
            bandwidth: getBandwidth(),
            latency: getLatency()
        )
    }
    
    private func getIPAddress() -> String {
        guard let output = ShellExecutor.run("ipconfig getifaddr en0") else {
            return "Not Connected"
        }
        return output.isEmpty ? "Not Connected" : output
    }
    
    private func getSubnetMask() -> String {
        guard let output = ShellExecutor.run("ipconfig getoption en0 subnet_mask") else {
            return "Unknown"
        }
        return output.isEmpty ? "Unknown" : output
    }
    
    private func getGateway() -> String {
        guard let output = ShellExecutor.run("netstat -nr | grep default | grep en0 | awk '{print $2}' | head -n 1") else {
            return "Unknown"
        }
        return output.isEmpty ? "Unknown" : output
    }
    
    private func getDNSServers() -> [String] {
        guard let output = ShellExecutor.run("scutil --dns | grep 'nameserver\\[' | awk '{print $3}'") else {
            return []
        }
        
        let servers = output.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
        
        return servers
    }
    
    private func getConnectionQuality() -> String {
        guard let interface = ShellExecutor.run("route -n get default | grep 'interface:' | awk '{print $2}'") else {
            return "Unknown"
        }
        
        guard let linkStatus = ShellExecutor.run("ifconfig \(interface) | grep 'status:' | awk '{print $2}'") else {
            return "Unknown"
        }
        
        return linkStatus == "active" ? "Connected" : "Disconnected"
    }
    
    private func getBandwidth() -> String {
        guard let output = ShellExecutor.run("networkQuality -c -s") else {
            return "Unknown"
        }
        
        let lines = output.components(separatedBy: .newlines)
        var download = "Unknown"
        var upload = "Unknown"
        
        for line in lines {
            if line.contains("Download") {
                let components = line.components(separatedBy: ":")
                if components.count > 1 {
                    download = components[1].trimmingCharacters(in: .whitespaces)
                }
            } else if line.contains("Upload") {
                let components = line.components(separatedBy: ":")
                if components.count > 1 {
                    upload = components[1].trimmingCharacters(in: .whitespaces)
                }
            }
        }
        
        return "Down: \(download), Up: \(upload)"
    }
    
    private func getLatency() -> String {
        guard let output = ShellExecutor.run("ping -c 3 8.8.8.8 | tail -1 | awk -F '/' '{print $5}'") else {
            return "Unknown"
        }
        
        return output.isEmpty ? "Unknown" : "\(output) ms"
    }
}
