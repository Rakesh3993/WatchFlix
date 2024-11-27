//
//  APICaller.swift
//  NetflixClone
//
//  Created by Rakesh Kumar on 21/11/24.
//

import Foundation

struct Constants {
    static let baseUrl = "https://api.themoviedb.org"
    static let API_KEY = "a6cfef38d86303ab61f1b8ee1f3eea7f"
    static let youtube_api_key = "AIzaSyAc1uvwOHPFGr78j9WocptYVW9YaNSA2JE"
    static let youtube_base_url = "https://www.googleapis.com/youtube/v3/search"
}

//  https://api.themoviedb.org/3/search/q=harry%potter?api_key=a6cfef38d86303ab61f1b8ee1f3eea7f

// https://api.themoviedb.org/3/search/movie?api_key=a6cfef38d86303ab61f1b8ee1f3eea7f&query=harry%20potter


class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    func fetchTredingMovies(completion: @escaping (Result<[Results], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TrendingModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchPopularMovies(completion: @escaping (Result<[Results], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TrendingModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //  https://www.googleapis.com/youtube/v3/search?part=snippet&q=bollywood&key=AIzaSyAc1uvwOHPFGr78j9WocptYVW9YaNSA2JE
    
    func search(query: String, completion: @escaping (Result<VideoId, Error>)->()){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.youtube_base_url)?part=snippet&q=\(query)&key=\(Constants.youtube_api_key)") else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(YoutubeModel.self, from: data)
                completion(.success(result.items[0].id))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchTVShows(completion: @escaping (Result<[Tvshows], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/tv/1396/recommendations?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TVModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchTVToday(completion: @escaping (Result<[Tvshows], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/tv/airing_today?api_key=\(Constants.API_KEY)&language=en-US&page=2") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TVModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchDiscover(completion: @escaping (Result<[Tvshows], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/tv?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TVModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchRealStory(completion: @escaping (Result<[Tvshows], Error>) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/tv/airing_today?api_key=\(Constants.API_KEY)&language=en-US&page=3") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TVModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func searchMovies(query: String, completion: @escaping (Result<[Results], Error>) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(TrendingModel.self, from: data)
                completion(.success(result.results))
            }catch{
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
