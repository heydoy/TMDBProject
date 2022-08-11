//
//  MovieAPIManager.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieAPIManager {
    
    private init() {}
    static let shared = MovieAPIManager()
    
    typealias movieCompletionHandler = (Int, [Item]) -> Void
    typealias movieGenreCompletionHandler = ([Int:String]) -> Void
    typealias movieCastCompletionHandler = ([Cast]) -> Void
    typealias movieVideoCompletionHandler = ([Video]) -> Void
    
    // 영화 리스트 가져오기
    func getMovieTrend(time_window: String, start: Int, completionHandler: @escaping movieCompletionHandler ) {
        let media_type = MediaType.movie.rawValue
        let time_window = time_window
        
        let url = "\(EndPoint.TRENDING_URL)/\(media_type)/\(time_window)"
        
        let parameter: Parameters = [
            "api_key": Keys.TMDB,
            "page": start
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Items.self, queue: .global()) { response in
            switch response.result {
            case .success(let value):
                
                let totalCount = value.total_results
                let list = value.results
                
                completionHandler(totalCount, list)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    // 영화 장르 가져오기
    func getMovieGenre(completionHandler: @escaping movieGenreCompletionHandler) {
        let url = EndPoint.MOVIE_GENRE
        let parameter: Parameters = [
            "api_key" : Keys.TMDB
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var genres: [Int:String] = [:]
                for item in json["genres"].arrayValue {
                    let id = item["id"].intValue
                    let name = item["name"].stringValue
                    
                    genres.updateValue(name, forKey: id)
                }
                
                completionHandler(genres)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    // 영화 캐스트(출연진) 가져오기
    func getMovieCast (movie_id: Int, completionHandler: @escaping movieCastCompletionHandler ) {
        
        let url = "\(EndPoint.TMDB)/movie/\(movie_id)/credits"
        
        let parameter: Parameters = [
            "api_key" : Keys.TMDB
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Casts.self, queue: .global()) { response in
            switch response.result {
            case .success(let value) :
                let list = value.cast
                completionHandler(list)
                
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    // 영화 비디오 가져오기
    func getMovieVideo (movie_id: Int, completionHandler: @escaping movieVideoCompletionHandler ) {
        let url = "\(EndPoint.TMDB)/movie/\(movie_id)/videos"
        
        let parameter: Parameters = [
            "api_key" : Keys.TMDB
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Videos.self, queue: .global()) { response in
            switch response.result {
            case .success(let value) :
                let list = value.results
                completionHandler(list)
                
            case .failure(let error) :
                print(error)
            }
            
        }
    }
    
    let movieList = [
        ("Prey", 766507),
        ("Elvis", 614934),
        ("Luck", 585511),
        ("The Sandman", 90802),
        ("The Little Guy", 1010819)
    ]
    let imageURL: String = "https://image.tmdb.org/t/p/w500"
    func movieRecommendationURL(movieID: Int) -> String {
        return "https://api.themoviedb.org/3/movie/\(movieID)/similar"
    }
    
    
    
    // 비슷한 영화 가져오기
    func getSimilarMovie(movieID: Int, completionHandler: @escaping([String]) -> Void ) {
        
        let body: Parameters = [
            "api_key" : Keys.TMDB
        ]
        
        var posterList: [String] = []
        
        AF.request(movieRecommendationURL(movieID: movieID), method: .get, parameters: body ).validate().responseData { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                for item in json["results"].arrayValue {
                    if item["poster_path"].stringValue != "null" {
                        posterList.append(self.imageURL + item["poster_path"].stringValue)
                    }
                }
                completionHandler(posterList)
                
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func getSimilarMovieList(completionHandler: @escaping([[String]]) -> Void ) {
        var posterList: [[String]] = []
        
        MovieAPIManager.shared.getSimilarMovie(movieID: movieList[0].1) { value in
            posterList.append(value)
            
            MovieAPIManager.shared.getSimilarMovie(movieID: self.movieList[1].1) { value in
                posterList.append(value)
                
                MovieAPIManager.shared.getSimilarMovie(movieID: self.movieList[2].1) { value in
                    posterList.append(value)
                    
                    MovieAPIManager.shared.getSimilarMovie(movieID: self.movieList[3].1) { value in
                        posterList.append(value)
                        
                        MovieAPIManager.shared.getSimilarMovie(movieID: self.movieList[4].1) { value in
                            posterList.append(value)
                            
                            completionHandler(posterList)
                        }
                    }
                }
            }
        }
        
    }
    
}
