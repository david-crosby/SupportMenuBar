import Foundation
import SystemConfiguration

class ProxyService {
    func fetchProxyInfo() -> ProxyInfo {
        let systemProxySettings = getSystemProxySettings()
        
        return ProxyInfo(
            isActive: systemProxySettings.isActive,
            isConnected: checkProxyConnectivity(address: systemProxySettings.address),
            proxyAddress: systemProxySettings.address,
            proxyPort: systemProxySettings.port
        )
    }
    
    private func getSystemProxySettings() -> (isActive: Bool, address: String?, port: Int?) {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any] else {
            return (false, nil, nil)
        }
        
        let httpsProxyEnabled = proxySettings["HTTPSEnable"] as? Int == 1
        let httpsProxyHost = proxySettings["HTTPSProxy"] as? String
        let httpsProxyPort = proxySettings["HTTPSPort"] as? Int
        
        if httpsProxyEnabled, let host = httpsProxyHost {
            return (true, host, httpsProxyPort)
        }
        
        let httpProxyEnabled = proxySettings["HTTPEnable"] as? Int == 1
        let httpProxyHost = proxySettings["HTTPProxy"] as? String
        let httpProxyPort = proxySettings["HTTPPort"] as? Int
        
        if httpProxyEnabled, let host = httpProxyHost {
            return (true, host, httpProxyPort)
        }
        
        return (false, nil, nil)
    }
    
    private func checkProxyConnectivity(address: String?) -> Bool {
        guard let proxyAddress = address else {
            return false
        }
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, proxyAddress)
        var flags = SCNetworkReachabilityFlags()
        
        guard let reach = reachability,
              SCNetworkReachabilityGetFlags(reach, &flags) else {
            return false
        }
        
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
}
