//
//  ViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/03.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD


// 데이터 구조체
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
    var backdrop_path: String
}

// VC 클래스
class MovieViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Properties
    static let identifier = "MovieViewController"
    
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    
    var timeWindowArray: [UIButton] {
        [ weekButton, dayButton]
    }
    
    var media_type: String?
    var time_window: String = "" {
        didSet {
            if time_window == TimeWindow.week.rawValue || time_window == TimeWindow.day.rawValue {
                start = 1
                totalCount = 0
                list.removeAll()
                getResult()
            }
        }
    }
    
    var list = [Item]()
    var selectedIndex: Int? = nil
    typealias Genre = [Int:String]
    var genres: Genre = [:]
    
    // 로딩 아이콘
    let hud = JGProgressHUD()
    
    // 페이지네이션을 위한 변수
    var start = 1
    var totalCount = 0
    
    @IBOutlet weak var moviePageCollectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviePageCollectionView.delegate = self
        moviePageCollectionView.dataSource = self
        moviePageCollectionView.prefetchDataSource = self
        
        configure()
        getGenre()
        
        
    }
    
    // MARK: - Actions
    
    
    // 타임윈도우 버튼 클릭하면 해당 태그에 맞춰서 API 요청하고 화면을 새로운 데이터에 맞춰 갱신
    @IBAction func didTimeWindowButtonTapped(_ sender: UIButton) {
        
        // 하이라이트된 버튼 색상을 변경하기
        if selectedIndex != nil {
            if !sender.isSelected {
                timeWindowArray.forEach {
                    $0.isSelected = false
                }
                sender.isSelected = true
                selectedIndex = timeWindowArray.firstIndex(of: sender)
                
            } else {
                sender.isSelected = false
                selectedIndex = nil
            }
        } else {
            sender.isSelected = true
            selectedIndex = timeWindowArray.firstIndex(of: sender)
        }
        
        if sender.isSelected == true {
            if let text = sender.currentTitle {
                self.time_window = text
            }
        }
        
        
    }
    
    // 영화 API 호출
    func getResult() {
        
        hud.show(in: self.view)
        
        let media_type = "movie"
        let time_window = self.time_window
        
        let url = "\(EndPoint.TMDB_URL)/\(media_type)/\(time_window)"
        
        let parameter: Parameters = [
            "api_key": Keys.TMDB,
            "page": self.start
        ]
        
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Items.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
                self.totalCount = value.total_results
                self.list.append(contentsOf: value.results)
                self.hud.dismiss(afterDelay: 0.2)
                self.moviePageCollectionView.reloadData()
                
            case .failure(let error):
                self.hud.dismiss(afterDelay: 0.2)
                print(error)
                
            }
        }
        
        
    }
    
    // 장르 API 호출
    func getGenre() {
        let url = "https://api.themoviedb.org/3/genre/movie/list"
        let parameter: Parameters = [
            "api_key" : Keys.TMDB,
            "language": "en-US"
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseData() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["genres"].arrayValue {
                    let id = item["id"].intValue
                    let name = item["name"].stringValue
                    
                    self.genres.updateValue(name, forKey: id)

                }
                print(self.genres)
                
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

extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviePageCollectionView {
            return list.count
        } else {
            return 0
        }
    }
    
    // 셀 종류
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == moviePageCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabPageCollectionViewCell.identifier, for: indexPath) as? TabPageCollectionViewCell else { return UICollectionViewCell() }
            let item = list[indexPath.item]
            cell.configure(item)
            
            var stringGenre: [String] = []
            
            for id in item.genre_ids {
                if genres.keys.contains(id) {
                    if let genre = genres[id] {
                        stringGenre.append(genre)
                    }
                }
            }
            
            print("장르 ---> \(stringGenre)")
            
            cell.configureGenre(genres: stringGenre)
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    // 셀 크기
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == moviePageCollectionView {
            let width: CGFloat = UIScreen.main.bounds.width - 40
            let height: CGFloat = 400
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    // 셀 눌렸을때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == moviePageCollectionView {
            // 선택하면 다음으로
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
            
            vc.movie = list[indexPath.item]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension MovieViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount{
                
                start += 1
                getResult()
                
            }
        }
    }
    
    
}
