//
//  PersonCenterSingleCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/29.
//  Copyright © 2016年 jiachen. All rights reserved.
//  tips: 个人中心 单品 cell 这里没有去抓包 用的是 底妆搜索的结果，。

import UIKit

class PersonCenterSingleCell: UICollectionViewCell {

    private var imgView: UIImageView?
    
    private var likesCountLabel: UILabel?
    
    private var model: SearchSingleGoodsModel? {
        didSet{
            if model != nil {
                imgView?.sd_setImageWithURL(NSURL(string: (model?.imageUrl)!), placeholderImage: UIImage(named: "placeHolder"))
                likesCountLabel?.text = "\((model?.likeNumbers)!)喜欢"
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        imgView = UIImageView(frame: CGRectMake(0, 0, 145, 145))
        imgView?.image = UIImage(named: "placeHolder")
        contentView.addSubview(imgView!)
        
        likesCountLabel = UILabel(frame: CGRectMake(0,145,frame.width,25))
        likesCountLabel?.textAlignment = .Center
        likesCountLabel?.textColor = MainTitleColor
        likesCountLabel?.font = UIFont(name: LightFont, size: 15.0)
        contentView.addSubview(likesCountLabel!)
    }
    
    static let cellID = "PersonCenterSingleCell"
    class func cell(collectionView: UICollectionView,indexPath: NSIndexPath,model: SearchSingleGoodsModel) -> PersonCenterSingleCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PersonCenterSingleCell
        cell.model = model
        
        return cell

    }
}
