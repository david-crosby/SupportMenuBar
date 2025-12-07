import SwiftUI

struct NetworkInfoView: View {
    let networkInfo: NetworkInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Network Information")
                .font(.headline)
            
            InfoRow(label: "IP Address", value: networkInfo.ipAddress)
            InfoRow(label: "Subnet Mask", value: networkInfo.subnetMask)
            InfoRow(label: "Gateway", value: networkInfo.gateway)
            
            if !networkInfo.dnsServers.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("DNS Servers")
                        .foregroundColor(.secondary)
                    ForEach(networkInfo.dnsServers, id: \.self) { dns in
                        Text(dns)
                            .fontWeight(.medium)
                    }
                }
            }
            
            InfoRow(label: "Connection Quality", value: networkInfo.connectionQuality)
            InfoRow(label: "Bandwidth", value: networkInfo.bandwidth)
            InfoRow(label: "Latency", value: networkInfo.latency)
        }
    }
}
