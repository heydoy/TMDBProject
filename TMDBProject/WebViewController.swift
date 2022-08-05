//
//  WebViewViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/05.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Properties
    static let identifier = "WebViewController"

    var movie_id: Int = 0
    var key: String = ""
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        getVideo()
        
    }
    // MARK: - Actions
    func getVideo() {
        MovieAPIManager.shared.getMovieVideo(movie_id: movie_id) { list in
            self.key = list[0].key
            
            let destinationURL = "https://www.youtube.com/watch?v=\(self.key)"
            
            DispatchQueue.main.async {
                self.openWebPage(destinationURL)
            }
        }

    }

}

extension WebViewController: WKNavigationDelegate {
    func openWebPage(_ url: String) {
        // URL구조가 맞는지, 유효성 체크
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
}
