---
name: Question/Support
about: Ask questions or get help with the FastPix iOS Video Data THEOPlayer SDK
title: '[QUESTION] '
labels: ['question', 'needs-triage']
assignees: ''
---

# Question / Support

Thank you for reaching out! We're here to help you with the FastPix iOS Video Data THEOPlayer SDK. Please provide the following information.

## Question Type
- [ ] How to use a specific feature
- [ ] Integration help
- [ ] Configuration question
- [ ] Performance question
- [ ] Troubleshooting help
- [ ] Other: _______________

## Question
**What would you like to know?**

<!-- Provide a clear and specific question about the iOS SDK -->

## What You've Tried
**What have you already attempted?**

```swift
import THEOplayerWrapper

let fpDataSDK = InitTHEOPlayerTracking()

let customMetadata = [
  "data": [
        "workspace_id": "WORKSPACE_KEY",
        "video_title": "Test Content",
        "video_id": "VIDEO_ID"
    ]
]

fpDataSDK.trackTheoPlayer(
    player: THEOplayer, // Your THEOPlayer instance
    customMetadata: customMetadata
)

// Your attempted code here
```

## Current Setup
**Describe your current setup:**
- iOS project version, Swift version
- Player used (THEOPlayer, AVPlayer wrapper, custom player, etc.)
- Integration method (SPM, manual, Cocoapods, etc.)

## Environment
- **SDK Version**: [e.g., 1.0.0]
- **iOS Version**: [e.g., iOS 17.0]
- **Xcode Version**: [e.g., 15.0]
- **Device/Simulator**: [e.g., iPhone 14 Pro, Simulator]
- **Player**: [e.g., THEOPlayer, AVPlayer]

## Configuration
**Current SDK configuration:**

```swift
let fpDataSDK = InitTHEOPlayerTracking()

fpDataSDK.trackTheoPlayer(
    player: THEOplayer,
    customMetadata: [
        "data": [
            "workspace_id": "WORKSPACE_KEY",
            "video_title": "Test Content",
            "video_id": "VIDEO_ID"
        ]
    ]
)
```

## Expected Outcome
**What are you trying to achieve?**

<!-- Describe your end goal, e.g., track events, capture analytics, troubleshoot issues -->

## Error Messages (if any)
```
<!-- Paste any error messages or unexpected behavior -->
```

## Additional Context

### Use Case
**What are you building?**
- [ ] Mobile app
- [ ] Media analytics platform
- [ ] Video streaming service
- [ ] Other: _______________

### Timeline
**When do you need this resolved?**
- [ ] ASAP (blocking development)
- [ ] This week
- [ ] This month
- [ ] No rush

### Resources Checked
**What resources have you already checked?**
- [ ] README.md
- [ ] SDK documentation
- [ ] Examples
- [ ] Stack Overflow
- [ ] GitHub Issues
- [ ] Other: _______________

## Priority
Please indicate the urgency:
- [ ] Critical (Blocking production deployment)
- [ ] High (Blocking development)
- [ ] Medium (Would like to know soon)
- [ ] Low (Just curious)

## Checklist
Before submitting, please ensure:
- [ ] I have provided a clear question
- [ ] I have described what I've tried
- [ ] I have included my current setup and environment
- [ ] I have checked existing documentation
- [ ] I have provided sufficient context

---

**We'll do our best to help you get unstuck! 🚀**

**Helpful Resources:**
- [FastPix iOS SDK Documentation](https://github.com/FastPix/iOS-video-data-theoplayer)
- [FastPix Dashboard](https://dashboard.fastpix.io)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/fastpix)
- [GitHub Discussions](https://github.com/FastPix/iOS-video-data-theoplayer/discussions)
