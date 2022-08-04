//
//  MainViewController.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/04.
//

import UIKit
import Tabman
import Pageboy

class MainViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {

    private var viewControllers: Array<UIViewController> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // datasource 위임
        self.dataSource = self
        
        // 탭에 따라 보여줄 화면 추가
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MovieViewController.identifier) as! MovieViewController
        
        viewControllers.append(vc1)
        viewControllers.append(vc1)
        
        // 상단 탭바 만들기
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // 커스텀
        
        // 뷰에 바 추가
        addBar(bar, dataSource: self, at: .bottom)
        
        
        

   }
    


}

extension MainViewController {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = "Page \(index)"
        item.image = UIImage(named: "star.fill")
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
