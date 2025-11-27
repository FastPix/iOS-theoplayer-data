---
name: Documentation Issue
about: Report problems with the FastPix iOS Video Data THEOPlayer SDK documentation
title: '[DOCS] '
labels: ['documentation', 'needs-triage']
assignees: ''
---

# Documentation Issue

Thank you for helping improve the FastPix iOS Video Data THEOPlayer SDK documentation! Please provide the following information:

## Issue Type
- [ ] Missing documentation
- [ ] Incorrect information
- [ ] Unclear explanation
- [ ] Broken links
- [ ] Outdated content
- [ ] Other: _______________

## Description
**Clear description of the documentation issue:**

<!-- What's wrong with the documentation? -->

## Current Documentation
**What does the current documentation say?**

<!-- Paste the current documentation content -->

## Expected Documentation
**What should the documentation say instead?**

```swift
// Correct usage example for FastPix THEOPlayer SDK
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

// Dispatch events
fpDataSDK.dispatchEvent(event: "playing", metadata: [:])
fpDataSDK.dispatchEvent(event: "pause", metadata: [:])
fpDataSDK.dispatchEvent(event: "buffering", metadata: [:])
fpDataSDK.dispatchEvent(event: "error", metadata: ["player_error_code": "404"])
```

## Location
**Where is this documentation issue located?**

- [ ] README.md
- [ ] docs/ directory
- [ ] USAGE.md
- [ ] CONTRIBUTING.md
- [ ] API documentation
- [ ] Code examples
- [ ] Other: _______________

**Specific file and section:**
<!-- e.g., README.md line 45, or docs/api-reference.md section "Authentication" -->

## Impact
**How does this documentation issue affect users?**

- [ ] Blocks new users from getting started
- [ ] Causes confusion for existing users
- [ ] Leads to incorrect implementation
- [ ] Creates support requests
- [ ] Other: _______________

## Proposed Fix
**How would you like this documentation issue to be resolved?**

<!-- Describe the correction or updated example that should appear -->

## Additional Context
Add any other context about the documentation issue here.

## Screenshots
<!-- If applicable, include screenshots of the documentation issue -->

### Related Issues
- **GitHub Issues:** [Link to any related issues]
- **User Feedback:** [Link to user complaints or confusion]

### Testing
**How did you discover this issue?**

- [ ] While following the documentation
- [ ] User reported confusion
- [ ] Code didn't work as documented
- [ ] Other: _______________

## Priority
Please indicate the priority of this documentation issue:

- [ ] Critical (Blocks users from using the SDK)
- [ ] High (Causes significant confusion)
- [ ] Medium (Minor clarity issue)
- [ ] Low (Cosmetic improvement)

## Checklist
Before submitting, please ensure:

- [ ] I have identified the specific documentation issue
- [ ] I have provided the current and expected content
- [ ] I have explained the impact on users
- [ ] I have proposed a clear fix
- [ ] I have checked if this is already reported
- [ ] I have provided sufficient context

---

**Thank you for helping improve the FastPix iOS Video Data THEOPlayer SDK documentation! 📚**
