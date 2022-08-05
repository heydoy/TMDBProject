//
//  MovieDetailViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import UIKit
import Alamofire
import Kingfisher
import JGProgressHUD


class MovieDetailViewController: UIViewController{

    // MARK: - Properties
    static let identifier = "MovieDetailViewController"
    
    var movie: Item?
    var list: [Cast] = []
    
    let hud = JGProgressHUD()
    
    let defaultOverviewHeight: CGFloat = 80
    var overviewHeight: CGFloat = 80
    var overviewOpened: Bool = false
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        configure()
        requestCast()

    }
    
    // MARK: - Actions
    
    func requestCast() {
        hud.show(in: self.view)
        guard let movieID = self.movie?.id else {
            print("영화 ID가 없습니다.")
            return
        }
        
        MovieAPIManager.shared.getMovieCast(movie_id: movieID) { list in
            self.list.append(contentsOf: list)
            print("캐스팅 ---> \(self.list)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
            
        
        
        hud.dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    func configure() {
        if let item = self.movie {
            titleLabel.text = item.title
            
            let imgURL = "https://image.tmdb.org/t/p/w220_and_h330_face"
            let url = URL(string: (imgURL + item.poster_path))
            let backUrl = URL(string: (imgURL + item.backdrop_path))
            posterImageView.kf.setImage(with: url)
            posterImageView.contentMode = .scaleAspectFill
            backgroundImageView.kf.setImage(with: backUrl)
            backgroundImageView.contentMode = .scaleAspectFill
            
            
        }
    }



}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Overview"
        } else if section == 1 {
            return "Cast"
        } else { return "" }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return list.count // 배우수만큼
        }
        else { return 0 }
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
            
            print(list[indexPath.row])
            cell.configure(list[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return overviewHeight
        } else if indexPath.section == 1 {
            return CGFloat(90)
        } else {
            return CGFloat(0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            tableView.beginUpdates()
            overviewHeight = overviewOpened ?
                            defaultOverviewHeight : UITableView.automaticDimension
            overviewOpened = !overviewOpened
            tableView.endUpdates()
        }
    }
}
