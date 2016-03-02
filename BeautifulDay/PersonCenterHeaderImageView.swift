//
//  PersonCenterHeaderImageView.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/25.
//  Copyright © 2016年 jiachen. All rights reserved.
//  tips: 个人中心

import UIKit

class PersonCenterHeaderImageView: UIView {

    var headerButton = UIButton()
    //  头像
    var headerImage = UIImage(named: "headerImage") {
        didSet{
            let image = ImageOperationCenter.HeaderImageOperation(headerImage!, borderColor: UIColor.whiteColor(), borderWidth: 1.0)
//            let image = ImageOperationCenter.HeaderImageFromCamera(headerImage!, borderColor: UIColor.whiteColor(), borderWidth: 1.0)
            headerButton.setImage(image, forState: .Normal)
            headerButton.setImage(image, forState: .Highlighted)
            headerButton.contentMode = .ScaleAspectFit
        }
    }
    
    private var settingBtn = UIButton()
    
    var selectSexBtn = UIButton()
    
    //点击 头像 button
    var clickHeaderImage: ( () -> () )?
    
    //点击 设置按钮
    var clickSettingButton: ( () -> () )?
    
    //点击设置性别
    var clickSelectSex: ( () -> () )?
    
    var nameLabel = UILabel()
    
    var signiture = "天将降大任于斯人也" {
        didSet{
            signLabel.text = signiture
            signLabel.sizeToFit()
        }
    
    }
    var signLabel = UILabel()
    
    // 成就
    private var achievementLabel: DoubleLabel?
    
    //上精选
    private var goodSelectedLabel: DoubleLabel?
    
    //赞
    private var praiseLabel: DoubleLabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        buildUI()
    }
    
   

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: build UI
    func buildUI() {
        //头像
        headerButton = UIButton.init(frame: CGRectMake(SCREEN_WIDTH/2 - 30, 50, 60, 60))
        let image = ImageOperationCenter.HeaderImageOperation(headerImage!, borderColor: UIColor.whiteColor(), borderWidth: 2.0)
        headerButton.setImage(image, forState: .Normal)
        headerButton.setImage(image, forState: .Highlighted)
        headerButton.imageView?.layer.cornerRadius = 30.0
        headerButton.layer.masksToBounds = true
        headerButton.clipsToBounds = true
        headerButton.addTarget(self, action: "changeMyHeaderImage", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(headerButton)
        
        //用户名
        nameLabel = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(headerButton.frame) + 13, SCREEN_WIDTH, 15))
        nameLabel.font = UIFont(name: RegularFont, size: 15.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text = "ManoBoo"
        nameLabel.textAlignment = .Center
        addSubview(nameLabel)
        
        //签名
        signLabel.text = signiture
        signLabel.textColor = UIColor.whiteColor()
        signLabel.font = UIFont(name: LightFont, size: 13.0)
        signLabel.sizeToFit()
        signLabel.frame = CGRectMake(SCREEN_WIDTH/2 - signLabel.frame.width/2, CGRectGetMaxY(nameLabel.frame) + 13, signLabel.frame.width, signLabel.frame.height)
        addSubview(signLabel)
        
        //成就
        achievementLabel = DoubleLabel(TopTitle: "99", BottomTitle: "成就")
        achievementLabel?.frame = CGRectMake(32, CGRectGetMaxY(signLabel.frame) + 15, 50, 45)
        addSubview(achievementLabel!)
        
        //上精选
        goodSelectedLabel = DoubleLabel(TopTitle: "998", BottomTitle: "上精选")
        goodSelectedLabel?.frame = CGRectMake(CGRectGetMaxX(achievementLabel!.frame) + 55, achievementLabel!.frame.origin.y, 50, 45)
        addSubview(goodSelectedLabel!)
        
        //赞
        praiseLabel = DoubleLabel(TopTitle: "1998", BottomTitle: "打赏")
        praiseLabel?.frame = CGRectMake(CGRectGetMaxX(goodSelectedLabel!.frame) + 55, goodSelectedLabel!.frame.origin.y, 50, 45)
        addSubview(praiseLabel!)
        
        //设置按钮
        settingBtn = UIButton.init(frame: CGRectMake(SCREEN_WIDTH - 20 - 24, 30, 24, 24))
        settingBtn.setImage(UIImage(named: "iconfont-shezhi"), forState: .Normal)
        settingBtn.addTarget(self, action: "clickSettingBtn", forControlEvents: .TouchUpInside)
        addSubview(settingBtn)
        
        //选择性别
        selectSexBtn.frame = CGRectMake(20, 30, 24, 24)
        if UserSex.containsString("帅哥") {
            selectSexBtn.setImage(UIImage(named: "iconfont-男人"), forState: .Normal)
        }else {
            selectSexBtn.setImage(UIImage(named: "iconfont-女人"), forState: .Normal)
        }
        selectSexBtn.addTarget(self, action: "clickSelectSexButton", forControlEvents: .TouchUpInside)
        addSubview(selectSexBtn)
    }
    
    // 事件处理
    func changeMyHeaderImage() {
        if clickHeaderImage != nil {
            print("更换我的头像咯")
            clickHeaderImage!()
        }
    }
    func clickSettingBtn() {
        if clickSettingButton != nil {
            clickSettingButton!()
        }
    }
    
    func clickSelectSexButton() {
        if clickSelectSex != nil {
            clickSelectSex!()
        }
    }
}
