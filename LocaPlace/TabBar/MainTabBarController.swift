//
//  MainTabBarController.swift
//  LocaPlace
//
//  Created by KODDER on 09.09.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViews()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .cyan
    }
    
    private func setupViews() {
        let tagVC = TagViewController()
        
        setViewControllers([tagVC], animated: true)
        
        guard let items = tabBar.items else { return }
        
        items[0].title = "Tag"
        
        UITabBarItem.appearance().setBadgeTextAttributes([.font: UIFont.systemFontSize],
                                                         for: .normal)
    }
}
