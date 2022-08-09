//
//  CardView.swift
//  TMDBProject
//
//  Created by Doy Kim on 2022/08/09.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        self.addSubview(view)
        
    }

}
