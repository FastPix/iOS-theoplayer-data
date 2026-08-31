# FastPix Video Data THEOplayer — UIKit Example

A THEOplayer rendered in a `UIViewController`, with the FastPix THEOplayer SDK
(`THEOplayerWrapper`) attached for playback analytics.

## Run

```bash
open FastPixTHEOUIKitExample.xcodeproj
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
  bundle id — create one for `com.fastpix.datasdk.theo.uikit` (or change the
  bundle id to match your license). With the placeholder in place the app runs
  but shows a red _"Add your THEOplayer license to play"_ badge and the player
  stays black.
- **`workspaceKey`** selects the FastPix workspace analytics are sent to.

## Files

| File | Role |
|------|------|
| `PlayerViewController.swift` | Creates the THEOplayer with the license config, attaches the SDK via `tracker.trackTheoPlayer(...)`, sets the source, and tears down in `deinit`. |
| `HomeViewController.swift` | Landing list of sample streams. |
| `Config.swift` | Workspace key, THEOplayer license, and sample streams. |
| `AppDelegate.swift` | App entry point (programmatic window). |

## How the integration works

```swift
let builder = THEOplayerConfigurationBuilder()
builder.license = Config.theoLicense
let player = THEOplayer(configuration: builder.build())
player.addAsSubview(of: containerView)

// All metadata fields live under the "data" key.
let tracker = THEOplayerTracker()
tracker.trackTheoPlayer(player: player, customMetadata: ["data": fields], automaticErrorTracking: true)

player.source = SourceDescription(source: TypedSource(src: url, type: "application/x-mpegurl"))
player.play()
```
