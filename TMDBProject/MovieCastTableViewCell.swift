//
//  MovieCastTableViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import UIKit
import Kingfisher

class MovieCastTableViewCell: UITableViewCell {
    static let identifier = "MovieCastTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var characterLable: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ cast: Cast) {
        nameLabel.text = cast.name
        characterLable.text = cast.character
        
        let imgURL = "https://image.tmdb.org/t/p/w220_and_h330_face"
        if let profileURL = cast.profile_path {
            let url = URL(string: (imgURL + profileURL))
            
            profileImageView.kf.setImage(with: url)
        }
        
        profileImageView.contentMode = .scaleAspectFill
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
    }

}
