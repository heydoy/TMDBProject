//
//  TabPageCollectionViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/04.
//

import UIKit
import Kingfisher


class TabPageCollectionViewCell: UICollectionViewCell {
    static let identifier = "TabPageCollectionViewCell"
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    
   
    
    func configure(_ item: Item) {
        titleLabel.text = item.title
        releaseDateLabel.text = item.release_date
        adultLabel.isHidden = item.adult ? false : true
        rateLabel.text = String(item.vote_average)
        
        
        
        let imgURL = "https://image.tmdb.org/t/p/w220_and_h330_face"

        let url = URL(string: (imgURL+item.poster_path))
        
        posterImageView.kf.setImage(with: url)
        
        // 디자인
        cardView.backgroundColor = .white
        cardView.layer.borderColor = UIColor.systemGray5.cgColor
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOpacity = 0.18
    
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true
        
        linkButton.layer.cornerRadius = linkButton.frame.width/2
        adultLabel.layer.cornerRadius = adultLabel.frame.width/2
    }
    
    func configureGenre( genres: [String]) {
        var text = ""
        for i in genres {
            text = text + " \(i)"
        }
        genreLabel.text = text
        
    }
}
