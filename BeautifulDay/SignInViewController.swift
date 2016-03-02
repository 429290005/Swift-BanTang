//
//  SingInViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/19.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    /// backImageView
    var imgView: UIImageView?
    
    /// 连续签到次数
    var signCountLabel: UILabel?
    /// 签到细节
    var signDetailLabel: UILabel?
    
    /// 底部签到 view
    var scoreView: UIView?
    /// 补签次数提示
    var resignLabel: UILabel?
    /// 我的积分
    var myScoreLabel: UILabel?
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "签到咯"
        self.view.backgroundColor = UIColor.whiteColor()
        
        buildUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func buildUI() {
        imgView = UIImageView.init(frame: CGRectMake(5, 5, SCREEN_WIDTH - 10, SCREEN_WIDTH - 10))
        imgView?.image = UIImage(named: "SignInBackImage")
        view.addSubview(imgView!)
        
        signCountLabel = UILabel.init(frame: CGRectMake(11, CGRectGetMaxY(imgView!.frame) + 56/2, SCREEN_WIDTH, 15))
        signCountLabel?.text = "连续签到 1 天了"
        signCountLabel?.font = UIFont(name: LightFont, size: 15.0)
        signCountLabel?.textColor = MainTitleColor
        view.addSubview(signCountLabel!)
        
        signDetailLabel = UILabel.init(frame: CGRectMake(11, CGRectGetMaxY(signCountLabel!.frame) + 10, SCREEN_WIDTH, 12.0))
        signDetailLabel?.text = "连续签到明天可获得的额外的10分奖励"
        signDetailLabel?.font = UIFont(name: LightFont, size: 12.0)
        signDetailLabel?.textColor = SubTitleColor
        view.addSubview(signDetailLabel!)
        
        scoreView = UIView.init(frame: CGRectMake(0, 770/2, SCREEN_WIDTH, SCREEN_HEIGHT - 770/2))
        scoreView?.backgroundColor = UIColor(hexString: "F4F4F4")
        view.addSubview(scoreView!)
    
        resignLabel = UILabel.init(frame: CGRectMake(0, 20, SCREEN_WIDTH, 116/2))
        resignLabel?.backgroundColor = UIColor.whiteColor()
        resignLabel?.text = " 您有2张补签卡"
        resignLabel?.textColor = UIColor.blackColor()
        resignLabel?.font = UIFont(name: LightFont, size: 15.0)
        scoreView?.addSubview(resignLabel!)
        
        print(scoreView!.frame.height - 116/2)
        myScoreLabel = UILabel.init(frame: CGRectMake(0, 116/2+10, SCREEN_WIDTH, 105/2))
        myScoreLabel?.backgroundColor = UIColor.whiteColor()
        let attributeStr = NSMutableAttributedString(string: " 我的积分:60")
        let temp = " 我的积分:60"
        //添加 文字颜色
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, 6))
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(6, 2))
        //添加 字体
        attributeStr.addAttribute(NSFontAttributeName, value: UIFont(name: LightFont, size: 14.0)!, range: NSMakeRange(0, temp.characters.count))
        myScoreLabel?.attributedText = attributeStr
        scoreView?.addSubview(myScoreLabel!)
    }
    
}
