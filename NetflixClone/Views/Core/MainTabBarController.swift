//
//  MainTabBarController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var homeViewController: UIViewController!
    var upcomingViewController: UIViewController!
    var searchViewController: UIViewController!
    var downloadViewController: UIViewController!
    
    var tabItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
    }
    
    
    func setUpControllers() {
        self.delegate = self
        
        let vc1 = HomeViewController()
        vc1.title = ""
        homeViewController = UINavigationController(rootViewController: vc1)
        homeViewController.tabBarItem.title = ""
        
        let vc2 = UpcomingViewController()
        vc2.title = ""
        upcomingViewController = UINavigationController(rootViewController: vc2)
        upcomingViewController.tabBarItem.title = ""
        
        let vc3 = SearchViewController()
        vc3.title = ""
        searchViewController = UINavigationController(rootViewController: vc3)
        searchViewController.tabBarItem.title = ""
        
        let vc4 = DownloadViewController()
        vc4.title = ""
        downloadViewController = UINavigationController(rootViewController: vc4)
        downloadViewController.tabBarItem.title = ""
        
        viewControllers = [homeViewController, upcomingViewController, searchViewController, downloadViewController]
        
        self.tabBar.backgroundImage = UIImage()
        
        let tabBarColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = tabBarColor
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        customTab(selectedImage: "house.fill", deselctedImage: "house", tabIndex: 0, tabTitle: "")
        customTab(selectedImage: "play.circle.fill", deselctedImage: "play.circle", tabIndex: 1, tabTitle: "")
        customTab(selectedImage: "magnifyingglass.circle.fill", deselctedImage: "magnifyingglass.circle", tabIndex: 2, tabTitle: "")
        customTab(selectedImage: "arrow.down.square.fill", deselctedImage: "arrow.down.square", tabIndex: 3, tabTitle: "")
    }
    
    func customTab(selectedImage image1: String, deselctedImage image2: String, tabIndex index: Int, tabTitle title: String) {
        
        let dynamicColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        
        let selectedImage = UIImage(systemName: image1)?.withRenderingMode(.alwaysOriginal).withTintColor(dynamicColor)
        let deselectedImage = UIImage(systemName: image2)?.withRenderingMode(.alwaysOriginal).withTintColor(dynamicColor)
        
        tabItem = self.tabBar.items![index]
        tabItem.image = deselectedImage
        tabItem.selectedImage = selectedImage
        tabItem.title = ""
        tabItem.imageInsets.bottom = -11
        tabItem.setTitleTextAttributes([.foregroundColor: dynamicColor], for: .selected)
        tabItem.setTitleTextAttributes([.foregroundColor: dynamicColor], for: .normal)
    }
}

