//
//  HomeView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit
import CoreData

class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private var feedItems: [FeedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Главная"
        
        setupUI()
        setupConstraints()
        loadFeedItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidChange), name: NSNotification.Name("DataDidChange"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhotoFeedCell.self, forCellReuseIdentifier: PhotoFeedCell.identifier)
        tableView.register(PlaylistFeedCell.self, forCellReuseIdentifier: PlaylistFeedCell.identifier)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func loadFeedItems() {
        let context = CoreDataStack.shared.context
        
        var photos: [Photos] = []
        let photoRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        photoRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            photos = try context.fetch(photoRequest)
        } catch {
            print("Error fetching photos: \(error)")
        }
        
        var albums: [Album] = []
        let albumRequest: NSFetchRequest<Album> = Album.fetchRequest()
        albumRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            albums = try context.fetch(albumRequest)
        } catch {
            print("Error fetching albums: \(error)")
        }
        
        feedItems = []
        feedItems.append(contentsOf: photos.map { FeedItem.photo($0) })
        feedItems.append(contentsOf: albums.map { FeedItem.album($0) })
        
        feedItems.sort { $0.createdAt > $1.createdAt }
        
        tableView.reloadData()
    }
    
    @objc func dataDidChange() {
        loadFeedItems()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = feedItems[indexPath.row]
        
        switch feedItem {
        case .photo(let photo):
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoFeedCell.identifier, for: indexPath) as! PhotoFeedCell
            cell.configure(with: photo)
            return cell
        case .album(let album):
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistFeedCell.identifier, for: indexPath) as! PlaylistFeedCell
            cell.configure(with: album)
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        
        switch feedItem {
        case .photo(let photo):
            guard let imageData = photo.imageData, let image = UIImage(data: imageData) else { return }
            
            let imageViewController = UIViewController()
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = imageViewController.view.bounds
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageViewController.view.addSubview(imageView)
            navigationController?.pushViewController(imageViewController, animated: true)
            
        case .album(let album):
            let detailView = PlaylistDetailView(album: album)
            navigationController?.pushViewController(detailView, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let feedItem = feedItems[indexPath.row]
        switch feedItem {
        case .photo:
            return 200
        case .album:
            return 80
        }
    }
}

// MARK: - FeedItem
enum FeedItem {
    case photo(Photos)
    case album(Album)
    
    var createdAt: Date {
        switch self {
        case .photo(let photo):
            return photo.createdAt ?? Date.distantPast
        case .album(let album):
            return album.createdAt ?? Date.distantPast
        }
    }
}
