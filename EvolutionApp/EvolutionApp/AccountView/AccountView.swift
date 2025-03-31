//
//  AccountView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit
import CoreData

class AccountView: UIViewController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    
    let profileImageView = UIImageView()
    let changePhotoButton = UIButton(type: .system)
    let logoutButton = UIButton(type: .system)
    let innerTabBar = UITabBar()
    var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Аккаунт"
        
        setupUI()
        setupConstraints()
        loadProfilePhoto()
        setupInnerTabBar()
    }
    
    func setupUI() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        //MARK: - changePhotoButton
        changePhotoButton.setTitle("Change Photo", for: .normal)
        changePhotoButton.setTitleColor(.white, for: .normal)
        changePhotoButton.backgroundColor = .systemBlue
        changePhotoButton.layer.cornerRadius = 10
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        view.addSubview(changePhotoButton)
        //MARK: - logoutButton
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 10
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        //MARK: - innerTabBar
        innerTabBar.delegate = self
        innerTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(innerTabBar)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            changePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            changePhotoButton.widthAnchor.constraint(equalToConstant: 150),
            changePhotoButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 10),
            logoutButton.widthAnchor.constraint(equalToConstant: 150),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            
            innerTabBar.topAnchor.constraint(equalTo: logoutButton.bottomAnchor,constant: 20),
            innerTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            innerTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            innerTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - InnerTabBar
    func setupInnerTabBar() {
        let photoItem = UITabBarItem(title: "Photo", image: UIImage(systemName: "photo"), tag: 0)
        let playlistItem = UITabBarItem(title: "Playlist", image: UIImage(systemName: "list.bullet"), tag: 1)
        innerTabBar.items = [photoItem, playlistItem]
        innerTabBar.selectedItem = photoItem
        
        showViewController(for: photoItem)
    }
    
    //MARK: - switch on sections
    func showViewController(for tabBarItem: UITabBarItem) {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        let newViewController: UIViewController
        switch tabBarItem.tag {
        case 0:
            newViewController = PhotoSectionView()
        case 1:
            newViewController = PlaylistView()
        default:
            newViewController = AccountView()
        }
        
        addChild(newViewController)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newViewController.view)
        
        NSLayoutConstraint.activate([
            newViewController.view.topAnchor.constraint(equalTo: innerTabBar.bottomAnchor),
            newViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        newViewController.didMove(toParent: self)
        currentViewController = newViewController
    }
    
    //MARK: - tabBar instailing
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        showViewController(for: item)
    }
    
    //MARK: - loadProfilePhoto
    func loadProfilePhoto() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let photos = try context.fetch(fetchRequest)
            if let lastPhoto = photos.first, let imageData = lastPhoto.imageData, let image = UIImage(data: imageData) {
                profileImageView.image = image
            } else {
                profileImageView.image = UIImage(systemName: "person.fill")
            }
        } catch {
            print("Error fetching profile photo: \(error)")
            profileImageView.image = UIImage(systemName: "person.fill")
        }
    }
    
    //MARK: - selector ChangePhotoButton
    @objc func changePhotoTapped() {
        let photoLibraryStatus = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        if !photoLibraryStatus {
            showAlert(message: "Photo library is not available on this device")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    //MARK: - selector logoutButton
    @objc func logoutTapped() {
        let context = CoreDataStack.shared.context
        let photoRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        let playlistRequest: NSFetchRequest<Album> = Album.fetchRequest()
        
        do {
            let photos = try context.fetch(photoRequest)
            let playlists = try context.fetch(playlistRequest)
            for photo in photos {
                context.delete(photo)
            }
            for playlist in playlists {
                context.delete(playlist)
            }
            CoreDataStack.shared.saveContext()
        } catch {
            print("Error clearing data: \(error)")
        }
        
        UserDefaults.standard.set(false, forKey: "isUserSignedUp")
        UserDefaults.standard.removeObject(forKey: Constants.shared.userName)
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.synchronize()
        
        let navController = UINavigationController(rootViewController: ViewController())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    //MARK: - imagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            saveImageToCoreData(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - CoreData
    func saveImageToCoreData(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        let context = CoreDataStack.shared.context
        let photo = Photos(context: context)
        photo.imageData = imageData
        photo.createdAt = Date()
        
        CoreDataStack.shared.saveContext()
        
        NotificationCenter.default.post(name: NSNotification.Name("DataDidChange"), object: nil)
    }
    
    //MARK: - alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
