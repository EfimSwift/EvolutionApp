//
//  PlaylistDetailView.swift
//  EvolutionApp
//
//  Created by user on 19.03.2025.
//

import UIKit
import CoreData

class PlaylistDetailView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let album: Album
    private let tableView = UITableView()
    private var tracks: [Tracks] = []
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = album.name
        
        loadTracks()
        setupTableView()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidChange), name: NSNotification.Name("DataDidChange"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func loadTracks() {
        if let trackSet = album.tracks as? Set<Tracks> {
            tracks = Array(trackSet).sorted { ($0.title ?? "") < ($1.title ?? "") }
        } else {
            tracks = []
        }
    }
    
    @objc func dataDidChange() {
        loadTracks()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.title
        cell.detailTextLabel?.text = track.artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = CoreDataStack.shared.context
            let trackToDelete = tracks[indexPath.row]
            context.delete(trackToDelete)
            CoreDataStack.shared.saveContext()
            
            tracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            NotificationCenter.default.post(name: NSNotification.Name("DataDidChange"), object: nil)
        }
    }
}
