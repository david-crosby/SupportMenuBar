# Support Menu Bar

*THIS IS A LEARNING PROJECT - NOT PRODUCTION CODE  

A native macOS menu bar application providing quick access to device, network, and proxy information for support purposes.

## Features

- Device information: Serial number, model, OS version, storage, memory, uptime, battery status
- Network statistics: IP address, subnet, gateway, DNS servers, connection quality, bandwidth, latency
- Web proxy status: Active state and connectivity status

## Requirements

- macOS 15.0 or later
- Xcode 16.0 or later

## Project Structure

```
SupportMenuBar/
├── SupportMenuBarApp.swift          # App entry point with menu bar setup
├── Models/                          # Data models
│   ├── DeviceInfo.swift
│   ├── NetworkInfo.swift
│   └── ProxyInfo.swift
├── Services/                        # Business logic for data gathering
│   ├── DeviceInfoService.swift
│   ├── NetworkInfoService.swift
│   └── ProxyService.swift
├── Views/                           # UI components
│   ├── MenuBarView.swift            # Main container view
│   └── Components/
│       ├── DeviceInfoView.swift
│       ├── NetworkInfoView.swift
│       └── ProxyInfoView.swift
└── Utilities/
    └── ShellExecutor.swift          # Shell command execution helper
```

## Building

1. Open Xcode and create a new macOS App project
2. Set the deployment target to macOS 15.0
3. Copy the source files into your project maintaining the directory structure
4. Replace the default `Info.plist` with the provided one
5. Set the bundle identifier to your organisation's identifier
6. Build and run

## Usage

- Click the info icon in the menu bar to display the support information panel
- Click the refresh button to update all information on demand
- All data is gathered using standard user permissions

## Extending

The modular structure allows easy extension:

- Add new data models in `Models/`
- Implement corresponding services in `Services/`
- Create display components in `Views/Components/`
- Wire up in `MenuBarView.swift`

## Notes

- The proxy service currently checks system HTTP/HTTPS proxy settings
- For specific WSS implementations, extend `ProxyService` with vendor-specific checks
- Network quality tests may take a few seconds to complete
- Battery information is only available on portable Macs
