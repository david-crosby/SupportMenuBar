import Foundation

struct DeviceInfo {
    let serialNumber: String
    let model: String
    let osVersion: String
    let totalStorage: String
    let freeStorage: String
    let totalMemory: String
    let freeMemory: String
    let uptime: String
    let batteryLevel: Int?
    let batteryStatus: String?
    
    static var empty: DeviceInfo {
        DeviceInfo(
            serialNumber: "Unknown",
            model: "Unknown",
            osVersion: "Unknown",
            totalStorage: "Unknown",
            freeStorage: "Unknown",
            totalMemory: "Unknown",
            freeMemory: "Unknown",
            uptime: "Unknown",
            batteryLevel: nil,
            batteryStatus: nil
        )
    }
}
