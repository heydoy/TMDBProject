//
//  RecommendationTableViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/09.
//

import UIKit

class RecommendationTableViewCell: UITableViewCell {

    static let identifier = "RecommendationTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentCollectionView.collectionViewLayout = collectionViewLayout()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        titleLabel.text = "매니페스트와 비슷한 영화"
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.showsHorizontalScrollIndicator = false
        contentCollectionView.showsVerticalScrollIndicator = false
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 140)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return layout
    }
}
