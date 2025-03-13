//
//  TabBarController.swift
//  EvolutionApp
//
//  Created by user on 13.03.2025.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
    }
    
    func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeView())
        let addPhoto = UINavigationController(rootViewController: AddFotoView())
        let accountVC = UINavigationController(rootViewController: AccountView())
        let searchVC = UINavigationController(rootViewController: SearchView())
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        addPhoto.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.app.fill"), tag: 1)
        accountVC.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.fill"), tag: 2)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        
        viewControllers = [homeVC, addPhoto, accountVC, searchVC]
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
    }
    
    
    
}
