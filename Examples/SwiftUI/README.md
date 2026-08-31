# FastPix Video Data THEOplayer — SwiftUI Example

A THEOplayer hosted in SwiftUI via a small `UIViewRepresentable`, with the
FastPix THEOplayer SDK (`THEOplayerWrapper`) attached for playback analytics.

## Run

```bash
open FastPixTHEOSwiftUIExample.xcodeproj
```

Pick a Simulator (or your device), press **▶ Run**, tap a sample stream, then
open [dashboard.fastpix.com](https://dashboard.fastpix.com) → your workspace to
watch views appear. The project references the SDK as a local Swift package at
`../..`, so it builds against this checkout. First open resolves THEOplayer's
binary framework over the network — let it finish.

## Configure (`Config.swift`)

```swift
static let workspaceKey = "1029207880411545601"     // dashboard.fastpix.com → Workspaces
static let theoLicense  = "YOUR_THEOPLAYER_LICENSE" // portal.theoplayer.com → SDKs → iOS
```

- **`theoLicense` is required for playback.** THEOplayer licenses are bound to a
  bundle id — create one for `com.fastpix.datasdk.theo.swiftui` (or change the
  bundle id to match your license). With the placeholder in place the app runs
  but shows a red _"Add your THEOplayer license to play"_ badge and the player
  stays black.
- **`workspaceKey`** selects the FastPix workspace analytics are sent to.

## Files

| File | Role |
|------|------|
| `PlayerView.swift` | Owns the THEOplayer + tracker in an `ObservableObject` (`@StateObject`); attaches in `.onAppear`, tears down in `.onDisappear`. A `UIViewRepresentable` hosts THEOplayer's UIKit view. |
| `HomeView.swift` | Landing list of sample streams. |
| `Config.swift` | Workspace key, THEOplayer license, and sample streams. |
| `App.swift` | App entry point. |

> THEOplayer is a UIKit view (`addAsSubview(of:)`), so SwiftUI wraps it in a
> `UIViewRepresentable`. The player and tracker live in an `ObservableObject`,
> **not** the View struct — SwiftUI recreates View structs on every render,
> which would churn the player.
