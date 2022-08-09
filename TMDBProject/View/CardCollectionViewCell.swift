//
//  CardCollectionViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CardCollectionViewCell"
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI () {
        cardView.posterImageView.layer.cornerRadius = 8
        cardView.bookmarkButton.tintColor = .orange
    }

}
