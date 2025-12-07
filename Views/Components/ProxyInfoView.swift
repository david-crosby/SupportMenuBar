import SwiftUI

struct ProxyInfoView: View {
    let proxyInfo: ProxyInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Web Proxy Status")
                .font(.headline)
            
            HStack {
                Text("Status")
                    .foregroundColor(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Circle()
                        .fill(proxyInfo.isActive && proxyInfo.isConnected ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(proxyStatusText)
                        .fontWeight(.medium)
                }
            }
            
            if let address = proxyInfo.proxyAddress {
                InfoRow(label: "Proxy Address", value: address)
            }
            
            if let port = proxyInfo.proxyPort {
                InfoRow(label: "Proxy Port", value: String(port))
            }
        }
    }
    
    private var proxyStatusText: String {
        if !proxyInfo.isActive {
            return "Inactive"
        } else if proxyInfo.isConnected {
            return "Connected"
        } else {
            return "Not Connected"
        }
    }
}
