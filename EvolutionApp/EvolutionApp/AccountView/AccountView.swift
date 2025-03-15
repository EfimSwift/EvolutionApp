//
//  AccountView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit

class AccountView: UIViewController {
    
    let profileImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Аккаунт"
        
        setupUI()
        setupConstraints()
        loadProfilePhoto()
    }
    
    func setupUI() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func loadProfilePhoto() {
        if let imageData = UserDefaults.standard.data(forKey: "UserProfilePhoto"),
           let loadedImage = UIImage(data: imageData) {
            profileImageView.image = loadedImage
        } else {
            profileImageView.image = UIImage(systemName: "profile.fill")
        }
    }
}
