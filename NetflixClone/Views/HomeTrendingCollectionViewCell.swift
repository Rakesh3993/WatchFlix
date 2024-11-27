//
//  HomeTrendingCollectionViewCell.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 22/11/24.
//

import UIKit

class HomeTrendingCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeTrendingCollectionViewCell"
    
    private var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with model: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiimage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async{
                self.posterImageView.image = uiimage
            }
        }.resume()
    }
}
