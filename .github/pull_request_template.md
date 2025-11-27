# FastPix Video Data THEOPlayer SDK - Documentation PR

## Documentation Changes

### What Changed
- [ ] New documentation added
- [ ] Existing documentation updated
- [ ] Documentation errors fixed
- [ ] Code examples updated
- [ ] Links and references updated

### Files Modified
- [ ] README.md
- [ ] docs/ files
- [ ] USAGE.md
- [ ] CONTRIBUTING.md
- [ ] Other: _______________

### Summary
**Brief description of changes:**

<!-- Describe what documentation was added, updated, or fixed for the THEOPlayer iOS SDK -->

### Code Examples
```swift
import THEOplayerWrapper

// Initialize the FastPix SDK for tracking THEOPlayer analytics
let fpDataSDK = InitTHEOPlayerTracking()

// Configure metadata for the video
let customMetadata = [
    "data": [
        "workspace_id": "WORKSPACE_KEY",    // Your FastPix Workspace Key
        "video_title": "Test Content",      // Video title
        "video_id": "VIDEO_ID",             // Unique video identifier
        "viewer_id": "user12345",           // Optional: unique viewer identifier
        "video_content_type": "series",     // Type of content (movie, series, etc.)
        "video_stream_type": "on-demand",   // Type of streaming (live, on-demand)
        "custom_1": "",                     // Optional custom metadata
        "custom_2": ""
    ]
]

// Track THEOPlayer instance
fpDataSDK.trackTheoPlayer(
    player: THEOplayer,   // Your THEOPlayer instance
    customMetadata: customMetadata
)

// Dispatch example events
fpDataSDK.dispatchEvent(event: "playing", metadata: [:])
fpDataSDK.dispatchEvent(event: "pause", metadata: [:])
fpDataSDK.dispatchEvent(event: "seeking", metadata: [:])
fpDataSDK.dispatchEvent(event: "ended", metadata: [:])
fpDataSDK.dispatchEvent(event: "buffering", metadata: [:])
fpDataSDK.dispatchEvent(event: "error", metadata: [
    "player_error_code": "404",
    "player_error_message": "Video not found"
])

// Notify FastPix SDK of a video change (e.g., playlist or series)
fpDataSDK.dispatchEvent(event: "videoChange", metadata: [
    "video_id": "123def",
    "video_title": "Daalcheeni",
    "video_series": "Comedy Capsule"
])
```

### Testing
- [ ] All code examples tested on iOS
- [ ] Links verified
- [ ] Grammar checked
- [ ] Formatting consistent

### Review Checklist
- [ ] Content is accurate
- [ ] Code examples work as expected
- [ ] Links are working
- [ ] Grammar is correct
- [ ] Formatting is consistent

---

**Ready for review!**
