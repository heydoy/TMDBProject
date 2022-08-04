//
//  TabBarCollectionViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/04.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    static let identifier = "TabBarCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    func configure(_ index: Int) {
        
        titleLabel.text = MediaType.allCases[index].rawValue
    }
}
