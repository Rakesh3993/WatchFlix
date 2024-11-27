//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var movie: [Results] = []
    
    private var upcomingTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(upcomingTableView)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        setupConstraints()
        fetchUpcomingData()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            upcomingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            upcomingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upcomingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upcomingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchUpcomingData() {
        APICaller.shared.fetchPopularMovies { result in
            switch result {
            case .success(let data):
                self.movie = data
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }
        let data = movie[indexPath.row]
        cell.configure(with: HeaderViewModel(title: data.title ?? "", subTitle: data.title ?? "", image: data.poster ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = movie[indexPath.row]
        let query = data.title ?? ""
        
        APICaller.shared.search(query: query + "trailer") { result in
            switch result {
            case .success(let youtubeData):
                DispatchQueue.main.async {
                    let vc = VideoViewController()
                    vc.configure(with: youtubeData.videoId ?? "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
