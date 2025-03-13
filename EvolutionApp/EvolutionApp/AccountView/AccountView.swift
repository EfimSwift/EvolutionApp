//
//  AccountView.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit

class AccountView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Аккаунт"
        
        let label = UILabel()
        label.text = "Это экран Аккаунт"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
