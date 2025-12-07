import SwiftUI

struct DeviceInfoView: View {
    let deviceInfo: DeviceInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Device Information")
                .font(.headline)
            
            InfoRow(label: "Serial Number", value: deviceInfo.serialNumber)
            InfoRow(label: "Model", value: deviceInfo.model)
            InfoRow(label: "macOS Version", value: deviceInfo.osVersion)
            InfoRow(label: "Total Storage", value: deviceInfo.totalStorage)
            InfoRow(label: "Free Storage", value: deviceInfo.freeStorage)
            InfoRow(label: "Total Memory", value: deviceInfo.totalMemory)
            InfoRow(label: "Free Memory", value: deviceInfo.freeMemory)
            InfoRow(label: "Uptime", value: deviceInfo.uptime)
            
            if let batteryLevel = deviceInfo.batteryLevel,
               let batteryStatus = deviceInfo.batteryStatus {
                InfoRow(label: "Battery", value: "\(batteryLevel)% - \(batteryStatus)")
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
