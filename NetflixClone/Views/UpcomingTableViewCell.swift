//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 27/11/24.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    private var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    private var posterTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(posterImageView)
        addSubview(posterTitle)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            posterImageView.widthAnchor.constraint(equalToConstant: 90),
            
            posterTitle.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            posterTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with model: HeaderViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.image)") else {return}
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiimage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async{
                self.posterImageView.image = uiimage
            }
        }.resume()
        posterTitle.text = model.title
    }
}
