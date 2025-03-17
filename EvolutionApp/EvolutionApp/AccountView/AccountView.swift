//
//  AccountView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit

class AccountView: UIViewController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    
    let profileImageView = UIImageView()
    let changePhotoButton = UIButton(type: .system)
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
            
            innerTabBar.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor,constant: 20),
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
        if let imageData = UserDefaults.standard.data(forKey: "UserProfilePhoto"),
           let loadedImage = UIImage(data: imageData) {
            profileImageView.image = loadedImage
        } else {
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
    
    //MARK: - imagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                profileImageView.image = selectedImage
                saveImageToUserDefaults(image: selectedImage)
            }
            dismiss(animated: true, completion: nil)
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UserDefaults
    func saveImageToUserDefaults(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "UserProfilePhoto")
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: - alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
