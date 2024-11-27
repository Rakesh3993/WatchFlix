//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadViewController())
        
        let image1 = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
        let image2 = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
        let image3 = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
        let image4 = UIImage(systemName: "arrow.down.to.line")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
        
        vc1.tabBarItem.image = image1
        vc2.tabBarItem.image = image2
        vc3.tabBarItem.image = image3
        vc4.tabBarItem.image = image4
        
        vc1.title = "Home"
        vc2.title = "Upcoming"
        vc3.title = "Search"
        vc4.title = "Download"
        
        vc1.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        vc2.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        vc3.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        vc4.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

