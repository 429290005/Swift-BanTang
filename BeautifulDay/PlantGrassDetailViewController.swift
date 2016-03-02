//
//  PlantGrassDetailViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/22.
//  Copyright © 2016年 jiachen. All rights reserved.
//  ManoBoo
//  解释： 受制于时间关系 "最新发布"没有抓去数据   cell 中的一些按钮点击代理也木有实现   该ViewController 与清单详情类似

import UIKit

enum tableViewMode{
    /// 最受欢迎
    case MostFavoriteMode
    /// 最新发布
    case JustPublishMode
}

class PlantGrassDetailViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,SegmentViewDelegate{

    private var customBar = UIView()
    private var shareBtn = UIButton()
    
    private var imgView = UIImageView()
    private var tableHeaderView = UIView()
    private var showTableView = UITableView()
    // model
    private var plantGrassModel: PlantGrassModel?
    //浏览次数等 会用到
    var teamModel: PlantGrassTeamModel?

    //tableviewCell 中用到的 model
    var myPostModel: [UserRecommendModel]?
    
    var myTableViewMode : tableViewMode?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        loadData()
        
        changeModelToListDetailProduct()
        
        buildImgVIew()
        
        createCustomBar()
        
        buildTableHeaderView()
        
        buildTableView()
    }
    
    //MARK: loadData
    func loadData() {
        plantGrassModel = PlantGrassModel.createPlantGrassModel()
        
    }
    
    //MARK:创建模拟导航栏View
    
    func createCustomBar()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        customBar = UIView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 64))
        customBar.backgroundColor = UIColor.clearColor()
        
        view.addSubview(customBar)
        
        //分享按钮
        shareBtn = UIButton.init(frame: CGRectMake(SCREEN_WIDTH-39, 30, 20, 20))
        shareBtn.setImage(UIImage(named: "goodsDetail_share"), forState: .Normal)
        shareBtn.addTarget(self, action: "share", forControlEvents: .TouchUpInside)
        customBar.addSubview(shareBtn)
        
        ///pop 按钮
        let backButton = UIButton.init(frame: CGRectMake(17, 30, 20, 20))
        backButton.addTarget(self, action: "backToFrontVC", forControlEvents: .TouchUpInside)
        backButton.setImage(UIImage(named: "back"), forState: .Normal)
        customBar.addSubview(backButton)
    }
    
    //pop按钮方法
    func backToFrontVC()
    {
        navigationController?.popViewControllerAnimated(true)
    }

    
    //MARK: build ImgView
    func buildImgVIew() {
        imgView = UIImageView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 520/2))
        imgView.autoresizesSubviews = false
        imgView.contentMode = .Center
        imgView.clipsToBounds = true
        imgView.sd_setImageWithURL(NSURL(string: (plantGrassModel?.pic2)!), placeholderImage: nil)
        //高斯处理
        ImageOperationCenter.GaussianBlurWithCoreImage(imgView)
        view.addSubview(imgView)
        
        let nameLabel = UILabel()
        nameLabel.layer.cornerRadius = 3.0
        nameLabel.layer.borderColor = UIColor.whiteColor().CGColor
        nameLabel.layer.borderWidth = 0.5
        nameLabel.text = (plantGrassModel?.teamName)!
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: LightFont, size: 15.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(SCREEN_WIDTH/2 - nameLabel.frame.width/2 - 35, 148/2, nameLabel.frame.width + 70, 15+20)
        imgView.addSubview(nameLabel)
        
        let contentLabel = CMLabel(frame: CGRectMake(20, CGRectGetMaxY(nameLabel.frame) + 20, SCREEN_WIDTH - 40, 20), title: (plantGrassModel?.teamDetail)!, font: UIFont(name: LightFont, size: 14.0)!, textColor: UIColor.whiteColor(), lineSpacing: 3, textEdgeInsets: UIEdgeInsetsZero)
        contentLabel.titleLabel.textAlignment = .Center
        imgView.addSubview(contentLabel)
        
        let attentionBtn = UIButton.init(frame: CGRectMake(SCREEN_WIDTH/2 - 244/4, CGRectGetMaxY(contentLabel.frame) + 19, 244/2, 30))
        attentionBtn.titleLabel?.textAlignment = .Center
        attentionBtn.setTitle("﹢ 关注", forState: .Normal)
        attentionBtn.titleLabel?.font = UIFont(name: LightFont, size: 15.0)
        attentionBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        attentionBtn.layer.cornerRadius = 15.0
        attentionBtn.backgroundColor = UIColor(hexString: "FF9C00")
        imgView.addSubview(attentionBtn)
        
        let countLabel = UILabel()
        countLabel.textAlignment = .Center
        if teamModel != nil {
            countLabel.text = "\((teamModel?.lookCount)!)浏览 \((teamModel?.postsCount)!)帖子"
        }
        countLabel.textColor = UIColor.whiteColor()
        countLabel.font = UIFont(name: LightFont, size: 12.0)
        countLabel.sizeToFit()
        countLabel.frame = CGRectMake(SCREEN_WIDTH/2 - countLabel.frame.width/2, CGRectGetMaxY(attentionBtn.frame) + 20, countLabel.frame.width, 12)
        imgView.addSubview(countLabel)
    }
    //MARK: build tableHeaderView
    
    func buildTableHeaderView() {
        tableHeaderView = UIView.init(frame: CGRectMake(0, 520/2, SCREEN_WIDTH, 264/2))
        tableHeaderView.backgroundColor = UIColor(hexString: "F4F4F4")
        
        //关注者显示
        let attentionView = UIView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 152/2))
        attentionView.backgroundColor = UIColor.whiteColor()
        tableHeaderView.addSubview(attentionView)
        print( "\( (plantGrassModel?.attentionUsers?.count)! )人关注" )
        
        let attentParaLabel = UILabel()
        let str = "队长     \( (teamModel?.likeCount)! )人关注"
        let tempStr = "\( (teamModel?.likeCount)! )人关注"
        let attributeStr = NSMutableAttributedString(string: str)
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: CustomBarTintColor, range: NSMakeRange(0, 2))
        attributeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "B6B6B6"), range: NSMakeRange(7, tempStr.characters.count))
        //添加 字体
        attributeStr.addAttribute(NSFontAttributeName, value: UIFont(name: LightFont, size: 12.0)!, range: NSMakeRange(0, str.characters.count))
        attentParaLabel.attributedText = attributeStr
        attentParaLabel.sizeToFit()
        attentParaLabel.frame = CGRectMake(10, 16, attentParaLabel.frame.width, attentParaLabel.frame.height)
        attentionView.addSubview(attentParaLabel)
        
        //关注者的头像
        let attentionScrollView = UIScrollView.init(frame: CGRectMake(10, 40, SCREEN_WIDTH-10, 60))
        attentionScrollView.contentSize = CGSizeMake(CGFloat(1 + (plantGrassModel?.attentionUsers?.count)!) * 46, 30)
        //队长
        let teamLeaderImgView = UIImageView.init(frame: CGRectMake(0, 0, 30, 30))
        teamLeaderImgView.layer.cornerRadius = 15.0
        teamLeaderImgView.sd_setImageWithURL(NSURL(string: (plantGrassModel?.author?.headerImageUrl)!), placeholderImage: UIImage(named: "HeaderPlaceHolder"))
        attentionScrollView.addSubview(teamLeaderImgView)
        //小弟
        for var i = 0 ; i < plantGrassModel?.attentionUsers?.count ; i++ {
            let iconView = UIImageView.init(frame: CGRectMake(46 * CGFloat(i+1), 0, 30, 30))
            iconView.layer.cornerRadius = 15.0
            iconView.sd_setImageWithURL(NSURL( string: (plantGrassModel?.attentionUsers![i].headerImageUrl)! ), placeholderImage: UIImage(named: "HeaderPlaceHolder"))
            attentionScrollView.addSubview(iconView)
        }
        
        attentionView.addSubview(attentionScrollView)
        
        //SegmentView
        let segmentView = SegmentView(frame: CGRectMake(0,264/2 - 45, SCREEN_WIDTH, 45), firstTitle: "最受欢迎", secondTitle: "最新发布")
        segmentView.delegate = self
        tableHeaderView.addSubview(segmentView)
        
    }
    //segmentView 点击事件处理
    func clickSegmentView(clickIndex: Int) {
        if clickIndex == 2 {
            TipView.showMessage("最近发布木有抓取数据☆😅")
            
        }
    }
    
    //MARK: build TableView
    func buildTableView() {
        showTableView = UITableView.init(frame: CGRectMake(0, 520/2, SCREEN_WIDTH, SCREEN_HEIGHT - 520/2))
        myTableViewMode = tableViewMode.MostFavoriteMode
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.tableHeaderView = tableHeaderView
        view.addSubview(showTableView)
        TipView.showMessage("功能与清单详情类似，请参考")
    }
    //  UITableViewDelagate,DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if plantGrassModel != nil && plantGrassModel?.postList?.count > 0 {
            return (plantGrassModel?.postList?.count)!
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if myTableViewMode == tableViewMode.MostFavoriteMode {
            let model = myPostModel![indexPath.row]
            if model.cellHieght != nil {
                return model.cellHieght!
            }
            return 200
        }else if myTableViewMode == tableViewMode.JustPublishMode {
            return 200
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ListRecommendCell.listRecommendCell(tableView, model: myPostModel![indexPath.row], indexPath: indexPath)
        return cell
    }
    
    //该 tableview 与清单详情中的 cell 相似 所以 将 该 model 转换为ListRecommendCell 所需的模型  -> UserRecommendModel
    func changeModelToListDetailProduct() {
        myPostModel = [UserRecommendModel]()
        for var i = 0 ; i < plantGrassModel?.postList?.count ; i++ {
            let post = UserRecommendModel()
            let post_begin = plantGrassModel!.postList![i]
            post.userRecommendID = post_begin.id
            post.title = post_begin.title
            post.content = post_begin.content
            post.createTime = "01-18 14:13"
            post.author_id = post_begin.author_id
            post.dynamic = UserRecommendDynamic()
                post.dynamic?.commentCount = post_begin.commentCount
                post.dynamic?.lookHistoryCount = post_begin.lookCount
                post.dynamic?.likesCount = post_begin.likesCount
                post.dynamic?.is_collect = post_begin.is_collection
                post.dynamic?.is_comment = post_begin.is_comment
            post.tagArray = post_begin.tagsArray
            post.picArray = post_begin.picArray
            post.productArray = post_begin.productArray
            post.author = post_begin.author
            post.share_url = post_begin.shareUrl
            
            myPostModel?.append(post)
        }
    }
    
    //MARK: 动画效果 UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == showTableView {
            
            if showTableView.contentOffset.y < 0  && showTableView.contentOffset.y > -30{
                let scale = 1 - showTableView.contentOffset.y / imgView.frame.height
                print(scale)
                imgView.transform = CGAffineTransformMakeScale(scale, scale)
                imgView.layer.zPosition = 2.0
                customBar.layer.zPosition = 3.0
            }
            
        }
    }
    
}
