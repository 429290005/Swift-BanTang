//
//  MoveToMyFavoriteView.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/25.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

protocol MoveToMyFavoriteViewDelegate:NSObjectProtocol{
    func goToCreateMyFavoriteList()
}

class MoveToMyFavoriteView: UIView,UITableViewDelegate,UITableViewDataSource {

    private var showtableView = UITableView()
    private var backGroundView = UIView()
    private var productID:String?
    var delegate:MoveToMyFavoriteViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        backgroundColor = UIColor.blackColor()
        addBackGroundView()
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBackGroundView()
    {
        backGroundView = UIView.init(frame: CGRectMake(-(SCREEN_WIDTH/2 - self.frame.size.width/2), -(SCREEN_HEIGHT/2 - self.frame.size.height/2), SCREEN_WIDTH, SCREEN_HEIGHT))
        backGroundView.backgroundColor = UIColor(hexString: "000000", alpha: 0.8)
        
        
        self.clipsToBounds = false
        self.addSubview(backGroundView)
    }

    func buildUI()
    {
        showtableView = UITableView.init(frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        showtableView.layer.cornerRadius = 5.0
        showtableView.delegate = self
        showtableView.dataSource = self
        addSubview(showtableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 1
        }else if(section == 1){
            return MyFavoriteList.count + RecommendList.count
        }else
        {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            return 96/2
        }else if(indexPath.section == 1)
        {
            return 55
        }else
        {
            if(indexPath.row == 0)
            {
                return 114/2
            }else
            {
                return 38
            }
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1)
        {
            return 3
        }else
        {
            return 0
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1)
        {
            let backView = UIView.init(frame: CGRectZero)
            backView.backgroundColor = CustomBarTintColor
            return backView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if(cell == nil)
        {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: nil)
            cell?.selectionStyle = .None
        }
        
        
        let mainLabel = UILabel.init()
        mainLabel.font = UIFont.systemFontOfSize(15.0)
        mainLabel.textColor = UIColor(hexString: "565656")
        mainLabel.textAlignment = .Center
        
        if(indexPath.section == 0)
        {
            mainLabel.text = "移动至心愿单"
            let closeBtn = UIButton.init(frame: CGRectMake(self.frame.size.width-10-40, 96/4-20, 40, 40))
            closeBtn.setImage(UIImage(named: "btn_image_close"), forState: .Normal)
            closeBtn.setImage(UIImage(named: "btn_image_close_highlighted"), forState: .Normal)
            closeBtn.addTarget(self, action: "closeMyView", forControlEvents: .TouchUpInside)
            cell?.contentView.addSubview(closeBtn)
            mainLabel.sizeToFit()
            mainLabel.frame = CGRectMake(55, 22, mainLabel.frame.size.width, mainLabel.frame.size.height)
            cell?.contentView.addSubview(mainLabel)
            
        }
    
        //我的清单
        if(indexPath.section == 1)
        {
            if(indexPath.row < MyFavoriteList.count)
            {
                mainLabel.text = MyFavoriteList[indexPath.row]
            }else if(indexPath.row >= MyFavoriteList.count)
            {
                //推荐列表
                mainLabel.text = RecommendList[indexPath.row - MyFavoriteList.count ]
                //添加 『创建』标识
                
                let tipLabel = UILabel.init(frame: CGRectMake(self.frame.size.width - 24 - 4, 22, 24, 12.0))
                tipLabel.font = UIFont.systemFontOfSize(12.0)
                tipLabel.text = "创建"
                tipLabel.textColor = SubTitleColor
                tipLabel.textAlignment = .Center
                
                cell?.contentView.addSubview(tipLabel)
            }
            mainLabel.sizeToFit()
            mainLabel.frame = CGRectMake(55, 22, mainLabel.frame.size.width, mainLabel.frame.size.height)
            cell?.contentView.addSubview(mainLabel)
        }else if(indexPath.section == 2)
        {
            if(indexPath.row == 0)
            {
                mainLabel.text = "+ 创建心愿单"
                mainLabel.textColor = UIColor.whiteColor()
                mainLabel.font = UIFont.systemFontOfSize(15.0)
                mainLabel.sizeToFit()
                mainLabel.frame = CGRectMake(self.frame.size.width/2 - mainLabel.frame.size.width/2, 16, mainLabel.frame.size.width+25, mainLabel.frame.size.height+10)
                mainLabel.backgroundColor = CustomBarTintColor
                mainLabel.layer.cornerRadius = 3.0
                cell?.contentView.addSubview(mainLabel)
            }else
            {
                mainLabel.text = "取消喜欢"
                mainLabel.font = UIFont.systemFontOfSize(15.0)
                mainLabel.textColor = UIColor(hexString: "9D9D9D")
                mainLabel.sizeToFit()
                mainLabel.frame = CGRectMake(self.frame.size.width/2 - mainLabel.frame.size.width/2, cell!.frame.size.height/2 - mainLabel.frame.size.height/2,mainLabel.frame.size.width , mainLabel.frame.size.height)
                cell?.contentView.backgroundColor = UIColor(hexString: "F0F0F0")
                cell?.contentView.addSubview(mainLabel)
            }
        }
        

        return cell!
    }
    //MARK: didSeslect
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //点击 创建的cell
        if(indexPath.section == 1 && indexPath.row >= MyFavoriteList.count)
        {
            MyFavoriteList.append(RecommendList[indexPath.row - MyFavoriteList.count])
            RecommendList.removeAtIndex(indexPath.row - MyFavoriteList.count+1)
            showtableView.reloadData()
        }else if(indexPath.section == 2 && indexPath.row == 0)
        {
            //点击"创建心愿单"
            delegate?.goToCreateMyFavoriteList()
            self.closeMyView()
            
        }else if(indexPath.section == 2 && indexPath.row == 1)
        {
            //取消喜欢
            if(productID != nil)
            {
                NSUserDefaults.standardUserDefaults().setObject(false, forKey:productID!)
                closeMyView()
            }
            
        }
    }
    
    
    
    func closeMyView()
    {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.frame = CGRectMake(self.frame.origin.x, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height)
                self.backGroundView.alpha = 0.0
            }) { (finished:Bool) -> Void in
                if(finished)
                {
                    self.removeFromSuperview()
                }
        }
    }
    
    
    func showWithAnimation(productID:String)
    {
        
        self.productID = productID

        let keyWindow = UIApplication.sharedApplication().keyWindow
        keyWindow!.addSubview(self)
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        }
    }

}
