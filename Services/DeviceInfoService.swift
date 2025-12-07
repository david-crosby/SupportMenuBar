import Foundation
import IOKit.ps

class DeviceInfoService {
    func fetchDeviceInfo() -> DeviceInfo {
        DeviceInfo(
            serialNumber: getSerialNumber(),
            model: getModelIdentifier(),
            osVersion: getOSVersion(),
            totalStorage: getTotalStorage(),
            freeStorage: getFreeStorage(),
            totalMemory: getTotalMemory(),
            freeMemory: getFreeMemory(),
            uptime: getUptime(),
            batteryLevel: getBatteryLevel(),
            batteryStatus: getBatteryStatus()
        )
    }
    
    private func getSerialNumber() -> String {
        guard let output = ShellExecutor.run("system_profiler SPHardwareDataType | grep 'Serial Number'") else {
            return "Unknown"
        }
        return output.components(separatedBy: ": ").last ?? "Unknown"
    }
    
    private func getModelIdentifier() -> String {
        guard let output = ShellExecutor.run("sysctl -n hw.model") else {
            return "Unknown"
        }
        return output
    }
    
    private func getOSVersion() -> String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
    
    private func getTotalStorage() -> String {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: "/") else {
            return "Unknown"
        }
        
        if let size = attributes[.systemSize] as? NSNumber {
            return ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: .binary)
        }
        return "Unknown"
    }
    
    private func getFreeStorage() -> String {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: "/") else {
            return "Unknown"
        }
        
        if let size = attributes[.systemFreeSize] as? NSNumber {
            return ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: .binary)
        }
        return "Unknown"
    }
    
    private func getTotalMemory() -> String {
        let mem = ProcessInfo.processInfo.physicalMemory
        return ByteCountFormatter.string(fromByteCount: Int64(mem), countStyle: .binary)
    }
    
    private func getFreeMemory() -> String {
        guard let output = ShellExecutor.run("vm_stat | grep 'Pages free'") else {
            return "Unknown"
        }
        
        let components = output.components(separatedBy: CharacterSet.decimalDigits.inverted)
        guard let freePages = components.compactMap({ Int($0) }).first else {
            return "Unknown"
        }
        
        let pageSize = vm_page_size
        let freeBytes = Int64(freePages) * Int64(pageSize)
        return ByteCountFormatter.string(fromByteCount: freeBytes, countStyle: .binary)
    }
    
    private func getUptime() -> String {
        let uptime = ProcessInfo.processInfo.systemUptime
        let days = Int(uptime / 86400)
        let hours = Int((uptime.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((uptime.truncatingRemainder(dividingBy: 3600)) / 60)
        
        var components: [String] = []
        if days > 0 { components.append("\(days)d") }
        if hours > 0 { components.append("\(hours)h") }
        if minutes > 0 { components.append("\(minutes)m") }
        
        return components.isEmpty ? "Less than 1 minute" : components.joined(separator: " ")
    }
    
    private func getBatteryLevel() -> Int? {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              !sources.isEmpty else {
            return nil
        }
        
        for source in sources {
            guard let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] else {
                continue
            }
            
            if let capacity = description[kIOPSCurrentCapacityKey] as? Int {
                return capacity
            }
        }
        
        return nil
    }
    
    private func getBatteryStatus() -> String? {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              !sources.isEmpty else {
            return nil
        }
        
        for source in sources {
            guard let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any] else {
                continue
            }
            
            if let isCharging = description[kIOPSIsChargingKey] as? Bool {
                return isCharging ? "Charging" : "Not Charging"
            }
        }
        
        return nil
    }
}
