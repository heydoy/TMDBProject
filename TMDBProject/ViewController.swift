//
//  ViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/03.
//

import UIKit
import Alamofire
import SwiftyJSON

enum MediaType: String, CaseIterable {
    case all
    case movie
    case tv
    case person
}

struct Items: Codable{
    var page: Int
    var results: [Item]
    var total_results: Int
    var total_pages: Int
}

struct Item: Codable {
    var title: String
    var adult: Bool
    var overview: String
    var vote_average: Double
    var poster_path: String
    var release_date: String
}

class ViewController: UIViewController {
    // MARK: - Properties
    static let identifier = "ViewController"
    
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    
    var timeWindowArray: [UIButton] {
        [ weekButton, dayButton]
    }
    
    var media_type: String?
    var time_window: String?
    var list = [Item]()
    
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    
    @IBOutlet weak var tabPageCollectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        
        tabPageCollectionView.delegate = self
        tabPageCollectionView.dataSource = self
        
        configure()
        
        getResult()
        
    }
    
    // MARK: - Actions
    
    @IBAction func didTimeWindowButtonTapped(_ sender: UIButton) {
        
        // 하이라이트된 버튼 색상을 변경하기
        
        sender.isSelected = !sender.isSelected
        
        timeWindowArray.forEach {
            $0.isSelected = false
            sender.backgroundColor = .white
            sender.layer.borderColor = UIColor.systemGray4.cgColor
        }
        sender.isSelected = true
        sender.backgroundColor = .systemMint
        
            
        self.time_window = sender.currentTitle
        print(self.time_window ?? "")
        
        
        
        
        
        // 액션을 취해주어야한다.
        
        
        
    }
    
    func getResult() {
        
        let media_type = "movie"
        let time_window = "week"
        
        let url = "\(EndPoint.TMDB_URL)/\(media_type)/\(time_window)"
        
        let parameter: Parameters = [
            "api_key": Keys.TMDB
        ]
        
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Items.self) { response in
            switch response.result {
            case .success(let value):
                self.list = value.results
                print(self.list[0].title)
                self.tabPageCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    // MARK: - Helpers
    
    func configure() {
        // 버튼 디자인
        timeWindowArray.forEach {
            $0.layer.cornerRadius = $0.frame.height/2
            $0.layer.backgroundColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemGray4.cgColor
        }
        timeWindowArray[0].setTitle("week", for: .normal)
        timeWindowArray[1].setTitle("day", for: .normal)
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabBarCollectionView {
            return MediaType.allCases.count
        } else if collectionView == tabPageCollectionView {
            return list.count
        } else {
            return 0
        }
    }
    
    // 셀 종류
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tabBarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCell.identifier, for: indexPath) as? TabBarCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure(indexPath.item)
            
            return cell
            
        } else if collectionView == tabPageCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabPageCollectionViewCell.identifier, for: indexPath) as? TabPageCollectionViewCell else { return UICollectionViewCell() }
            print("아이템 셀")
            let item = list[indexPath.item]
            cell.configure(item)
            
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    // 셀 크기
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabBarCollectionView {
            
            let width: CGFloat = collectionView.frame.size.width/4
            let height: CGFloat = 48
            return CGSize(width: width, height: height)
        
        } else if collectionView == tabPageCollectionView {
            let width: CGFloat = collectionView.frame.size.width - 40
            let height: CGFloat = 420
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
}

