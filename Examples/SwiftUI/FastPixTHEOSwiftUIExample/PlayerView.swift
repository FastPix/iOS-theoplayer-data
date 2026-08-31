import SwiftUI
import THEOplayerSDK
import THEOplayerWrapper

/// Owns the THEOplayer and the FastPix tracker for one playback session.
///
/// The player and the SDK live here — in an `ObservableObject` held by
/// `@StateObject` — not in the `View` struct, which SwiftUI recreates on every
/// render. `attach` sets the source and wires analytics; `teardown` stops
/// tracking when the screen goes away.
@MainActor
final class PlayerModel: ObservableObject {
    let player: THEOplayer
    private let tracker = THEOplayerTracker()
    private let video: SampleVideo
    private var started = false

    init(video: SampleVideo) {
        self.video = video
        // THEOplayer requires a license bound to this app's bundle id.
        let builder = THEOplayerConfigurationBuilder()
        builder.license = Config.theoLicense
        player = THEOplayer(configuration: builder.build())
    }

    func attach() {
        guard !started else { return }
        started = true

        // Attach FastPix analytics. All metadata fields live under the "data" key.
        tracker.trackTheoPlayer(
            player: player,
            customMetadata: ["data": Config.metadata(for: video)],
            automaticErrorTracking: true
        )

        player.source = SourceDescription(source: TypedSource(src: video.url.absoluteString, type: video.mimeType))
        player.play()
    }

    func teardown() {
        player.pause()
        tracker.resetInitialization()
    }
}

/// Renders a THEOplayer (a UIKit view) inside SwiftUI.
private struct TheoPlayerView: UIViewRepresentable {
    let player: THEOplayer

    func makeUIView(context: Context) -> PlayerHostView {
        let host = PlayerHostView()
        host.backgroundColor = .black
        player.addAsSubview(of: host)
        host.player = player
        return host
    }

    func updateUIView(_ uiView: PlayerHostView, context: Context) {}

    /// Keeps the THEOplayer's frame matched to the SwiftUI-driven bounds.
    final class PlayerHostView: UIView {
        weak var player: THEOplayer?
        override func layoutSubviews() {
            super.layoutSubviews()
            player?.frame = bounds
        }
    }
}

/// Plays a stream in a THEOplayer with the FastPix SDK attached.
struct PlayerView: View {
    let video: SampleVideo
    @StateObject private var model: PlayerModel

    init(video: SampleVideo) {
        self.video = video
        _model = StateObject(wrappedValue: PlayerModel(video: video))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TheoPlayerView(player: model.player)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.18), radius: 12, y: 6)

                statusPill
                metadataCard
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(video.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { model.attach() }
        .onDisappear { model.teardown() }
    }

    private var statusPill: some View {
        let (text, color): (String, Color)
        if !Config.hasTheoLicense {
            (text, color) = ("Add your THEOplayer license to play", .red)
        } else if !Config.hasWorkspaceKey {
            (text, color) = ("Add your Workspace Key to track", .orange)
        } else {
            (text, color) = ("FastPix tracking active", .green)
        }
        return HStack(spacing: 10) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text).font(.system(size: 14, weight: .semibold)).foregroundStyle(color)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16).frame(height: 40)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var metadataCard: some View {
        let rows = Config.fields(for: video)
        return VStack(alignment: .leading, spacing: 12) {
            Text("TRACKED METADATA")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    HStack {
                        Text(row.0)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundStyle(.secondary)
                        Spacer(minLength: 12)
                        Text(row.1)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.vertical, 11)
                    if index < rows.count - 1 { Divider() }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
