//
//  SelectedSexViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/29.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SelectedSexViewController: BaseViewController {

    private var tipLabel = UILabel()
    
    private var manButton = UIButton()
    private var womanButton = UIButton()
    
    private var completeBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "F5F5F5")
        self.title = "个性化"
        
        buildUI()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserSex.containsString("帅哥") {
            manButton.selected = true
            womanButton.selected = false
        }else {
            manButton.selected = false
            womanButton.selected = true
        }
    }
    
    func buildUI() {
        tipLabel = UILabel(frame: CGRectZero)
        tipLabel.text = "请问你是帅帅哒还是美美哒\n说说也没有什么大不了嘛"
        tipLabel.textAlignment = .Center
        tipLabel.font = UIFont(name: LightFont, size: 16.0)
        tipLabel.textColor = CustomBarTintColor
        tipLabel.numberOfLines = 0
        tipLabel.sizeToFit()
        tipLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 45)
        view.addSubview(tipLabel)
        
        manButton.frame = CGRectMake(30, 120, 102, 150)
        manButton.tag = 110
        manButton.setImage(UIImage(named: "Man_selected"), forState: .Selected)
        manButton.setImage(UIImage(named: "Man_unselected"), forState: .Normal)
        manButton.adjustsImageWhenHighlighted = false
        manButton.selected = true
        manButton.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        view.addSubview(manButton)
        
        womanButton.frame = CGRectMake(SCREEN_WIDTH - 30 - 102, 120, 102, 150)
        womanButton.tag = 111
        womanButton.setImage(UIImage(named: "Woman_selected"), forState: .Selected)
        womanButton.setImage(UIImage(named: "Woman_unselected"), forState: .Normal)
        womanButton.adjustsImageWhenHighlighted = false
        womanButton.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        view.addSubview(womanButton)
        
        
        completeBtn.layer.cornerRadius = 17.0
        completeBtn.backgroundColor = CustomBarTintColor
        completeBtn.setTitle("完成", forState: .Normal)
        completeBtn.titleLabel?.font = UIFont(name: LightFont, size: 20.0)
        completeBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        completeBtn.sizeToFit()
        completeBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 158/2 - completeBtn.frame.width/2, SCREEN_HEIGHT - 64 - completeBtn.frame.height - 24 - 10, completeBtn.frame.width + 158,  completeBtn.frame
        .height)
        completeBtn.addTarget(self, action: "clickComplete", forControlEvents: .TouchUpInside)
        view.addSubview(completeBtn)
    }
    
    func clickCenter(sender: UIButton) {
        if sender.tag == 110 {
            UserSex = "帅哥哦~"
            
            womanButton.selected = false
            manButton.selected = true
            
        }else {
            UserSex = "美女哦~"
        
            manButton.selected = false
            womanButton.selected = true
        }
    }
    
    func clickComplete() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
