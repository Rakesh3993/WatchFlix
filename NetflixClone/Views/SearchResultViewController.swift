//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 27/11/24.
//

import UIKit

protocol SearchResultCollectionDelegate: AnyObject {
    func searchResultItemDidTap(viewModel: YoutubeViewModel)
}

class SearchResultViewController: UIViewController {
    
    var movieArray: [Results] = []
    weak var delegate: SearchResultCollectionDelegate?
    var searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/3 - 10), height: 230)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HomeTrendingCollectionViewCell.self, forCellWithReuseIdentifier: HomeTrendingCollectionViewCell.identifier)
        collection.isUserInteractionEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchResultCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchResultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchResultCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureSearch(with model: [Results]) {
        movieArray = model
        searchResultCollectionView.reloadData()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTrendingCollectionViewCell.identifier, for: indexPath) as! HomeTrendingCollectionViewCell
        let data = movieArray[indexPath.row]
        cell.configure(with: data.poster ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = movieArray[indexPath.row]
        let query = data.title ?? ""
        print(indexPath.row)
        APICaller.shared.search(query: query) { result in
            print("search query:", query)
            switch result {
            case .success(let youtubeData):
                let viewModel = YoutubeViewModel(id: youtubeData.videoId ?? "")
                self.delegate?.searchResultItemDidTap(viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}

