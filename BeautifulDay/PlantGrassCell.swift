//
//  PlantGrassCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/20.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class PlantGrassCell: UICollectionViewCell {
    /// 显示图片
    private var imgView: UIImageView!
    /// 小分队的名称
    private var teamNameLabel = UILabel()
    /// 浏览次数 帖子数量
    private var teamParameterLabel:UILabel!
    
    private var model: PlantGrassTeamModel? {
        didSet{
            
            imgView.sd_setImageWithURL(NSURL(string: (model?.pic2)!), placeholderImage: UIImage(named: "placeHolder"))
            
            teamNameLabel.text = (model?.teamName)!
            teamNameLabel.sizeToFit()
            teamNameLabel.frame = CGRectMake(SCREEN_WIDTH/2 - teamNameLabel.frame.width/2 - 15, 25, teamNameLabel.frame.width + 30, 35)
            
            teamParameterLabel.text = "\((model?.lookCount)!)浏览  \((model?.postsCount)!)帖子"
            teamParameterLabel.sizeToFit()
            teamParameterLabel.frame = CGRectMake(SCREEN_WIDTH/2 - teamParameterLabel.frame.width/2, CGRectGetMaxY(teamNameLabel.frame) + 10, teamParameterLabel.frame.width, 12)
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
        imgView = UIImageView.init(frame: CGRectMake(0, 0, frame.width, frame.height))
        imgView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(imgView)
        
        teamNameLabel.textAlignment = .Center
        teamNameLabel.layer.zPosition = 2.0
        teamNameLabel.layer.cornerRadius = 3.0
        teamNameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        teamNameLabel.layer.borderWidth = 0.5
        teamNameLabel.font = UIFont(name: LightFont, size: 15.0)
        teamNameLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(teamNameLabel)
        
        teamParameterLabel = UILabel()
        teamParameterLabel.textAlignment = .Center
        teamParameterLabel.textColor = UIColor.whiteColor()
        teamParameterLabel.font = UIFont(name: LightFont, size: 12.0)
        contentView.addSubview(teamParameterLabel)
    }
    
    static let cellID = "PlantGrassTeamCellIDentfier"
    class func cell(collectionView:UICollectionView,Indexpath: NSIndexPath,model:PlantGrassTeamModel) -> PlantGrassCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: Indexpath) as! PlantGrassCell
        cell.model = model
        
        return cell
    
        
    
    }
    
}
