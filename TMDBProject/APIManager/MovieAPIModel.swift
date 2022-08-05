//
//  MovieAPIModel.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import Foundation

// 영화 데이터를 받아올 구조체
struct Items: Codable{
    var page: Int
    var results: [Item]
    var total_results: Int
    var total_pages: Int
}

struct Item: Codable {
    var id: Int
    var title: String
    var adult: Bool
    var overview: String
    var vote_average: Double
    var poster_path: String
    var release_date: String
    var genre_ids: [Int]
    var backdrop_path: String
}