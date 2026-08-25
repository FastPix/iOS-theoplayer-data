import SwiftUI

/// Landing screen listing sample streams. Selecting one opens `PlayerView`,
/// where THEOplayer is created and the FastPix THEOplayer SDK is attached.
struct HomeView: View {
    var body: some View {
        List {
            Section("Sample Streams") {
                ForEach(sampleVideos) { video in
                    NavigationLink(value: video) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(video.title).font(.system(size: 17, weight: .semibold))
                                Text(video.subtitle).font(.footnote).foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "play.circle.fill")
                                .foregroundStyle(Theme.accent)
                                .font(.title2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("FastPix · THEOplayer")
        .navigationDestination(for: SampleVideo.self) { PlayerView(video: $0) }
    }
}
