//
//  HomeTableViewCell.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func homeTableViewDidTapCell(viewModel: YoutubeViewModel)
}

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    private var isMovie: Bool?
    
    private var movieArray: [Results] = []
    private var TVArray: [Tvshows] = []
    weak var delegate: HomeTableViewCellDelegate?
    
    private var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(HomeTrendingCollectionViewCell.self, forCellWithReuseIdentifier: HomeTrendingCollectionViewCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isUserInteractionEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(homeCollectionView)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            homeCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureMovie(with movie: [Results]){
        movieArray = movie
        isMovie = true
        DispatchQueue.main.async{
            self.homeCollectionView.reloadData()
        }
    }
    
    func configureTV(with movie: [Tvshows]){
        TVArray = movie
        isMovie = false
        DispatchQueue.main.async{
            self.homeCollectionView.reloadData()
        }
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMovie == true {
            return movieArray.count
        } else if isMovie == false {
            return TVArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTrendingCollectionViewCell.identifier, for: indexPath) as? HomeTrendingCollectionViewCell else {
            return UICollectionViewCell()
        }
        if isMovie == true {
            let movie = movieArray[indexPath.row]
            cell.configure(with: movie.poster ?? "")
        } else if isMovie == false {
            let tv = TVArray[indexPath.row]
            cell.configure(with: tv.poster ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var title = ""
        if isMovie == true {
            let movie = movieArray[indexPath.row]
            title = movie.title ?? ""
        } else if isMovie == false {
            let tv = TVArray[indexPath.row]
            title = tv.title ?? ""
        }
        APICaller.shared.search(query: title + "trailer") { result in
            switch result {
            case .success(let youtubeData):
                self.delegate?.homeTableViewDidTapCell(viewModel: YoutubeViewModel(id: youtubeData.videoId))
            case .failure(let error):
                print(error)
            }
        }
    }
}
