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

enum TimeWindow: String, CaseIterable {
    case week
    case day
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
    var genre_ids: [Int]
}

class MovieViewController: UIViewController {
    // MARK: - Properties
    static let identifier = "ViewController"
    
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    
    var timeWindowArray: [UIButton] {
        [ weekButton, dayButton]
    }
    
    var media_type: String?
    var time_window: String = TimeWindow.week.rawValue {
        didSet {
            if time_window == TimeWindow.week.rawValue || time_window == TimeWindow.day.rawValue {
                getResult()
            }
        }
    }
    var list = [Item]()
    
    
    @IBOutlet weak var tabPageCollectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabPageCollectionView.delegate = self
        tabPageCollectionView.dataSource = self
        
        configure()
        
        getResult()
        
    }
    
    // MARK: - Actions
    
    
    // 타임윈도우 버튼 클릭하면 해당 태그에 맞춰서 API 요청하고 화면을 새로운 데이터에 맞춰 갱신
    @IBAction func didTimeWindowButtonTapped(_ sender: UIButton) {
        
        // 하이라이트된 버튼 색상을 변경하기
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            sender.backgroundColor = .systemMint
        } else {
            sender.backgroundColor = .systemGray6
        }
            
        self.time_window = sender.currentTitle ?? ""
        // 액션을 취해주어야한다.
        
        
        
        
    }
    
    func getResult() {
        
        let media_type = "movie"
        let time_window = self.time_window
        
        let url = "\(EndPoint.TMDB_URL)/\(media_type)/\(time_window)"
        
        let parameter: Parameters = [
            "api_key": Keys.TMDB
        ]
        
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Items.self) { response in
            switch response.result {
            case .success(let value):
                self.list = value.results
                print(self.list[0].title)
                
                // 이미지 URL 처리
                
                
                
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
        
        if collectionView == tabPageCollectionView{
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
         if collectionView == tabPageCollectionView {
            let width: CGFloat = collectionView.frame.size.width - 40
            let height: CGFloat = 400
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    // 셀 눌렸을때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabPageCollectionView {
            // 선택하면 다음으로
            
        }
    }
    
}

