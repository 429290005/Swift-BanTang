//
//  MessageCenterViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/18.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class MessageCenterViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    private let tableViewData = ["新的粉丝","新的评论","新的喜欢","新的奖励","新的通知"]
    private let iconData = [UIImage(named: "Square_selected"),UIImage(named: "Square_selected"),UIImage(named: "Square_selected"),UIImage(named: "Square_selected"),UIImage(named: "Square_selected"),]
    
    
    private var showTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "消息"
        
        //接受 模拟后台的推送、、、、
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hasNewMessage", name: UserHasNewMessage, object: nil)
        
        buildTableView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarItem.title = nil
       
       
    }
    
    //MARK: build tableview
    func buildTableView() {
        showTableView = UITableView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49), style: .Plain)
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.separatorStyle = .None
        view.addSubview(showTableView)
    }
    
    //tableview delegate datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 就这个四个 cell  用不着重用了
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.selectionStyle = .None
  
        //文字 label
        let textLabel = UILabel.init(frame: CGRectMake(50, 20, 4*15.0, 15.0))
        textLabel.text = tableViewData[indexPath.row]
        textLabel.font = UIFont(name: LightFont, size: 15.0)
        textLabel.textColor = MainTitleColor
        cell.contentView.addSubview(textLabel)
        
        //左侧图标
        let iconView = UIImageView(frame: CGRectMake(14, 17, 20, 20))
        iconView.image = iconData[indexPath.row]
        cell.contentView.addSubview(iconView)

        // 添加分割线
        let separator = UIView.init(frame: CGRectMake(0, cell.frame.height - 0.5, SCREEN_WIDTH, 0.5))
        separator.backgroundColor = CellSeparatotBackColor
        cell.contentView.addSubview(separator)
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: 接受 通知中心的通知
    func hasNewMessage(){
        print("收到通知了。")
        TipView.showMessage("您有新的消息。但是你看不见😜")
        

    }
}
