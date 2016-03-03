//
//  SettingViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/26.
//  Copyright © 2016年 jiachen. All rights reserved.
//  tips:设置界面

import UIKit

class SettingViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {

    private var showTableView: UITableView?
    
    /// 关于Boo
    private var aboutView = UIView()
    
    private let cellID = "SettingCell"
    
    private let tableViewData = ["分享我的 APP👍","联系我的简书","微博:木木281","GitHub:点击查看我的GitHub","关于作者"]
    private let iconData = [UIImage(named: "Share_fire"),UIImage(named: "iconfont-jian"),UIImage(named: "iconfont-weiBo"),UIImage(named: "iconfont-github"),UIImage(named: "iconfont-ren")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "F4F4F4")
        
        buildTableView()
        
    }
    
    func buildTableView() {
        showTableView = UITableView(frame: CGRectMake(10, 0, SCREEN_WIDTH, CGFloat(tableViewData.count * 50)), style: .Plain)
        showTableView?.delegate = self
        showTableView?.dataSource = self
        view.addSubview(showTableView!)
    }
    
    //MARK: UITableView Delegate / DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellID)
        }
        
        cell?.imageView?.image = iconData[indexPath.row]
        cell?.textLabel?.text = tableViewData[indexPath.row]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //微信分享*****************
        if indexPath.row == 0 {
            
            let alertController = UIAlertController(title: "去微信分享咯", message: "Boo非常感谢您的分享", preferredStyle: .ActionSheet)
            let action_WXFriend = UIAlertAction(title: "微信好友", style: .Default, handler: { (alertAction) -> Void in
                let message = WXMediaMessage()
                message.title = ShareTitle
                message.description = ShareSubTitle
                message.setThumbImage(UIImage(named: "weixinShareImage"))
                //
                let webObject = WXWebpageObject()
                webObject.webpageUrl = JianShuURL
                message.mediaObject = webObject
              
                let request = SendMessageToWXReq()
                request.bText = false
                request.message = message
                request.scene = Int32(WXSceneSession.rawValue)
                WXApi.sendReq(request)
            })
            
            let action_WXFriendCircle = UIAlertAction(title: "朋友圈", style: .Default, handler: { (alertAction) -> Void in
                let message = WXMediaMessage()
                message.title = ShareTitle
                message.description = ShareSubTitle
                message.setThumbImage(UIImage(named: "weixinShareImage"))

                let webObject = WXWebpageObject()
                webObject.webpageUrl = JianShuURL
                message.mediaObject = webObject
                
                let request = SendMessageToWXReq()
                request.bText = false
                request.message = message
                request.scene = Int32(WXSceneTimeline.rawValue)
                WXApi.sendReq(request)
                
            })
            alertController.addAction(action_WXFriend)
            alertController.addAction(action_WXFriendCircle)
            
            if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
                //检测 微信已经安装 并且支持分享api -> 弹出 分享界面
                presentViewController(alertController, animated: true, completion: nil)
                
            }else {
                TipView.showMessage("微信boom 沙卡拉卡")
            }
        }
            
        //打开简书*****************
        else if indexPath.row == 1 {
            UIApplication.sharedApplication().openURL(NSURL(string: JianShuURL)!)
        }
        
        //打开微博*****************
        else if indexPath.row == 2 {
            UIApplication.sharedApplication().openURL(NSURL(string: SinaWeiBoURL)!)
        }
        
        //打开GitHub*****************
        else if indexPath.row == 3 {
            UIApplication.sharedApplication().openURL(NSURL(string: GitHubURL)!)
        }
        
        //关于Boo*******************
        else if indexPath.row == 4 {
            buildAboutMeView()
        }
    }
    
    
    //MARK: 弹出关于Boo
    func buildAboutMeView() {
        aboutView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT))
        aboutView.backgroundColor = UIColor(hexString: "000000", alpha: 0.6)
        //给view添加tap手势
        let tapGesture = UITapGestureRecognizer(target: self, action: "closeAboutView")
        aboutView.addGestureRecognizer(tapGesture)
        view.addSubview(aboutView)
        
    
        let tipsLabel = CMLabel(frame: CGRectMake(20, 200, SCREEN_WIDTH - 40, 100), title: MyIntroduce, font: UIFont(name: LightFont, size: 20.0)!, textColor: UIColor.whiteColor(), lineSpacing: 4.0, textEdgeInsets: UIEdgeInsetsZero)
        aboutView.addSubview(tipsLabel)
        
    }
    
    //关闭 关于Boo 界面
    func closeAboutView() {
        
        self.aboutView.removeFromSuperview()
    }
}
