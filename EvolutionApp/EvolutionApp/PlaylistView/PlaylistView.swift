//
//  PlaylistView.swift
//  EvolutionApp
//
//  Created by user on 17.03.2025.
//

import UIKit

class PlaylistView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let createPlaylistButton = UIButton()
    private var playlists: [Playlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Плейлист"
        
        loadPlaylists()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlaylists()
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
    
    //MARK: - tableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = playlists[indexPath.row].name
        return cell
    }
    
    //MARK: - tableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let playlistDetailView = PlaylistDetailView(playlist: playlist)
        navigationController?.pushViewController(playlistDetailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playlists.remove(at: indexPath.row)
            savePlaylists()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - Selectors
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
            
            let newPlaylist = Playlist(name: playlistName, tracks: [])
            self.playlists.append(newPlaylist)
            self.savePlaylists()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - persistence
    func savePlaylists() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(playlists) {
            UserDefaults.standard.set(encoded, forKey: "playlists")
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadPlaylists() {
        if let savedData = UserDefaults.standard.data(forKey: "playlists"),
           let decoded = try? JSONDecoder().decode([Playlist].self, from: savedData) {
            playlists = decoded
        } else {
            playlists = []
        }
    }
    
    //MARK: - alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
