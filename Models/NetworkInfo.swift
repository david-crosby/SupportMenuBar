import Foundation

struct NetworkInfo {
    let ipAddress: String
    let subnetMask: String
    let gateway: String
    let dnsServers: [String]
    let connectionQuality: String
    let bandwidth: String
    let latency: String
    
    static var empty: NetworkInfo {
        NetworkInfo(
            ipAddress: "Unknown",
            subnetMask: "Unknown",
            gateway: "Unknown",
            dnsServers: [],
            connectionQuality: "Unknown",
            bandwidth: "Unknown",
            latency: "Unknown"
        )
    }
}
