//
//  HomeCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/14.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    let titleLabel = UILabel()
    let likeLabel = UILabel()
    let imgView = UIImageView()
    var listID = String()
    
    var model: ProductRecommendModel? {
        didSet {
            titleLabel.text = model?.title
            likeLabel.text = "喜欢:\(model!.likesNumber!)"
            imgView.sd_setImageWithURL(NSURL(string:  model!.imageUrl!), placeholderImage:UIImage(named: "placeHolder.jpg"))
            listID = model!.productID!
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.tag = 110
        
        titleLabel.textColor = MainTitleColor
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.frame = CGRectMake(0, 342/2, SCREEN_WIDTH, 63/2)
        contentView.addSubview(titleLabel)
        
        //已经喜欢的人数
        
        likeLabel.tag = 111
        likeLabel.frame = CGRectMake(0, 468/2-70/2, SCREEN_WIDTH, 63/2)
        likeLabel.textAlignment = NSTextAlignment.Center
        likeLabel.textColor = SubTitleColor
        likeLabel.font = UIFont.systemFontOfSize(14.0)
        contentView.addSubview(likeLabel)
    
        imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 171)
        contentView.addSubview(imgView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let identifier = "homeCell"
    class func cell(tableView: UITableView, model: ProductRecommendModel?) -> HomeCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? HomeCell
        
        if cell == nil {
            cell = HomeCell(style: .Default, reuseIdentifier: identifier) as HomeCell
        }
        
        cell?.model = model
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }

}



