//
//  PlaylistDetailView.swift
//  EvolutionApp
//
//  Created by user on 19.03.2025.
//

import UIKit

class PlaylistDetailView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let playlistID: String
    private let tableView = UITableView()
    private var playlistData: [String: Any]?
    private var tracks: [[String: Any]] = []
    
    init(playlistID: String) {
        self.playlistID = playlistID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Loading..."

        setupTableView()
        setupConstraints()
        loadPlaylist()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func loadPlaylist() {
        SpotifyManager.shared.getPlaylist(playlistID: playlistID) { [weak self] data in
            guard let self = self else { return }
            self.playlistData = data
            
            if let playlistName = data?["name"] as? String {
                self.title = playlistName
            } else {
                self.title = "Unknown Playlist"
            }
            
            if let tracksData = data?["tracks"] as? [String: Any],
               let items = tracksData["items"] as? [[String: Any]] {
                self.tracks = items
            } else {
                self.tracks = []
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let trackItem = tracks[indexPath.row]
        
        if let track = trackItem["track"] as? [String: Any] {
            let trackName = track["name"] as? String ?? "Unknown Track"
            let artists = (track["artists"] as? [[String: Any]])?.compactMap { $0["name"] as? String }.joined(separator: ", ") ?? "Unknown Artist"
            
            cell.textLabel?.text = trackName
            cell.detailTextLabel?.text = artists
        } else {
            cell.textLabel?.text = "Unknown Track"
            cell.detailTextLabel?.text = "Unknown Artist"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
