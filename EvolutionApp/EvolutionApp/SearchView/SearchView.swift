//
//  SearchView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit

class SearchView: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var searchResults: [Track] = []
    private var allTracks: [Track] = []
    private var playlists: [Playlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        loadPlaylists()
        setupMockTracks()
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Enter name of track"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupMockTracks() {
        allTracks = [
            Track(artist: "The Beatlse", title: "Hey Jude"),
            Track(artist: "Qeen", title: "Boheimen Rhapsody"),
            Track(artist: "Ed Sheeran", title: "Shape of You"),
            Track(artist: "Adele", title: "Hello"),
            Track(artist: "Drake", title: "In my Feelings")
        ]
    }
    
    //MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = allTracks.filter { track in
                track.artist.lowercased().contains(searchText.lowercased()) ||
                track.title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let track = searchResults[indexPath.row]
        cell.textLabel?.text = track.title
        cell.detailTextLabel?.text = track.artist
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTrack = searchResults[indexPath.row]
        showPlaylistSelection(for: selectedTrack)
    }
    
    //MARK: - Playlist Selection
    func showPlaylistSelection(for track: Track) {
        let alert = UIAlertController(title: "Add to playlist", message: "Select a playlist", preferredStyle: .actionSheet)
        
        for (index, playlist) in playlists.enumerated() {
            let action = UIAlertAction(title: playlist.name, style: .default) { _ in
                self.addTrack(track, toPlaylistAt: index)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addTrack(_ track: Track, toPlaylistAt index: Int) {
        playlists[index].tracks.append(track)
        savePlayLists()
        showAlert(message: "Track \(track.title) added to \(playlists[index].name)!")
    }
    
    func savePlayLists() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playlists) {
            UserDefaults.standard.set(encoded, forKey: "playlists")
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadPlaylists() {
        if let saveData = UserDefaults.standard.data(forKey: "playlists"),
           let decoded = try? JSONDecoder().decode([Playlist].self, from: saveData) {
            playlists = decoded
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true , completion: nil)
    }
}
