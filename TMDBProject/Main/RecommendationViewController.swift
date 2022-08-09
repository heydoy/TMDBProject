//
//  RecommendationViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/09.
//

import UIKit

class RecommendationViewController: UIViewController {
    static let identifier = "RecommendationViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    let movieList: [[String]] = [
        ["겨울왕국2","아바타","알라딘","어벤져스엔드게임"],
        ["광해","괴물","국제시장","극한직업","도둑들"],
        ["명량", "베테랑", "부산행"]
    ]
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    


}

extension RecommendationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationTableViewCell.identifier, for: indexPath) as? RecommendationTableViewCell else {
            return UITableViewCell() }
        
        // 위임
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        
        // 태그로 섹션 구분
        cell.contentCollectionView.tag = indexPath.section
        
        // 콜렉션 뷰 셀 등록
        cell.contentCollectionView.register(UINib(nibName: CardCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        cell.cardView.posterImageView.image = UIImage(named: movieList[collectionView.tag][indexPath.item]) ?? UIImage(systemName: "star.fill")
        
        return cell
    }
}
