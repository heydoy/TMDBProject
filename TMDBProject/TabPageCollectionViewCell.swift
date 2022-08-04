//
//  TabPageCollectionViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/04.
//

import UIKit

class TabPageCollectionViewCell: UICollectionViewCell {
    static let identifier = "TabPageCollectionViewCell"
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    
    func configure(_ item: Item) {
        titleLabel.text = item.title
        print(item)
        
    }
}
