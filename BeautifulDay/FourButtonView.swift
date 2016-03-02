//
//  FourButtonView.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/26.
//  Copyright © 2016年 jiachen. All rights reserved.
//  订单 好友 积分 小分队

import UIKit

enum FourButtonType: Int{
    case OrderButtonClick = 110
    case FriedButtonClick = 111
    case PointBUttonClick = 112
    case TeamButtonClick  = 113
}


class FourButtonView: UIView {

    private var orderBtn: UIButton?
    private var friendBtn: UIButton?
    private var pointBtn: UIButton?
    private var teamBtn: UIButton?
    
    //点击事件处理
    var fourButtonClickCenter: ( (Int) -> () )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        var orginX = CGFloat(112/5)
        orderBtn = UIButton(frame: CGRectMake(orginX,18,52,80))
        orderBtn?.tag = FourButtonType.OrderButtonClick.rawValue
        orderBtn?.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        orderBtn?.setImage(UIImage(named: "button_order"), forState: .Normal)
        orderBtn?.setImage(UIImage(named: "button_order"), forState: .Highlighted)
        addSubview(orderBtn!)
        orginX += 52+22
    
        friendBtn = UIButton(frame: CGRectMake(orginX,18, 52, 80))
        friendBtn?.tag = FourButtonType.FriedButtonClick.rawValue
        friendBtn?.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        friendBtn?.setImage(UIImage(named: "button_friend"), forState: .Normal)
        friendBtn?.setImage(UIImage(named: "button_friend"), forState: .Highlighted)
        addSubview(friendBtn!)
        orginX += 52+22
        
        pointBtn = UIButton(frame: CGRectMake(orginX,18,52,80))
        pointBtn?.tag = FourButtonType.PointBUttonClick.rawValue
        pointBtn?.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        pointBtn?.setImage(UIImage(named: "button_point"), forState: .Normal)
        pointBtn?.setImage(UIImage(named: "button_point"), forState: .Highlighted)
        addSubview(pointBtn!)
        orginX += 52+22
        
        teamBtn = UIButton(frame: CGRectMake(orginX,18,52,80))
        teamBtn?.tag = FourButtonType.TeamButtonClick.rawValue
        teamBtn?.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        teamBtn?.setImage(UIImage(named: "button-_team"), forState: .Normal)
        teamBtn?.setImage(UIImage(named: "button-_team"), forState: .Highlighted)
        addSubview(teamBtn!)
    }
    
    
    func clickCenter(sender: UIButton) {
        if fourButtonClickCenter != nil {
            
            fourButtonClickCenter!(sender.tag)
        }
    
    }
}
