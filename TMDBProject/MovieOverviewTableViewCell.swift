//
//  MovieOverviewTableViewCell.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import UIKit

class MovieOverviewTableViewCell: UITableViewCell {
    static let identifier = "MovieOverviewTableViewCell"
    
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ overview: String) {
        overviewLabel.text = overview
    }

}
