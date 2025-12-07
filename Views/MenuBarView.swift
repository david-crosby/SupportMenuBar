import SwiftUI

struct MenuBarView: View {
    @State private var deviceInfo: DeviceInfo = .empty
    @State private var networkInfo: NetworkInfo = .empty
    @State private var proxyInfo: ProxyInfo = .empty
    @State private var isLoading = false
    
    private let deviceService = DeviceInfoService()
    private let networkService = NetworkInfoService()
    private let proxyService = ProxyService()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Support Information")
                    .font(.headline)
                Spacer()
                Button(action: refreshAllData) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.plain)
                .disabled(isLoading)
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    DeviceInfoView(deviceInfo: deviceInfo)
                    Divider()
                    NetworkInfoView(networkInfo: networkInfo)
                    Divider()
                    ProxyInfoView(proxyInfo: proxyInfo)
                }
                .padding()
            }
        }
        .frame(width: 400, height: 600)
        .onAppear {
            refreshAllData()
        }
    }
    
    private func refreshAllData() {
        isLoading = true
        
        Task.detached(priority: .userInitiated) {
            let device = deviceService.fetchDeviceInfo()
            let network = networkService.fetchNetworkInfo()
            let proxy = proxyService.fetchProxyInfo()
            
            await MainActor.run {
                deviceInfo = device
                networkInfo = network
                proxyInfo = proxy
                isLoading = false
            }
        }
    }
}
