//
//  CMLable.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/21.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class CMLabel: UIView {
    
    var titleLabel = UILabel()
    var title = String() {
        didSet{
            //重建label
            titleLabel.removeFromSuperview()
            buildUI()
        }
    }
    
    private var font = UIFont()
    private var textColor = UIColor()
    private var textEdgeInsets = UIEdgeInsets()
    private var textSpacing = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     UIView实现label
     
     - parameter title:          显示的文字
     - parameter font:           字体
     - parameter textColor:      文字颜色
     - parameter textEdgeInsets: 文字距离边界的偏移量
     
     - returns: 自定义label
     */
    convenience init(frame:CGRect,title:String,font:UIFont,textColor:UIColor,lineSpacing:CGFloat,textEdgeInsets:UIEdgeInsets) {
        self.init(frame:frame)
        self.title = title
        self.font = font
        self.textColor = textColor
        self.textSpacing = lineSpacing
        self.textEdgeInsets = textEdgeInsets
        self.buildUI()
    }
    
    
    
    private func buildUI()
    {
        titleLabel = UILabel(frame: CGRectMake(textEdgeInsets.left, textEdgeInsets.top, self.frame.size.width-textEdgeInsets.left, titleLabel.frame.size.height))
        titleLabel.numberOfLines = 0

        let attributesString = NSMutableAttributedString.init(string: title)
        
        let style1 = NSMutableParagraphStyle.init()
        style1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        style1.lineSpacing = textSpacing
        //添加 行间距
        attributesString.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, title.characters.count))
        //添加 文字颜色
        attributesString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, title.characters.count))
        //添加 字体
        attributesString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, title.characters.count))
        
        titleLabel.attributedText = attributesString
               titleLabel.sizeToFit()
        

        
        titleLabel.frame = CGRectMake(textEdgeInsets.left, textEdgeInsets.top, self.frame.size.width-textEdgeInsets.left, titleLabel.frame.size.height)
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+textEdgeInsets.top, self.frame.size.width, titleLabel.frame.size.height+textEdgeInsets.top)
        
        
        
        
        self.addSubview(titleLabel)
    }
    

}
