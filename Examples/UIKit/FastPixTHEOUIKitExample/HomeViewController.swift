import UIKit

/// Landing screen listing sample streams. Selecting one opens `PlayerViewController`,
/// where THEOplayer is created and the FastPix THEOplayer SDK is attached.
final class HomeViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 76
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FastPix · THEOplayer"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "SAMPLE STREAMS"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampleVideos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let video = sampleVideos[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = video.title
        content.secondaryText = video.subtitle
        content.image = UIImage(systemName: "play.circle.fill")
        content.imageProperties.tintColor = Theme.accent
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(PlayerViewController(video: sampleVideos[indexPath.row]), animated: true)
    }
}
