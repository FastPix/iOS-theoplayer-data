import UIKit
import THEOplayerSDK
import THEOplayerWrapper

/// Creates a THEOplayer, renders it, and attaches the FastPix THEOplayer SDK
/// to collect playback analytics.
final class PlayerViewController: UIViewController {

    private let video: SampleVideo
    private var player: THEOplayer?
    // Hold a strong reference so tracking lives for the whole playback session.
    private let tracker = THEOplayerTracker()
    private let playerContainer = UIView()

    init(video: SampleVideo) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = video.title
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemGroupedBackground
        setUpLayout()
        setUpPlayer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player?.frame = playerContainer.bounds
    }

    // MARK: - THEOplayer + FastPix integration

    private func setUpPlayer() {
        // THEOplayer requires a license bound to this app's bundle id.
        let builder = THEOplayerConfigurationBuilder()
        builder.license = Config.theoLicense
        let player = THEOplayer(configuration: builder.build())
        player.addAsSubview(of: playerContainer)
        self.player = player

        // Attach FastPix analytics. All metadata fields live under the "data" key.
        tracker.trackTheoPlayer(
            player: player,
            customMetadata: ["data": trackedFields],
            automaticErrorTracking: true
        )

        player.source = SourceDescription(source: TypedSource(src: video.url.absoluteString, type: video.mimeType))
        player.play()
    }

    deinit {
        // THEOplayer tears down when its last reference is dropped.
        tracker.resetInitialization()
        player = nil
    }

    /// The metadata reported to FastPix (also shown in the card below).
    private var trackedFields: [String: Any] {
        [
            "workspace_id": Config.workspaceKey,
            "video_title": video.title,
            "video_id": video.id,
            "viewer_id": "user-12345",
            "video_content_type": "movie",
            "video_stream_type": "on-demand",
            "player_name": "FastPixTHEOUIKitExample"
        ]
    }

    // MARK: - Layout

    private func setUpLayout() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        playerContainer.backgroundColor = .black
        playerContainer.layer.cornerRadius = 16
        playerContainer.layer.cornerCurve = .continuous
        playerContainer.clipsToBounds = true
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        playerContainer.heightAnchor.constraint(equalTo: playerContainer.widthAnchor, multiplier: 9.0 / 16.0).isActive = true

        stack.addArrangedSubview(playerContainer)
        stack.addArrangedSubview(makeStatusPill())
        stack.addArrangedSubview(makeMetadataCard())
    }

    private func makeStatusPill() -> UIView {
        let (text, color): (String, UIColor)
        if !Config.hasTheoLicense {
            (text, color) = ("Add your THEOplayer license to play", .systemRed)
        } else if !Config.hasWorkspaceKey {
            (text, color) = ("Add your Workspace Key to track", .systemOrange)
        } else {
            (text, color) = ("FastPix tracking active", .systemGreen)
        }

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false

        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 4
        dot.translatesAutoresizingMaskIntoConstraints = false

        let pill = UIView()
        pill.backgroundColor = color.withAlphaComponent(0.12)
        pill.layer.cornerRadius = 14
        pill.addSubview(dot)
        pill.addSubview(label)
        NSLayoutConstraint.activate([
            pill.heightAnchor.constraint(equalToConstant: 40),
            dot.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 16),
            dot.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 8),
            dot.heightAnchor.constraint(equalToConstant: 8),
            label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: pill.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: pill.centerYAnchor)
        ])
        return pill
    }

    private func makeMetadataCard() -> UIView {
        let header = UILabel()
        header.text = "TRACKED METADATA"
        header.font = .systemFont(ofSize: 13, weight: .semibold)
        header.textColor = .secondaryLabel

        let rows = UIStackView()
        rows.axis = .vertical
        rows.spacing = 8
        let order = ["workspace_id", "video_id", "video_title", "video_content_type", "video_stream_type", "viewer_id", "player_name"]
        for key in order {
            let value = trackedFields[key].map { "\($0)" } ?? "—"
            let k = UILabel()
            k.text = key
            k.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
            k.textColor = .secondaryLabel
            k.setContentHuggingPriority(.required, for: .horizontal)
            let v = UILabel()
            v.text = value
            v.font = .systemFont(ofSize: 14, weight: .medium)
            v.textColor = .label
            v.textAlignment = .right
            v.numberOfLines = 0
            let row = UIStackView(arrangedSubviews: [k, v])
            row.axis = .horizontal
            row.spacing = 12
            rows.addArrangedSubview(row)
        }

        let stack = UIStackView(arrangedSubviews: [header, rows])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 16
        card.layer.cornerCurve = .continuous
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        return card
    }
}
