//
//  PersonCenterActivityCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/29.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class PersonCenterActivityCell: UICollectionViewCell {

    private var imgView: UIImageView?
    private var detailLabel: CMLabel?
    
    private var likeBtn: UIButton?
    
    private var model: UserRecommendModel? {
        didSet{
            
            imgView?.sd_setImageWithURL(NSURL(string: (model?.picArray![0].url)!), placeholderImage: UIImage(named: "placeHolder"))
            
            detailLabel!.title = (model?.content)!
            detailLabel?.frame = CGRectMake(0, 145, 145, 47)
            
            let str = "\((model?.dynamic?.likesCount)!)"
            likeBtn?.setTitle(str, forState: .Normal)
            likeBtn?.frame = CGRectMake(frame.width - 28 - CGFloat(str.characters.count*12) , 60+145, 28 + CGFloat(str.characters.count*12), 23.0)
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
    
        detailLabel = CMLabel(frame: CGRectMake(0, 145, 145, 120), title: "placeHolder", font: UIFont(name: LightFont, size: 14.0)!, textColor: MainTitleColor, lineSpacing: 4.0, textEdgeInsets: UIEdgeInsetsMake(0, 7, 0, 0))
        detailLabel?.clipsToBounds = true
        contentView.addSubview(detailLabel!)
        
        likeBtn = UIButton(frame: CGRectZero)
        likeBtn?.setImage(UIImage(named: "addToFavorite_selected"), forState: .Normal)
        likeBtn?.setImage(UIImage(named: "addToFavorite_selected"), forState: .Highlighted)
        likeBtn?.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        likeBtn?.setTitleColor(SubTitleColor, forState: .Normal)
        likeBtn?.titleLabel?.font = UIFont(name: LightFont, size: 12.0)
        contentView.addSubview(likeBtn!)
    }
    
    static let cellID = "PersonCenterActivityCell"
    class func cell(collectionView: UICollectionView , indexPath: NSIndexPath , model: UserRecommendModel) -> PersonCenterActivityCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PersonCenterActivityCell
        
        cell.model = model
        
        return cell
    }
    
}
