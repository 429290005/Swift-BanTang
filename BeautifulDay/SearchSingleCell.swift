//
//  SearchSingleCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/1.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SearchSingleCell: UICollectionViewCell {

    var iconImgView = UIImageView()
    var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchModel: SearchModel?{
        didSet{
            iconImgView.sd_setImageWithURL(NSURL(string: "\(searchModel!.iconUrl!)"), placeholderImage: UIImage(named: "placeHolder"))
            nameLabel.text = searchModel!.name!
        }
    }
    
    
    func buildCell()
    {
        iconImgView = UIImageView.init(frame: CGRectMake(0, 0, 60, 60))
        
        contentView.addSubview(iconImgView)
        
        nameLabel = UILabel.init(frame: CGRectMake(0, 60, 60, 20))
        nameLabel.textColor = SubTitleColor
        nameLabel.font = UIFont.systemFontOfSize(13.0)
        nameLabel.textAlignment = .Center
        contentView.addSubview(nameLabel)
    }

}


class SearchListCell: SearchSingleCell {
    
    var englishNameLabel = UILabel()
    
    var listModel: SearchListModel?{
        didSet{
            iconImgView.sd_setImageWithURL(NSURL(string: "\(listModel!.iconUrl!)"), placeholderImage: UIImage(named: "placeHolder"))
            nameLabel.text = listModel!.name!
            englishNameLabel.text = listModel?.en_name!
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func buildCell()
    {
        super.buildCell()
        
        englishNameLabel = UILabel.init(frame: CGRectMake(0, 80, 60, 20))
        englishNameLabel.textAlignment = .Center
        englishNameLabel.textColor = SubTitleColor
        englishNameLabel.font = UIFont.systemFontOfSize(13.0)
        contentView.addSubview(englishNameLabel)
    }

    
}