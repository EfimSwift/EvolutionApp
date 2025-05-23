//
//  PlaylistView.swift
//  EvolutionApp
//
//  Created by user on 17.03.2025.
//

import UIKit
import CoreData

class PlaylistView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let createPlaylistButton = UIButton()
    private var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Плейлист"
        
        loadAlbums()
        setupUI()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidChange), name: NSNotification.Name("DataDidChange"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAlbums()
        tableView.reloadData()
    }
    
    func setupUI() {
        createPlaylistButton.setTitle("Add playlist", for: .normal)
        createPlaylistButton.setTitleColor(.white, for: .normal)
        createPlaylistButton.backgroundColor = .systemBlue
        createPlaylistButton.layer.cornerRadius = 10
        createPlaylistButton.translatesAutoresizingMaskIntoConstraints = false
        createPlaylistButton.addTarget(self, action: #selector(createPlaylistTapped), for: .touchUpInside)
        view.addSubview(createPlaylistButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            createPlaylistButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            createPlaylistButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createPlaylistButton.widthAnchor.constraint(equalToConstant: 200),
            createPlaylistButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: createPlaylistButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - tableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = albums[indexPath.row].name
        return cell
    }
    
    // MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
        let playlistDetailView = PlaylistDetailView(album: album)
        navigationController?.pushViewController(playlistDetailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = CoreDataStack.shared.context
            let albumToDelete = albums[indexPath.row]
            context.delete(albumToDelete)
            
            do {
                try CoreDataStack.shared.saveContext()
                albums.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                NotificationCenter.default.post(name: NSNotification.Name("DataDidChange"), object: nil)
            } catch {
                print("Error saving context after deletion: \(error)")
                showAlert(message: "Failed to delete playlist: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Selectors
    @objc func createPlaylistTapped() {
        let alert = UIAlertController(title: "Новый плейлист", message: "Введите название плейлиста", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Название плейлиста"
        }
        
        let createAction = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let playlistName = alert.textFields?.first?.text, !playlistName.isEmpty else {
                self.showAlert(message: "Название плейлиста не может быть пустым!")
                return
            }
            
            let context = CoreDataStack.shared.context
            let newAlbum = Album(context: context)
            newAlbum.name = playlistName
            newAlbum.createdAt = Date()
            
            do {
                try CoreDataStack.shared.saveContext()
                self.loadAlbums()
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("DataDidChange"), object: nil)
            } catch {
                print("Error saving new album: \(error)")
                self.showAlert(message: "Failed to create playlist: \(error.localizedDescription)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dataDidChange() {
        loadAlbums()
        tableView.reloadData()
    }
    
    // MARK: - persistence
    func loadAlbums() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            albums = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching albums: \(error)")
            showAlert(message: "Failed to load playlists: \(error.localizedDescription)")
        }
    }
    
    // MARK: - alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
