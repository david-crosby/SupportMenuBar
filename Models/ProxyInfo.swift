import Foundation

struct ProxyInfo {
    let isActive: Bool
    let isConnected: Bool
    let proxyAddress: String?
    let proxyPort: Int?
    
    static var empty: ProxyInfo {
        ProxyInfo(
            isActive: false,
            isConnected: false,
            proxyAddress: nil,
            proxyPort: nil
        )
    }
}
