//
//  SquareCategoryCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/24.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SquareCategoryCell: SearchListCell {
    var squareModel: SearchListModel?{
        didSet{
            iconImgView.sd_setImageWithURL(NSURL(string: (squareModel?.iconUrl)!), placeholderImage: UIImage(named: "placeHolder"))
            iconImgView.layer.cornerRadius = iconImgView.frame.width / 2 
            
            nameLabel.text = squareModel!.name!
            englishNameLabel.text = squareModel!.sub_title!
            englishNameLabel.font = UIFont(name: LightFont, size: 10.0)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.buildCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
