//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

enum Section: Int {
    case Trending = 0
    case Popular = 1
    case Discover = 2
    case Top_Rated = 3
    case TV_Shows = 4
    case Real_Story = 5
    case Fiction = 6
}

class HomeViewController: UIViewController {
    
    let headerView = HeaderView()
    var headerViewHeightConstraints: NSLayoutConstraint!
    let sectionHeader = ["Trending", "Popular", "Discover", "Top Rated", "TV Shows", "Real Story", "Fiction"]
    
    private var homeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 16
        table.layer.masksToBounds = true
        table.backgroundColor = .clear
        table.isUserInteractionEnabled = true
        return table
    }()
    
    private var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "netflix_logo")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        view.addSubview(homeTableView)
//        let logoImage = UIImage(named: "netflix_logo")?.withRenderingMode(.alwaysOriginal)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .white
        homeTableView.delegate = self
        homeTableView.dataSource = self
        headerView.delegate = self
        headerView.headerDelegate = self
        setupConstraints()
        fetchPopularData()
    }
    
    private func fetchPopularData() {
        APICaller.shared.fetchPopularMovies { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.headerView.movieArray = data
                    self.headerView.autoScroll()
                    self.headerView.setupCapsuleIndicators()
                    self.headerView.headerCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewHeightConstraints = headerView.heightAnchor.constraint(equalToConstant: 500)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewHeightConstraints,
            
            homeTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 35),
            logoImageView.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
        case Section.Trending.rawValue:
            APICaller.shared.fetchTredingMovies { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureMovie(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Popular.rawValue:
            APICaller.shared.fetchPopularMovies { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureMovie(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Discover.rawValue:
            APICaller.shared.fetchDiscover { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureTV(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Top_Rated.rawValue:
            APICaller.shared.fetchTVToday { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureTV(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.TV_Shows.rawValue:
            APICaller.shared.fetchTVShows { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureTV(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Real_Story.rawValue:
            APICaller.shared.fetchRealStory { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureTV(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Fiction.rawValue:
            APICaller.shared.fetchTredingMovies { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.configureMovie(with: data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.text = sectionHeader[section]
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        let button = UIButton()
        button.setTitle("View More", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = section
        button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(button)
        
        let chevron = UIButton()
        chevron.setImage(UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysOriginal).withTintColor(.label), for: .normal)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tag = section
        chevron.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        headerView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            chevron.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 2),
            chevron.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        return headerView
    }

    @objc private func sectionButtonTapped(_ sender: UIButton) {
        let buttonTag = sender.tag
        let vc = SeeAllViewController()
        vc.delegate = self
        switch buttonTag {
        case Section.Trending.rawValue:
            APICaller.shared.fetchTredingMovies { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureMovie(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Popular.rawValue:
            APICaller.shared.fetchPopularMovies { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureMovie(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Discover.rawValue:
            APICaller.shared.fetchDiscover { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureTV(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Top_Rated.rawValue:
            APICaller.shared.fetchTVToday { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureTV(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.TV_Shows.rawValue:
            APICaller.shared.fetchTVShows { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureTV(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Real_Story.rawValue:
            APICaller.shared.fetchRealStory { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureTV(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Fiction.rawValue:
            APICaller.shared.fetchTredingMovies { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        vc.configureMovie(with: data)
                        vc.title = self.sectionHeader[buttonTag]
                    }
                case .failure(let error):
                    print(error)
                }
            }
        default:
            break
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === homeTableView {
            let offset = homeTableView.contentOffset.y
            let newHeight = max(50, 500 - offset)
            headerViewHeightConstraints.constant = newHeight
            if offset < 0 {
                scrollView.contentOffset.y = 0
            }
        }
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func homeTableViewDidTapCell(viewModel: YoutubeViewModel) {
        DispatchQueue.main.async {
            let vc = VideoViewController()
            vc.configure(with: viewModel.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: CategorySelectionDelegate {
    func didSelectCategory(selectSection: Int) {
        guard selectSection >= 0 && selectSection < homeTableView.numberOfSections else {
            print("Invalid section index: \(selectSection)")
            return
        }
        let indexPath = IndexPath(row: 0, section: selectSection)
        homeTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension HomeViewController: HeaderCollectionViewDelegate {
    func headerCollectionViewCellTapped(viewModel: YoutubeViewModel) {
        DispatchQueue.main.async {
            let vc = VideoViewController()
            vc.configure(with: viewModel.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: SeeAllCollectionViewDelegate {
    func seeAllCollectionViewTapped(viewModel: YoutubeViewModel) {
        DispatchQueue.main.async {
            let vc = VideoViewController()
            vc.configure(with: viewModel.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

