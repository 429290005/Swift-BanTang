//
//  DoubleLabel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/26.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class DoubleLabel: UIView {

    var topTitle = "999" {
        didSet{
            firstLabel.text = topTitle
        }
    }
    var bottomTitle = "大赞" {
        didSet{
            secondLabel.text = bottomTitle
        }
    }
    
    
    
    private var firstLabel = UILabel()
    
    private var secondLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    
    convenience init(TopTitle: String,BottomTitle: String) {
        self.init()
        
        topTitle = TopTitle
        bottomTitle = BottomTitle
        
        buildUI()
    }
    
    //MARK: buiuld UI
    func buildUI() {
        firstLabel.frame = CGRectMake(0, 0, 50, 14)
        firstLabel.font = UIFont(name: LightFont, size: 14.0)
        firstLabel.textColor = UIColor.whiteColor()
        firstLabel.textAlignment = .Center
        firstLabel.text = topTitle
        addSubview(firstLabel)
        
        secondLabel.frame = CGRectMake(0, CGRectGetMaxY(firstLabel.frame) + 8, 50, 14.0)
        secondLabel.font = UIFont(name: LightFont, size: 14.0)
        secondLabel.textColor = UIColor.whiteColor()
        secondLabel.textAlignment = .Center
        secondLabel.text = bottomTitle
        addSubview(secondLabel)
    }
    
}
