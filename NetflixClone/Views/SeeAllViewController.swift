//
//  SeeAllCollectionView.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 22/11/24.
//

import UIKit

protocol SeeAllCollectionViewDelegate: AnyObject {
    func seeAllCollectionViewTapped(viewModel: YoutubeViewModel)
}

class SeeAllViewController: UIViewController {
    
    var sectionIdentifier: Int?
    
    private var movieArray: [Results] = []
    private var TVArray: [Tvshows] = []
    var delegate: SeeAllCollectionViewDelegate?
    private var isMovie: Bool?

    private var seeAllCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/3 - 9), height: 230)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HomeTrendingCollectionViewCell.self, forCellWithReuseIdentifier: HomeTrendingCollectionViewCell.identifier)
        collection.isUserInteractionEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(seeAllCollectionView)
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        seeAllCollectionView.delegate = self
        seeAllCollectionView.dataSource = self
        setupConstraints()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            seeAllCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            seeAllCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seeAllCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seeAllCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureTV(with model: [Tvshows]){
        TVArray = model
        isMovie = false
        DispatchQueue.main.async {
            self.seeAllCollectionView.reloadData()
        }
    }
    
    func configureMovie(with model: [Results]){
        movieArray = model
        isMovie = true
        DispatchQueue.main.async {
            self.seeAllCollectionView.reloadData()
        }
    }
}

extension SeeAllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMovie == true {
            return movieArray.count
        }else if isMovie == false {
            return TVArray.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTrendingCollectionViewCell.identifier, for: indexPath) as! HomeTrendingCollectionViewCell
    
        if isMovie == true {
            let movie = movieArray[indexPath.row]
            cell.configure(with: movie.poster ?? "")
        }else if isMovie == false {
            let tv = TVArray[indexPath.row]
            cell.configure(with: tv.poster ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var query = ""
        if isMovie == true {
            let movie = movieArray[indexPath.row]
            query = movie.title ?? ""
        }else if isMovie == false {
            let tv = TVArray[indexPath.row]
            query = tv.title ?? ""
        }
        
        APICaller.shared.search(query: query + "trailer") { result in
            switch result {
            case .success(let youtubeData):
                let viewModel = YoutubeViewModel(id: youtubeData.videoId ?? "")
                self.delegate?.seeAllCollectionViewTapped(viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
