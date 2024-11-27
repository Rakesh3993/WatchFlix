//
//  HeaderView.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func didSelectCategory(selectSection: Int)
}

protocol HeaderCollectionViewDelegate: AnyObject {
    func headerCollectionViewCellTapped(viewModel: YoutubeViewModel)
}

class HeaderView: UIView {
    
    var timer: Timer?
    var currentItem: Int = 0
    var movieArray: [Results] = []
    private let categories = ["Trending", "Popular", "Discover", "Top Rated", "TV Shows", "Real Story", "Fiction"]
    weak var delegate: CategorySelectionDelegate?
    weak var headerDelegate: HeaderCollectionViewDelegate?
    private var gradientlayer = CAGradientLayer()
    private var indexPath: IndexPath?
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 95, height: 36)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var capsuleIndicatorStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 500)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        [categoryCollectionView, headerCollectionView, capsuleIndicatorStack].forEach(addSubview)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        setupGradient()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGradient() {
        gradientlayer.colors = [
            UIColor.red.cgColor,
            UIColor.blue.cgColor
        ]
        gradientlayer.startPoint = CGPoint(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint(x: 1, y: 1)
        gradientlayer.locations = [0.0, 1.0]
        
        layer.insertSublayer(gradientlayer, at: 0)
    }
    
    func setupCapsuleIndicators() {
        capsuleIndicatorStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in movieArray.indices {
            let capsule = UIView()
            capsule.backgroundColor = .lightGray
            capsule.layer.cornerRadius = 2
            capsule.translatesAutoresizingMaskIntoConstraints = false
            capsule.widthAnchor.constraint(equalToConstant: 5).isActive = true
            capsuleIndicatorStack.addArrangedSubview(capsule)
        }
        
        updateCapsuleIndicators(for: 0)
    }
    
    func updateCapsuleIndicators(for index: Int) {
        capsuleIndicatorStack.arrangedSubviews.enumerated().forEach { (i, view) in
            view.backgroundColor = i == index ? .systemBlue : .lightGray
        }
    }
    
    func autoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(timerStart), userInfo: nil, repeats: true)
    }
    
    @objc func timerStart() {
        guard !movieArray.isEmpty else { return }
        
        let totalItem = movieArray.count
        let indexPath = IndexPath(item: currentItem, section: 0)
        headerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateCapsuleIndicators(for: currentItem)
        self.indexPath = indexPath
        currentItem += 1
        if currentItem >= totalItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.headerCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                self.updateCapsuleIndicators(for: 0)
                self.indexPath = IndexPath(item: 0, section: 0)
                self.currentItem = 0
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 45),
            
            headerCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
            headerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            capsuleIndicatorStack.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 20),
            capsuleIndicatorStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            capsuleIndicatorStack.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return movieArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: categories[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, for: indexPath) as? HeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            let data = movieArray[indexPath.row]
            cell.configure(with: HeaderViewModel(title: data.title ?? "", subTitle: data.subTitle ?? "", image: data.poster ?? ""))
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === categoryCollectionView {
            delegate?.didSelectCategory(selectSection: indexPath.item)
        }else{
            self.indexPath = indexPath
            let data = movieArray[indexPath.row]
            let query = data.title ?? ""
            APICaller.shared.search(query: query + "trailer") { result in
                switch result {
                case .success(let youtubeData):
                    let viewModel = YoutubeViewModel(id: youtubeData.videoId ?? "")
                    self.headerDelegate?.headerCollectionViewCellTapped(viewModel: viewModel)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension HeaderView: WatchButtonDelegate {
    func didTapWatchButton() {
        guard let indexPath = self.indexPath else {return}
        print(indexPath.item)
        let data = movieArray[indexPath.item]
        let query = data.title ?? ""
        APICaller.shared.search(query: query + "trailer") { result in
            switch result {
            case .success(let youtubeData):
                let viewModel = YoutubeViewModel(id: youtubeData.videoId ?? "")
                self.headerDelegate?.headerCollectionViewCellTapped(viewModel: viewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
}
