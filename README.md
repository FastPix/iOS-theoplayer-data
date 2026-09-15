# FastPix Video Data SDK for THEOplayer on iOS - real-time video analytics & QoE monitoring

[![Latest release](https://img.shields.io/github/v/release/FastPix/iOS-theoplayer-data?sort=semver)](https://github.com/FastPix/iOS-theoplayer-data/releases)
[![Swift Package Manager](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![iOS 13+](https://img.shields.io/badge/iOS-13%2B-blue?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Built with Swift](https://img.shields.io/badge/Swift-5%2F6-orange?logo=swift&logoColor=white)](https://swift.org/)
[![License](https://img.shields.io/github/license/FastPix/iOS-theoplayer-data)](https://github.com/FastPix/iOS-theoplayer-data/blob/main/LICENSE)

Monitor video playback quality in your iOS app and see it on the FastPix dashboard. This SDK attaches [FastPix Video Data](https://fastpix.com/docs/video-data/overview) analytics to [THEOplayer](https://www.theoplayer.com/) so you can track viewer engagement, streaming quality, startup time, rebuffering, and playback errors in real time - without instrumenting anything by hand.

You attach a tracker to your existing THEOplayer instance once, and every playback event flows to your FastPix workspace automatically. While the SDK is developed in Swift, the published Swift Package Manager package currently includes only the Swift output.

**Works with:** THEOplayer for iOS (9.0+) · iOS 13+ · Swift · UIKit and SwiftUI · Swift Package Manager

📖 **Integration guide:** https://fastpix.com/docs/video-data/monitors/theoplayer &nbsp;·&nbsp; 🚀 **Free account:** https://dashboard.fastpix.com

---

## Start here

If you are integrating the FastPix Video Data SDK for THEOplayer for the first time, follow these steps in order:

1. [Get your FastPix workspace key](#1-get-your-fastpix-workspace-key)
2. [Get your THEOplayer license](#2-get-your-theoplayer-license)
3. [Install the SDK](#3-install-the-sdk)
4. [Import the SDK](#4-import-the-sdk)
5. [Initialize and attach the tracker](#5-initialize-and-attach-the-tracker)
6. [Add player metadata](#6-add-player-metadata)
7. [Verify your integration](#7-verify-your-integration)
8. [Track new videos in the same player](#8-track-new-videos-in-the-same-player)
9. [Understand the data workflow](#9-understand-the-data-workflow)

Do not skip the verification step. If analytics do not appear in your dashboard, resolve that before moving on.

## What you can track

- **Viewer engagement** - understand how users interact with your videos.
- **Playback quality (QoE)** - real-time metrics including bitrate, buffering, startup performance, render quality, and playback-failure errors.
- **Error management** - detailed, automatic error reports to find and fix playback failures quickly.
- **Customizable tracking** - pass your own metadata to match how you slice analytics.
- **A centralized dashboard** - visualize and compare metrics on the [FastPix dashboard](https://dashboard.fastpix.com) to make data-driven decisions.

## Before you begin

To complete this integration you need:

- **A Mac with Xcode** and an iOS app targeting **iOS 13 or later**.
- **THEOplayer already integrated** in your app (this SDK measures a THEOplayer you create; it is not a player itself). If you are new to THEOplayer, see the [THEOplayer iOS SDK](https://github.com/THEOplayer/theoplayer-sdk-apple).
- **A FastPix account** - sign up on the [FastPix dashboard](https://dashboard.fastpix.com).
- **Your FastPix workspace key** - see [step 1](#1-get-your-fastpix-workspace-key).
- **A THEOplayer license** - see [step 2](#2-get-your-theoplayer-license).

---

## 1. Get your FastPix workspace key

The SDK sends analytics to a FastPix **workspace**, identified by a workspace key. To find yours:

1. Log in to the [FastPix dashboard](https://dashboard.fastpix.com) and open the **Workspaces** section.
2. Copy the **Workspace Key** for the workspace you want the data to land in.

You will pass this value as `workspace_id` in the metadata (shown in [step 5](#5-initialize-and-attach-the-tracker)). Learn more in [Set up a workspace](https://fastpix.com/docs/getting-started/set-up-a-workspace).

## 2. Get your THEOplayer license

THEOplayer will not play video until it is given a license bound to your app's bundle identifier. Create one at [portal.theoplayer.com](https://portal.theoplayer.com) (**SDKs → iOS**) for the bundle ID you build with, and pass it via `THEOplayerConfiguration` when you create the player (shown in [step 5](#5-initialize-and-attach-the-tracker)).

## 3. Install the SDK

Add the package to your iOS project with **Swift Package Manager**:

1. **Open your Xcode project** and navigate to:
   ```
   File → Add Packages…
   ```

2. **Enter the repository URL** for the FastPix SDK:
   ```
   https://github.com/FastPix/iOS-theoplayer-data.git
   ```

3. **Choose the latest stable version** and click `Add Package`.

4. **Select the target** where you want to use the SDK and click `Add Package`.

Xcode resolves the SDK along with its dependencies (the [FastPix iOS Data Core SDK](https://github.com/FastPix/iOS-core-data-sdk) and the THEOplayer iOS SDK).

## 4. Import the SDK

Import the SDK into the Swift file where you create your player:

```swift
import THEOplayerWrapper
```

## 5. Initialize and attach the tracker

Create an instance of `THEOplayerTracker` and attach it to your `THEOplayer`. Replace `WORKSPACE_KEY` with the workspace key from [step 1](#1-get-your-fastpix-workspace-key) and `YOUR_THEOPLAYER_LICENSE` with the license from [step 2](#2-get-your-theoplayer-license).

```swift
import THEOplayerSDK
import THEOplayerWrapper

// Create the player with your THEOplayer license.
let builder = THEOplayerConfigurationBuilder()
builder.license = "YOUR_THEOPLAYER_LICENSE"
let player = THEOplayer(configuration: builder.build())

let fpDataSDK = THEOplayerTracker()

let customMetadata: [String: Any] = [
  "data": [
        "workspace_id": "WORKSPACE_KEY", // Unique key to identify your workspace (replace with your actual workspace key)
        "video_title": "Test Content", // Title of the video being played (replace with the actual title of your video)
        "video_id": "f01a98s76t90p88i67x", // A unique identifier for the video (replace with your actual video ID for tracking purposes)
  ]
]

// Track THEOplayer
fpDataSDK.trackTheoPlayer(
    player: player,                  // The THEOplayer instance managing the playback
    customMetadata: customMetadata,
    automaticErrorTracking: true     // Let the SDK report player errors automatically
)
```

## 6. Add player metadata

Check out the [user-passable metadata](https://fastpix.com/docs/video-data/pass-custom-metadata-to-metrics) documentation to see the metadata supported by FastPix. You can use custom metadata fields like `custom_1` to `custom_10` for your business logic, giving you the flexibility to pass any required values. Named attributes, such as `video_title` and `video_id`, can be passed directly as they are.

```swift
let customMetadata: [String: Any] = [
    "data": [
        "workspace_id": "WORKSPACE_KEY", // Unique key to identify your workspace (replace with your actual workspace key)
        "video_title": "Test Content", // Title of the video being played (replace with the actual title of your video)
        "video_id": "f01a98s76t90p88i67x", // A unique identifier for the video (replace with your actual video ID for tracking purposes)
        "viewer_id": "user12345", // A unique identifier for the viewer (e.g., user ID, session ID, or any other unique value)
        "video_content_type": "series", // Type of content being played (e.g., series, movie, etc.)
        "video_stream_type": "on-demand", // Type of streaming (e.g., live, on-demand)

        // Custom fields for additional business logic
        "custom_1": "", // Use this field to pass any additional data needed for your specific business logic
        "custom_2": "", // Use this field to pass any additional data needed for your specific business logic

        // Add any additional metadata
    ]
]
```

> **Tip:** Keep metadata consistent across different video loads to make comparison easier in your analytics dashboard.

## 7. Verify your integration

Run your app and play a video in the THEOplayer you attached the tracker to. Then:

1. Open the [FastPix dashboard](https://dashboard.fastpix.com) and select the workspace whose key you used.
2. Open the **Video Data** views and confirm a new view appears for the title or `video_id` you passed. Metrics such as startup time, buffering, and playback state populate as the session plays.

If no data appears, check that:

- The `workspace_id` matches the workspace you are viewing.
- Your THEOplayer license is valid for the app's bundle identifier (otherwise playback never starts, so there is nothing to measure).
- The device has an active internet connection.
- You attached the tracker to the same `THEOplayer` instance that is actually playing.

## 8. Track new videos in the same player

When your app plays multiple videos back-to-back in the same player, notify the FastPix SDK whenever a new video starts, for example in a playlist, a video series, or any next video the user plays. Call `videoChange` with the new video's metadata:

```swift
import THEOplayerWrapper

let fpDataSDK = THEOplayerTracker()

fpDataSDK.trackTheoPlayer(
    player: player,
    customMetadata: customMetadata,
    automaticErrorTracking: true
)

fpDataSDK.videoChange(customMetadata: [
    "video_id": "123def", // Unique identifier for the new video
    "video_title": "Daalcheeni", // Title of the new video
    "video_series": "Comedy Capsule", // Series name if applicable

    // ... and other metadata
])
```

## 9. Understand the data workflow

You attach the tracker once. From there, THEOplayer's playback events flow through this SDK and the FastPix Data Core SDK to your dashboard, where they become viewer and quality-of-experience metrics.

![FastPix data workflow for THEOplayer on iOS: your app and THEOplayer, attach the tracker, FastPix Data Core SDK, playback and QoE events, then the FastPix dashboard.](theoplayer-data-workflow.png)

---

## Full working examples

The [`Examples/`](Examples) directory has two runnable apps that wire a THEOplayer to this SDK end to end:

- [`UIKit/`](Examples/UIKit) - THEOplayer in a `UIViewController` (iOS 15+).
- [`SwiftUI/`](Examples/SwiftUI) - THEOplayer in a `UIViewRepresentable` (iOS 16+).

Open a folder's `.xcodeproj`, add your THEOplayer license, press **Run**, and watch views appear on [dashboard.fastpix.com](https://dashboard.fastpix.com).

## FAQ

**How do I add FastPix analytics to THEOplayer on iOS?**
Install this SwiftPM package, `import THEOplayerWrapper`, then create a `THEOplayerTracker` and call `trackTheoPlayer(player:customMetadata:automaticErrorTracking:)` with your player and workspace key. See [Start here](#start-here).

**Where do I get my workspace key?**
From the **Workspaces** section of the [FastPix dashboard](https://dashboard.fastpix.com). See [step 1](#1-get-your-fastpix-workspace-key).

**Why is video not playing in my app?**
THEOplayer needs a valid license bound to your bundle identifier. Create one at [portal.theoplayer.com](https://portal.theoplayer.com). See [step 2](#2-get-your-theoplayer-license).

**Do I need to track errors manually?**
No. Pass `automaticErrorTracking: true` and the SDK reports player errors for you.

**How do I track a playlist or a series?**
Call `videoChange` with the new video's metadata each time a new video starts in the same player. See [step 8](#8-track-new-videos-in-the-same-player).

**What metadata can I send?**
Named fields such as `video_title`, `video_id`, `viewer_id`, and `video_stream_type`, plus `custom_1` to `custom_10` for your own business logic. See [Pass custom metadata to metrics](https://fastpix.com/docs/video-data/pass-custom-metadata-to-metrics).

**How long before analytics appear in the dashboard?**
Views appear in near real time once a session plays. See [step 7](#7-verify-your-integration).

**Which iOS versions and THEOplayer versions are supported?**
iOS 13 and later, with THEOplayer for iOS 9.0 and later.

## Which FastPix video data SDK should I use?

FastPix has a data SDK for the player you already use. Pick the one that matches your stack:

| Platform | Player | Repository |
|---|---|---|
| **iOS** | THEOplayer (this repo) | [iOS-theoplayer-data](https://github.com/FastPix/iOS-theoplayer-data) |
| iOS | AVPlayer | [iOS-data-avplayer-sdk](https://github.com/FastPix/iOS-data-avplayer-sdk) |
| iOS | Core data SDK | [iOS-core-data-sdk](https://github.com/FastPix/iOS-core-data-sdk) |
| Android | THEOplayer | [android-data-theoplayer](https://github.com/FastPix/android-data-theoplayer) |
| Web | Shaka Player | [web-video-data-shakaplayer-sdk](https://github.com/FastPix/web-video-data-shakaplayer-sdk) |
| Web | Video.js | [web-videojs-data-monitoring](https://github.com/FastPix/web-videojs-data-monitoring) |
| Flutter | Better Player | [flutter-data-better-player](https://github.com/FastPix/flutter-data-better-player) |
| React Native | - | [react-native-video-data](https://github.com/FastPix/react-native-video-data) |
| Roku | - | [Roku-data-core-SDK](https://github.com/FastPix/Roku-data-core-SDK) |

Browse every SDK in the [FastPix organization](https://github.com/orgs/FastPix/repositories).

## Documentation and resources

- [Monitor THEOplayer with FastPix](https://fastpix.com/docs/video-data/monitors/theoplayer) - the official integration guide.
- [Video Data overview](https://fastpix.com/docs/video-data/overview) - how FastPix analytics works.
- [Pass custom metadata to metrics](https://fastpix.com/docs/video-data/pass-custom-metadata-to-metrics) - every supported metadata field.
- [Set up a workspace](https://fastpix.com/docs/getting-started/set-up-a-workspace) - workspaces and workspace keys.
- [CHANGELOG.md](CHANGELOG.md) - release history.

## License

This project is licensed under the [Apache License 2.0](LICENSE).

## Support

For issues, questions, or feature requests, open an issue on this repository or contact FastPix support through the [dashboard](https://dashboard.fastpix.com).
