# FastPix Video Data THEOplayer — Examples

Two standalone apps showing the **FastPix THEOplayer SDK** (`THEOplayerWrapper`)
attached to a THEOplayer, one per UI paradigm:

- [`UIKit/`](UIKit) — THEOplayer in a `UIViewController` (iOS 15+)
- [`SwiftUI/`](SwiftUI) — THEOplayer in a `UIViewRepresentable` (iOS 16+)

Each folder is self-contained — open its `.xcodeproj`, press **▶ Run**, then
watch views on [dashboard.fastpix.com](https://dashboard.fastpix.com). Both
reference the SDK as a local Swift package (`../..`), so they build against this
checkout.

## THEOplayer needs a license

THEOplayer will not play until it's given a **license bound to your app's bundle
identifier**. Create one at [portal.theoplayer.com](https://portal.theoplayer.com)
(SDKs → iOS) for the bundle id you build with, then paste it into each project's
`Config.swift` (`theoLicense`). Until then the app runs and shows a red
_"Add your THEOplayer license to play"_ badge — analytics still initialize, but
there's no playback to measure. See each project's README for details.
