//
//  ViewController.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let labelEvolution = UILabel()
    let backgroundImageView = UIImageView()
    let loginTextField = UITextField()
    let passwordTextField = UITextField()
    let togglePasswordButton = UIButton()
    let signUpButton = UIButton()
    let registrationButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        createLabel()
        createLoginTextField()
        createPasswordTextField()
        createSignUpButton()
        createRegistrationButton()
        createConstraints()
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: - setup background
    func setupBackground() {
        backgroundImageView.image = UIImage(named: "backgroundImage")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    //MARK: create titleLabel
    func createLabel() {
        labelEvolution.text = "Evolution"
        labelEvolution.numberOfLines = 1
        labelEvolution.textAlignment = .center
        labelEvolution.textColor = .darkGray
        labelEvolution.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        labelEvolution.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelEvolution)
    }
    
    //MARK: create loginTextField
    func createLoginTextField() {
        loginTextField.borderStyle = .roundedRect
        loginTextField.textAlignment = .center
        loginTextField.placeholder = "enter your login"
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.delegate = self
        view.addSubview(loginTextField)
        loginTextField.layer.cornerRadius = 20
        loginTextField.layer.masksToBounds = true
        loginTextField.layer.borderColor = UIColor.gray.cgColor
    }
    
    //MARK: - create passwordTextField
    func createPasswordTextField() {
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "enter your password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        
        //MARK: - create togglePasswordButton
        togglePasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        togglePasswordButton.tintColor = UIColor.gray
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.rightView = togglePasswordButton
        passwordTextField.rightViewMode = .always
    }
    
    //MARK: - create signUpButton
    func createSignUpButton() {
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.backgroundColor = UIColor.clear
        signUpButton.addTarget(self, action: #selector (loginButtonIsPressed), for: .touchDown)
        signUpButton.addTarget(self, action: #selector(loginButtonIsTapped), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
    }
    
    //MARK: - create registrationButton
    func createRegistrationButton() {
        registrationButton.setTitle("Registration", for: .normal)
        registrationButton.setTitleColor(UIColor.white, for: .normal)
        registrationButton.backgroundColor = UIColor.clear
        registrationButton.addTarget(self, action: #selector(registrationButtonIsPressed), for: .touchDown)
        registrationButton.addTarget(self, action: #selector(registrationButtonIsTapped), for: .touchUpInside)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registrationButton)
        
    }
    
    //MARK: - create constraint
    func createConstraints() {
        NSLayoutConstraint.activate([
            //MARK: - label constraint
            labelEvolution.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelEvolution.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //MARK: - login constraint
            loginTextField.topAnchor.constraint(equalTo: labelEvolution.bottomAnchor, constant: 300),
            loginTextField.centerXAnchor.constraint(equalTo: labelEvolution.centerXAnchor),
            //MARK: - password constraint
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            //MARK: - signUpButton constraint
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            signUpButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            //MARK: - registrationButton constraint
            registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 39),
            registrationButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
    }
    
    //MARK: - Selectors
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeIcon = passwordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.slash"
        togglePasswordButton.setImage(UIImage(systemName: eyeIcon), for: .normal)
    }
    
    @objc func loginButtonIsPressed(sender: UIButton) {
        print("Login button pressed")
    }
    
    @objc func loginButtonIsTapped(sender: UIButton) {
        checkUserData()
        navigationController?.pushViewController(AddFotoView(), animated: true)
        print("Login button tapped")
    }
    
    //MARK: Selector Registration
    @objc func registrationButtonIsPressed(sender: UIButton) {
        print("Registration button pressed")
    }
    @objc func registrationButtonIsTapped(sende: UIButton) {
        if validateRegistrationFields() {
            navigationController?.pushViewController(RegistrationView(), animated: true)
        }
        print("Registration button pressed")
    }
    
    //MARK: Selector loginTextField
    @objc func validateLoginField() {
        if loginTextField.text?.isEmpty == true {
            loginTextField.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            loginTextField.layer.borderColor = UIColor.systemGreen.cgColor
        }
    }
    
    //MARK: Selector keyboardRecognayzer
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Methods
    func showAlert(massega: String) {
        let alert = UIAlertController(title: "ошибка", message: massega, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func validateLoginFields() -> Bool {
        if loginTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
            showAlert(massega: "Заполните оба поля")
            return false
        }
        return true
    }
    
    func validateRegistrationFields() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - проверка на правильно введеные данные
    func checkUserData() {
        let defaults = UserDefaults.standard
        let savedEmail = defaults.string(forKey: "userEmail")
        let savedPassword = defaults.string(forKey: "userPassword")
        guard let inputEmail = loginTextField.text, !inputEmail.isEmpty,
              let inputPassword = passwordTextField.text, !inputPassword.isEmpty else {
            showAlert(massega: "введите ваш email и пароль")
            return
        }
        guard inputEmail == savedEmail && inputPassword == savedPassword else {
            return showAlert(massega: "неверный email или пароль")
        }
    }
}

