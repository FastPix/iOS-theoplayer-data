import SwiftUI

/// Demo configuration — replace these with your own values.
enum Config {
    /// FastPix Workspace Key — dashboard.fastpix.com → **Workspaces**.
    static let workspaceKey = "1029207880411545601"

    /// THEOplayer requires a license bound to your app's bundle identifier.
    /// Create one at https://portal.theoplayer.com (SDKs → iOS) for the bundle
    /// id you build with, then paste the license string here. The app compiles
    /// without it, but THEOplayer refuses to play until a valid license is set.
    static let theoLicense = "YOUR_THEOPLAYER_LICENSE"

    static var hasWorkspaceKey: Bool { workspaceKey != "YOUR_WORKSPACE_KEY" && !workspaceKey.isEmpty }
    static var hasTheoLicense: Bool { theoLicense != "YOUR_THEOPLAYER_LICENSE" && !theoLicense.isEmpty }

    static let playerName = "FastPixTHEOSwiftUIExample"

    /// Metadata fields reported to FastPix (also shown on the player screen).
    static func fields(for video: SampleVideo) -> [(String, String)] {
        [
            ("workspace_id", workspaceKey),
            ("video_id", video.id),
            ("video_title", video.title),
            ("video_content_type", "movie"),
            ("video_stream_type", "on-demand"),
            ("viewer_id", "user-12345"),
            ("player_name", playerName)
        ]
    }

    static func metadata(for video: SampleVideo) -> [String: Any] {
        Dictionary(uniqueKeysWithValues: fields(for: video).map { ($0.0, $0.1 as Any) })
    }
}

/// A sample HLS stream shown on the home screen.
struct SampleVideo: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let url: URL
    let mimeType: String
}

let sampleVideos: [SampleVideo] = [
    SampleVideo(id: "sample-video-001", title: "Big Buck Bunny",
                subtitle: "Blender Foundation · HLS",
                url: URL(string: "https://stream.fastpix.io/16ac212a-0f4f-49c5-9fd7-a42d9ff61541.m3u8")!,
                mimeType: "application/x-mpegurl"),
    SampleVideo(id: "sample-video-002", title: "Apple Basic Stream",
                subtitle: "Multi-variant · HLS",
                url: URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!,
                mimeType: "application/x-mpegurl")
]

enum Theme {
    static let accent = Color(red: 0.235, green: 0.353, blue: 0.937)
    static let accentDark = Color(red: 0.145, green: 0.204, blue: 0.639)
}
