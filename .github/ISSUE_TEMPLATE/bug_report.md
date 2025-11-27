---
name: Bug Report
about: Report an issue related to the FastPix iOS Video Data THEOPlayer SDK
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description
A clear and concise description of what the bug is.

---

## Reproduction Steps

### 1. **SDK Setup**

Add the FastPix iOS THEOPlayer SDK using Swift Package Manager:

```
https://github.com/fastpix/iOS-video-data-theoplayer.git
```

Import the library:

```swift
import THEOplayerWrapper
```

### 2. **Code To Reproduce**

Provide a minimal reproducible code snippet. Example:

```swift
import THEOplayerWrapper

let fpDataSDK = InitTHEOplayerTracking()

let customMetadata = [
  "data": [
        workspace_id: "WORKSPACE_KEY", // Replace with your actual workspace key
        video_title: "Test Content",   // Title of the video being played
        video_id: "f01a98s76t90p88i67x" // Unique identifier for the video
  ]
]

// Track THEOPlayer instance
fpDataSDK.trackTheoPlayer(
    player: THEOplayer,   // The THEOPlayer instance managing playback
    customMetadata: customMetadata
)

// Dispatch sample events
fpDataSDK.dispatchEvent(event: "playing", metadata: [:])
fpDataSDK.dispatchEvent(event: "pause", metadata: [:])
fpDataSDK.dispatchEvent(event: "buffering", metadata: [:])
fpDataSDK.dispatchEvent(event: "error", metadata: ["player_error_code": "404"])
```

Replace the above snippet with the exact code where the issue occurs.

---

## Expected Behavior
```
<!-- Describe what you expected to happen -->
```

## Actual Behavior
```
<!-- Describe what actually happened -->
```

---

## Environment

- **SDK Version**: [e.g., 1.0.0]  
- **iOS Version**: [e.g., iOS 17.2]  
- **Device/Simulator**: [e.g., iPhone 14 Pro, Xcode Simulator]  
- **Xcode Version**: [e.g., 15.3]  
- **Integration Method**: Swift Package Manager (SPM) / Manual  
- **Player Type**: THEOPlayer / Custom Player  

---

## Code Sample
```swift
// Provide a minimal reproducible sample here
```

## Logs / Errors / Stack Trace
```
Paste console logs, crash logs, or SDK error responses here
```

---

## Additional Context
Add any other context that would help us investigate the issue.

## Screenshots / Screen Recording
If applicable, attach screenshots or a video showing the problem.
