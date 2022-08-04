//
//  MovieDetailViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController{

    
    static let identifier = "MovieDetailViewController"
    
    var movie: Item?
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        configure()

    }
    
    func configure() {
        if let movie = self.movie {
            titleLabel.text = movie.title
            
            let imgURL = "https://image.tmdb.org/t/p/w220_and_h330_face"
            let url = URL(string: (imgURL + movie.poster_path))
            let backUrl = URL(string: (imgURL + movie.backdrop_path))
            posterImageView.kf.setImage(with: url)
            posterImageView.contentMode = .scaleAspectFill
            backgroundImageView.kf.setImage(with: backUrl)
            backgroundImageView.contentMode = .scaleAspectFill
            
            
        }
    }



}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 4 // 배우수만큼
        }
        else { return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieOverviewTableViewCell.identifier, for: indexPath) as? MovieOverviewTableViewCell else { return UITableViewCell() }
            
            if let item = self.movie {
                cell.configure(item.overview)
                print(item)
            }
            
            return cell
        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCastTableViewCell.identifier, for: indexPath) as? MovieCastTableViewCell else { return UITableViewCell() }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(115)
        } else if indexPath.section == 1 {
            return CGFloat(90)
        } else {
            return CGFloat(0)
        }
    }
}
