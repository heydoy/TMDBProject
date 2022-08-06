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
        
        let nibName = UINib(nibName: EmptyCollectionViewCell.identifier, bundle: nil)
        moviePageCollectionView.register(nibName, forCellWithReuseIdentifier: EmptyCollectionViewCell.identifier)
        
        configure()
        getGenre()
        
        
    }
    
    // MARK: - Actions
    @objc
    func linkButtonTapped(_ sender: UIButton) {
        // sender.tag를 이용하여 movie_id를 찾고 이걸로 웹뷰 연결하기
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
        
        vc.movie_id = self.list[sender.tag].id
        vc.navigationItem.title = self.list[sender.tag].title
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
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
        MovieAPIManager.shared.getMovieTrend(time_window: time_window, start: start) { totalCount, list in
            self.totalCount = totalCount
            self.list.append(contentsOf: list)
            DispatchQueue.main.async {
                self.moviePageCollectionView.reloadData()
            }
        }
        hud.dismiss(animated: true)
        
    }
    
    // 장르 API 호출
    func getGenre() {
        MovieAPIManager.shared.getMovieGenre { genres in
            self.genres = genres
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

// 콜렉션 뷰
extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviePageCollectionView {
            
            return list.count == 0 ? 1 : list.count
        } else {
            return 0
        }
    }
    
    // 셀 종류
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if list.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier, for: indexPath) as? EmptyCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
            
        } else {
        
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
                            
                cell.configureGenre(genres: stringGenre)
                // 버튼에 태깅
                cell.linkButton.tag = indexPath.item
                cell.linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
                
                
                return cell
            }
            
            else {
                return UICollectionViewCell()
            }
            
            
         }
            
        
    }
    // 셀 크기
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == moviePageCollectionView {
            let width: CGFloat = UIScreen.main.bounds.width
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
