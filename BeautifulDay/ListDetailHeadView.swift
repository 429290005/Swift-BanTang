//
//  ListDetailHeadView.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/21.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class ListDetailHeadView: UIView {
    
    var title = String()
    var subTitle = String()
    var image = UIImage()
    
    
    /// 图片
    var imageView = UIImageView()
    /// 清单标题
    private var titleLabel    = CMLabel()
    /// 清单详情描述
    private var subTitleLabel = CMLabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title:String,subTitle:String,image:UIImage) {
        self.init()
        self.title = title
        self.subTitle = subTitle
        self.image = image
        
        buildUI()
    }
    
    func buildUI()
    {
        imageView = UIImageView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 342/2))
        imageView.image = image
        self.addSubview(imageView)
        
        titleLabel = CMLabel.init(frame: CGRectMake(0, 324/2, SCREEN_WIDTH, 96/2), title: title, font: UIFont.systemFontOfSize(18.0), textColor: MainTitleColor, lineSpacing: 0.0, textEdgeInsets: UIEdgeInsetsMake(10, 12, 0, 0))
        
        self.addSubview(titleLabel)
        
        subTitleLabel = CMLabel.init(frame:CGRectMake(0, 219, SCREEN_WIDTH, 100),title: subTitle, font: UIFont.systemFontOfSize(15.0), textColor: SubTitleColor, lineSpacing: 10.0, textEdgeInsets: UIEdgeInsetsMake(0, 12, 0, 0))
        addSubview(subTitleLabel)
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 219+subTitleLabel.frame.size.height+20)
    }
    
}
