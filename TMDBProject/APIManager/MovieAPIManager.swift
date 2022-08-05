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
    
    // 영화 리스트 가져오기
    func getMovieTrend(time_window: String, start: Int, completionHandler: @escaping movieCompletionHandler ) {
        let media_type = MediaType.movie.rawValue
        let time_window = time_window
        
        let url = "\(EndPoint.TMDB_URL)/\(media_type)/\(time_window)"
        
        let parameter: Parameters = [
            "api_key": Keys.TMDB,
            "page": start
        ]
        
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Items.self) { response in
            switch response.result {
            case .success(let value):
                
                let totalCount = value.total_results
                let list =  value.results
                
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
        
        AF.request(url, method: .get, parameters: parameter).validate().responseData() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
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
    
}