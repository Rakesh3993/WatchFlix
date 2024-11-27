//
//  VideoViewController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 22/11/24.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {
    
    private var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let contentController = WKUserContentController()
        configuration.userContentController = contentController
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.scrollView.isScrollEnabled = true
        view.scrollView.bounces = true
        view.allowsBackForwardNavigationGestures = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        setupConstraints()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func configure(with video: String){
        guard let url = URL(string: "https://www.youtube.com/embed/\(video)") else {return}
        print(url)
        webView.load(URLRequest(url: url))
    }
}

extension VideoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading...")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading!")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load: \(error.localizedDescription)")
    }
}
