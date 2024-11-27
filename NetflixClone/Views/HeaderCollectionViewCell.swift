//
//  HeaderCollectionViewCell.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

protocol WatchButtonDelegate: AnyObject {
    func didTapWatchButton()
}

class HeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HeaderCollectionViewCell"
    weak var delegate: WatchButtonDelegate?
    private var gradientLayer = CAGradientLayer()
    
    var posterImageView: UIImageView = {
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
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var posterSubTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var watchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red.withAlphaComponent(0.9)
        button.setTitle("Watch", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        addSubview(posterTitle)
        addSubview(posterSubTitle)
        addSubview(watchButton)
        setupGradient()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func watchButtonClicked(){
        delegate?.didTapWatchButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = posterImageView.bounds
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor,
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.6)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 0.2]
        
        posterImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            watchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            watchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            watchButton.widthAnchor.constraint(equalToConstant: 100),
            watchButton.heightAnchor.constraint(equalToConstant: 34),
            
            posterSubTitle.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 10),
            posterSubTitle.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -10),
            posterSubTitle.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -10),
            
            posterTitle.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 10),
            posterTitle.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -10),
            posterTitle.bottomAnchor.constraint(equalTo: posterSubTitle.topAnchor, constant: -10)
        ])
    }
    
    func configure(with model: HeaderViewModel){
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
        posterSubTitle.text = model.subTitle
    }
}
