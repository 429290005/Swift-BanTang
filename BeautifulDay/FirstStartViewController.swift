//
//  FirstStartViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/3/1.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

private let MyWord = ["ManoBoo编写","语言:Swift 2.0 工具:Xcode 7.1","非常感谢运行我的App","有问题或建议请联系我的简书或QQ","页面较多，很多部分并没有做完","请参考首页，首页完成度较高"]

public let DismissFirstViewController_Notification = "DismissFirstViewController_Notification"

class FirstStartViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    private var backImgView = UIImageView()
    
    private var showTableView = UITableView()
    
    private var startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        buildUI()
        
        buildTableView()
        
        performSelector("startAnimation", withObject: nil, afterDelay: 0.3)
    }
    
    func buildUI() {
        view.userInteractionEnabled = false
        
        backImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        backImgView.image = UIImage(named: "appStartBackImage")
        view.addSubview(backImgView)
        
        startButton = UIButton()
        startButton.alpha = 0.0
        startButton.setTitle("开启App之旅", forState: .Normal)
        startButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startButton.titleLabel?.font = UIFont(name: LightFont, size: 18.0)
        startButton.titleLabel?.textAlignment = .Center
        startButton.sizeToFit()
        startButton.frame = CGRectMake(SCREEN_WIDTH/2 - startButton.frame.width/2 - 10, SCREEN_HEIGHT - 60, startButton.frame.width + 20, startButton.frame.height + 8)
        startButton.layer.cornerRadius = 10.0
        startButton.addTarget(self, action: "closeFirstViewController", forControlEvents: .TouchUpInside)
        view.addSubview(startButton)
    }
    
    
    
    //build TableView
    func buildTableView() {
        showTableView = UITableView(frame: CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, CGFloat(40 * MyWord.count)), style: .Plain)
        showTableView.backgroundColor = UIColor.clearColor()
        showTableView.separatorStyle = .None
        showTableView.delegate = self
        showTableView.dataSource = self
        view.addSubview(showTableView)
        
    }
    
    //MARK: uitableviewdelegate datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyWord.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIDedtifier")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CellIDedtifier")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .None
            cell?.textLabel?.alpha = 0.0
            cell?.textLabel?.font = UIFont(name: LightFont, size: 20.0)
            cell?.textLabel?.textAlignment = .Center
            cell?.textLabel?.textColor = UIColor(hexString: "99DF07")
        }
        cell?.textLabel?.text = MyWord[indexPath.row]
        
        return cell!
    }
    
    
    //MARK: 开始动画效果
    func startAnimation() {
        //改变showTableView frame
        weak var weakSelf = self
        UIView.animateWithDuration(4.0, animations: { () -> Void in
            weakSelf!.showTableView.frame = CGRectMake(0, SCREEN_HEIGHT/2 - weakSelf!.showTableView.frame.height, SCREEN_WIDTH, weakSelf!.showTableView.frame.height)
            
            for var i = 0 ;i < MyWord.count ; i++ {
                let cell = weakSelf!.showTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    cell?.textLabel?.alpha = 1.0
                })
                
            }
            
            }) { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    //延时2s 移除tableview
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        weakSelf!.showTableView.removeFromSuperview()
                    })
                    
                    weakSelf!.startButton.alpha = 1.0
                    weakSelf!.view.userInteractionEnabled = true
                })
        }
    }
    
    
    //MARK: 动画完毕 点击开启app之旅   发出通知 appDelegate 将window.rootViewController更改为tabbarController
    func closeFirstViewController() {
        //先放大imgview
        weak var weakSelf = self
        UIView.animateWithDuration(0.5, animations: { () -> Void in
                weakSelf!.backImgView.transform = CGAffineTransformMakeScale(1.2, 1.2)
                weakSelf!.backImgView.alpha = 0.7
            }) { (finished: Bool) -> Void in
                 NSNotificationCenter.defaultCenter().postNotificationName(DismissFirstViewController_Notification, object: nil)
        }
    }
    
    
    
    //
     
    
}
