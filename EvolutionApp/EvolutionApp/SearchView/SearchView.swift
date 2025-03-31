//
//  SearchView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit
import CoreData

class SearchView: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private var searchResults: [Tracks] = []
    private var allTracks: [Tracks] = []
    private var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        loadAlbums()
        setupMockTracks()
        setupUI()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidChange), name: NSNotification.Name("DataDidChange"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        let context = CoreDataStack.shared.context
        
        // Проверяем, есть ли уже треки в Core Data
        let fetchRequest: NSFetchRequest<Tracks> = Tracks.fetchRequest()
        do {
            allTracks = try context.fetch(fetchRequest)
            if allTracks.isEmpty {
                // Если треков нет, создаём тестовые
                let tracksData = [
                    ("The Beatles", "Hey Jude"),
                    ("Queen", "Bohemian Rhapsody"),
                    ("Ed Sheeran", "Shape of You"),
                    ("Adele", "Hello"),
                    ("Drake", "In my Feelings")
                ]
                
                for (artist, title) in tracksData {
                    let track = Tracks(context: context)
                    track.artist = artist
                    track.title = title
                    allTracks.append(track)
                }
                try CoreDataStack.shared.saveContext()
            }
        } catch {
            print("Error fetching or saving tracks: \(error)")
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = allTracks.filter { track in
                (track.artist?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (track.title?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UITableViewDataSource
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
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTrack = searchResults[indexPath.row]
        showPlaylistSelection(for: selectedTrack)
    }
    
    // MARK: - Playlist Selection
    func showPlaylistSelection(for track: Tracks) {
        let alert = UIAlertController(title: "Add to playlist", message: "Select a playlist", preferredStyle: .actionSheet)
        
        for (index, album) in albums.enumerated() {
            let action = UIAlertAction(title: album.name, style: .default) { _ in
                self.addTrack(track, toAlbum: self.albums[index])
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addTrack(_ track: Tracks, toAlbum album: Album) {
        let context = CoreDataStack.shared.context
        
        // Создаём копию трека, чтобы не добавлять один и тот же объект в разные альбомы
        let newTrack = Tracks(context: context)
        newTrack.artist = track.artist
        newTrack.title = track.title
        newTrack.album = album
        
        do {
            try CoreDataStack.shared.saveContext()
            showAlert(message: "Track \(track.title ?? "Unknown") added to \(album.name ?? "Unknown")!")
            NotificationCenter.default.post(name: NSNotification.Name("DataDidChange"), object: nil)
        } catch {
            print("Error saving track: \(error)")
            showAlert(message: "Failed to add track: \(error.localizedDescription)")
        }
    }
    
    func loadAlbums() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            albums = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching albums: \(error)")
        }
    }
    
    @objc func dataDidChange() {
        loadAlbums()
        tableView.reloadData()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
