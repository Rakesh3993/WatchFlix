//
//  LaunchViewController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 26/11/24.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private var launchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "netflix_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(launchImage)
        setupConstraints()
        animateLogo()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            launchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            launchImage.heightAnchor.constraint(equalToConstant: 190),
            launchImage.widthAnchor.constraint(equalToConstant: 190)
        ])
    }
    
    private func animateLogo() {
        
        UIView.animate(withDuration: 1.3, delay: 0, options: .curveEaseInOut, animations: {
            self.launchImage.transform = CGAffineTransform(scaleX: 3.8, y: 3.8)
            self.launchImage.alpha = 0
        }) { _ in
            self.transitionToMainApp()
        }
    }
    
    func transitionToMainApp() {
        let vc = MainTabBarController()
        vc.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
