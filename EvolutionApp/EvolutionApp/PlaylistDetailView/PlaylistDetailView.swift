//
//  PlaylistDetailView.swift
//  EvolutionApp
//
//  Created by user on 19.03.2025.
//

import UIKit

class PlaylistDetailView: UIViewController {
    private var playlist: Playlist
    private let tableView = UITableView()
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = playlist.name
        
        setupTableView()
        setupConstraints()
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
    
    func savePlaylists(playlists: [Playlist]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playlists) {
            UserDefaults.standard.set(encoded, forKey: "playlists")
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadPlaylists() -> [Playlist] {
        if let savedData = UserDefaults.standard.data(forKey: "playlists"),
           let decoded = try? JSONDecoder().decode([Playlist].self, from: savedData) {
            return decoded
        }
        return []
    }
}

extension PlaylistDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let track = playlist.tracks[indexPath.row]
        cell.textLabel?.text = track.title
        cell.detailTextLabel?.text = track.artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playlist.tracks.remove(at: indexPath.row)
            
            var playlists = loadPlaylists()
            
            if let index = playlists.firstIndex(where: { $0.name == playlist.name }) {
                playlists[index] = playlist
                savePlaylists(playlists: playlists)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
