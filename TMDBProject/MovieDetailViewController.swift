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

struct Cast: Codable {
    var name: String
    var character: String
    var profile_path: String?
}

struct Casts: Codable {
    var id: Int
    var cast: [Cast]
}
class MovieDetailViewController: UIViewController{

    // MARK: - Properties
    static let identifier = "MovieDetailViewController"
    
    var movie: Item?
    var list: [Cast] = []
    
    let hud = JGProgressHUD()
    
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
        
        guard let movie_id = movie?.id else {
            print("id가 없습니다.")
            return
        }
        
        hud.show(in: self.view)
        let url = "https://api.themoviedb.org/3/movie/\(movie_id)/credits"
        
        let parameter: Parameters = [
            "api_key" : Keys.TMDB
        ]
        
        AF.request(url, method: .get, parameters: parameter).validate().responseDecodable(of: Casts.self) { response in
            switch response.result {
            case .success(let value) :
                print(value)
                self.list.append(contentsOf: value.cast)
                print(self.list)
                self.hud.dismiss(animated: true)
                self.tableView.reloadData()
                
                
            case .failure(let error) :
                self.hud.dismiss(animated: true)
                print(error)
            }
        }
        
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
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return list.count // 배우수만큼
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
            overviewHeight = overviewOpened ? 80 : UITableView.automaticDimension
            overviewOpened = !overviewOpened
            tableView.endUpdates()
            

        }
    }
}
