//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

class SearchViewController: UIViewController {
    private var movieArray: [Tvshows] = []

    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "search movie"
        return controller
    }()
    
    private var searchCollectionView: UICollectionView = {
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
        view.backgroundColor = .clear
        view.addSubview(searchCollectionView)
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        setupConstraints()
        fetchSerchData()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchSerchData() {
        APICaller.shared.fetchDiscover { result in
            switch result {
            case .success(let data):
                self.movieArray = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTrendingCollectionViewCell.identifier, for: indexPath) as! HomeTrendingCollectionViewCell
        let data = movieArray[indexPath.row]
        cell.configure(with: data.poster ?? "")
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultCollectionDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultController = searchController.searchResultsController as? SearchResultViewController else {return}
        
        resultController.delegate = self
        
        APICaller.shared.searchMovies(query: query) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    resultController.movieArray = data
                    resultController.searchResultCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchResultItemDidTap(viewModel: YoutubeViewModel) {
        DispatchQueue.main.async {
            let vc = VideoViewController()
            vc.configure(with: viewModel.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
