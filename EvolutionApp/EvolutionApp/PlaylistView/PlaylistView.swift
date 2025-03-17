//
//  PlaylistView.swift
//  EvolutionApp
//
//  Created by user on 17.03.2025.
//

import UIKit

class PlaylistView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        title = "Плейлист"
        
        let label = UILabel()
        label.text = "Это секция Плейлист"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
