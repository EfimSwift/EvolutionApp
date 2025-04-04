//
//  AddFotoView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit
import CoreData

class AddFotoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profileImageView = UIImageView()
    let selectPhotoButton = UIButton(type: .system)
    let continueButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add Photo"
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        //MARK: - create imageView
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        //MARK: - create selectPhotoButton
        selectPhotoButton.setTitle("Select Photo from Gallery", for: .normal)
        selectPhotoButton.setTitleColor(.white, for: .normal)
        selectPhotoButton.backgroundColor = .systemBlue
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoTapped), for: .touchUpInside)
        view.addSubview(selectPhotoButton)
        //MARK: - create continueButton
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 10
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.addSubview(continueButton)
        
    }
    
    //MARK: - create constraint
    func setupConstraints() {
        NSLayoutConstraint.activate([
            //MARK: - imageView constraint
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: 300),
            profileImageView.heightAnchor.constraint(equalToConstant: 300),
            //MARK: - selectPhoto - constraint
            selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectPhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 200),
            selectPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            //MARK: - continue constraint
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor,constant: 10),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - methods
    func saveImageToCoreData(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        let context = CoreDataStack.shared.context
        let photo = Photos(context: context)
        photo.imageData = imageData
        photo.createdAt = Date()
        
        CoreDataStack.shared.saveContext()
        
        print("Photo saved to Core Data")
        
        NotificationCenter.default.post(name: NSNotification.Name("DataDidChange"), object: nil)
    }
    
    //MARK: - Selectors
    @objc func selectPhotoTapped() {
        let photoLibraryStatus = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        if !photoLibraryStatus {
            showAlert (message: "Photo library is not available on this device.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func continueTapped() {
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarController
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
    
    //MARK: - закрываем пикер если пользователь нажал отменить
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

