//
//  TipView.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/20.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class TipView: UIView {
    
    private var tipLabel = UILabel()

    override  init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(tips:String)
    {
        self.init()
        self.createMain(tips)
    }
    func createMain(tips:String)
    {
        tipLabel = UILabel()
        tipLabel.font = UIFont.systemFontOfSize(15.0)
        tipLabel.text = tips
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.sizeToFit()
        tipLabel.frame = CGRectMake(4, 4, tipLabel.frame.size.width, tipLabel.frame.size.height)
        
        self.frame = CGRectMake(0, 0, tipLabel.frame.size.width+8, tipLabel.frame.size.height+8)
        self.layer.cornerRadius = 3.0
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        self.backgroundColor = UIColor.blackColor()
        self.addSubview(tipLabel)
    }
    
    func show()
    {
        //添加到keyWindow上
        let keyWindow = UIApplication.sharedApplication().keyWindow
        keyWindow?.addSubview(self)
    
        weak var weakSelf = self
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                weakSelf?.alpha = 0.0
                }, completion: { (finished:Bool) -> Void in
                    if(finished)
                    {
                        weakSelf?.removeFromSuperview()
                    }
            })
            
        })

    
    }
    

    
    //调用类方法 即可 省略初始化方法
    class func showMessage(tips:String)
    {
        let tipView = TipView(tips: tips)
        tipView.show()
    }
}
