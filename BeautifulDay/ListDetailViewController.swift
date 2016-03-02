//
//  ListDetailViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/19.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit



enum TableViewMode{
    /// 半糖精选
    case BanTangGoodSelectMode
    /// 用户推荐
    case UserRecommendMode
}


class ListDetailViewController: UIViewController,
    SegmentViewDelegate,
    ListDetailClickToProductDelegate,
    MoveToMyFavoriteViewDelegate,
    ListRecommendCellDelegate{

    /// list ID
    var listID = String()
    /// 动画 Image
    private var image = UIImage()
    /// listModel
    private var listModel:ListModel?
    /// 用户推荐model
    private var recommendArr:[UserRecommendModel]?
    /// 自定义导航栏
    private var customBar = UIView()
    /// 收藏按钮
    private var favoriteBtn = UIButton()
    /// 分享按钮
    private var shareBtn = UIButton()
    /// 控制 导航栏背景View
    private var navBackView = UIView()
    /// tableviewHeadView  由 headView +segmentView合成
    private var tableHeadView = UIView()
    /// 文字 图片 headView
    private var headView = ListDetailHeadView()
    /// 半糖精选 用户推荐 segmentView
    private var segmentView = SegmentView()
    /// 半糖精选 tableview
    private var banTangView = UITableView()
    /// 用户推荐 tableview
    private var userRecommendView = UITableView()
    
    private var tableViewMode = TableViewMode.BanTangGoodSelectMode //默认为 半糖精选
    
    init(listId:String,transImage:UIImage)
    {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        listID = listId
        image = transImage
    }
    
    init(listId:String)
    {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        listID = listId
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        //创建导航栏
        createCustomBar()
        
        //获取model数据
        loadData()
        
        
        if(listModel != nil)
        {
            buildHeadView()
            
            buildSegmentView()
            
            buildTableView()
        }else{
            TipView.showMessage("这个页面没有抓包😄")
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //检查用户是否已经收藏该清单
            //本地化存储 可以查询到 是否用户已经收藏该清单
        let isLikes = NSUserDefaults.standardUserDefaults().objectForKey(listID) as? Bool
        if(isLikes == nil)
        {
            favoriteBtn.selected = false
        }else if(isLikes == true)
        {
            favoriteBtn.selected = true
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func loadData()
    {
        listModel = ListModel.createListModel(listID)
        SVProgressHUD.show()
        if(listModel == nil)
        {
            print("nil-nil-nil")
        }else
        {
            print("listModel.title = \(listModel!.title!)")
            //加载 用户推荐数据
            recommendArr = UserRecommendModel.createUserRecommendModel(listID)
        }
    }
//MARK:创建模拟导航栏View
    
    func createCustomBar()
    {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        customBar = UIView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 64))
        customBar.backgroundColor = UIColor.clearColor()
        
        navBackView = UIView.init(frame: customBar.frame)
        navBackView.backgroundColor = UIColor.init(hexString: "EC5252", alpha: 0.0)
        view.addSubview(navBackView)
        
        view.addSubview(customBar)
        
        //标题
        let titleLabel = UILabel.init(frame: CGRectMake(SCREEN_WIDTH/2-36, 33, 18*4, 20))
        titleLabel.text = "购物清单"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(18.0)
        customBar.addSubview(titleLabel)
        
        ///收藏 按钮
        favoriteBtn = UIButton.init(frame: CGRectMake(476/2, 30, 20, 20))
        favoriteBtn.setImage(UIImage(named: "goodsDetail_fav_un"), forState: .Normal)
        favoriteBtn.setImage(UIImage(named: "goodsDetail_fav"), forState: .Selected)
        favoriteBtn.addTarget(self, action: "favoriteThisProduct", forControlEvents: .TouchUpInside)
        customBar.addSubview(favoriteBtn)
        
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
    //收藏
    func favoriteThisProduct()
    {
        favoriteBtn.selected = !favoriteBtn.selected
        
        
        
        if(favoriteBtn.selected)
        {
            TipView.showMessage("谢谢您的收藏😘")
            //本地化存储
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: listID)
        }else
        {
           TipView.showMessage("😭曾经有一份真挚的爱情摆在你的面前...")
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: listID)
        }
    }
    //分享
    func share()
    {
        let shareURl = listModel?.share_url
        let imgView = UIImageView()
        imgView.sd_setImageWithURL(NSURL(string:(listModel?.share_imageUrl)! ))
        let shareImage = imgView.image
        
        
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: nil, shareText: "贾宸穆 umsocialShare test \(shareURl!)", shareImage: shareImage, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline], delegate: nil)
        
    
    }


    
//MARK:创建headView ,categoey
    func buildHeadView()
    {
        headView = ListDetailHeadView.init(title: listModel!.title!, subTitle: listModel!.detailText!, image: image)
        self.view.addSubview(headView)
        
        view.bringSubviewToFront(navBackView)
        view.bringSubviewToFront(customBar)
    }
    
    func buildSegmentView(){
        segmentView = SegmentView.init(frame: CGRectMake(0, headView.frame.size.height, SCREEN_WIDTH, 45), firstTitle: "半糖精选", secondTitle: "用户推荐")
        segmentView.delegate = self
        view.addSubview(segmentView)
    }
    //MARK:--SegmentViewDelegate
    func clickSegmentView(clickIndex: Int) {
        if(tableViewMode == .BanTangGoodSelectMode)
        {
            tableViewMode = .UserRecommendMode
        }else
        {
            tableViewMode = .BanTangGoodSelectMode
        }
        banTangView.reloadData()
    }
    
    
//MARK:创建tableview
    func buildTableView()
    {
        banTangView = UITableView.init(frame: CGRectMake(0,CGRectGetMaxY(segmentView.frame), SCREEN_WIDTH, SCREEN_HEIGHT), style: .Plain)
        banTangView.contentInset = UIEdgeInsetsMake(0, 0, 64+44, 0)
        banTangView.delegate = self
        banTangView.dataSource = self
        view.addSubview(banTangView)
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource
extension ListDetailViewController:UITableViewDelegate,UITableViewDataSource
{
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableViewMode == .BanTangGoodSelectMode)
        {
            //半糖精选 模式
            if(listModel?.productArray != nil)
            {
                return (listModel?.productArray?.count)!
            }
            return 1
        }else{
            //用户推荐模式
            if(recommendArr != nil)
            {
                return (recommendArr?.count)!
            }
          
            return 1
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(tableViewMode == .BanTangGoodSelectMode)
        {
            let productModel = listModel?.productArray![indexPath.section]
            if(productModel?.cellHieght != nil)
            {
                return (productModel?.cellHieght)!
            }
            return 400
        }else
        {
            let userRecommendModel = recommendArr![indexPath.section]
            if(userRecommendModel.cellHieght != nil)
            {
                return userRecommendModel.cellHieght!
            }
            return 200
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0)
        {
            return 10
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellHeadView = UIView.init()
        cellHeadView.backgroundColor = UIColor.init(hexString: "F5F5F5")
        return cellHeadView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(tableViewMode == .BanTangGoodSelectMode)
        {
            let productModel = listModel?.productArray![indexPath.section]
            
            let cell = ListDetailCell.cell(tableView, model: productModel!,indexPath:indexPath)
            cell.delegate = self
            
            return cell
        }else{
            let userRecommendModel = recommendArr![indexPath.section]
            let cell = ListRecommendCell.listRecommendCell(banTangView, model: userRecommendModel,indexPath:indexPath)
            cell.delegate = self
            return cell
        }
    }
    //MARK:--cell delegate
    func clickCenter(clickType: ListDetailCellClickType, indexPath: NSIndexPath) {
        switch clickType
        {
            case .AllowComment_type:

                print("_允许评论_")
                let commentVC = CommentViewController.init(leftTitle: "取消", rightTitle:"发表")
                let nav = BaseNavigationController.init(rootViewController: commentVC)
                navigationController?.presentViewController(nav, animated: true, completion: nil)
                
                break
            
            case .NotAllowComment_type:
                print("_不允许评论_")
                break
            case .LikeIt_type:
                print("_收藏耶_")
            
                break
            case .MoveToOtherFavoriteList_type:
                print("移动到其他的收藏目录中哦~")
                
                let productModel = listModel?.productArray![indexPath.section]
                
                let moveToMyFavorite = MoveToMyFavoriteView.init(frame: CGRectMake(SCREEN_WIDTH/2-514/4, SCREEN_HEIGHT, 514/2, 732/2))
                moveToMyFavorite.showWithAnimation((productModel?.productID!)!)
                moveToMyFavorite.delegate = self

                break
            case .BuyThisProduct_type:
                print("去购买了yeah!")
                let productModel = listModel?.productArray![indexPath.section]

                let productBuyVC = ProductBuyViewController.init()
                productBuyVC.productUrl = productModel?.productUrl
                
        
                let backButtonItem = UIBarButtonItem.init(title: "闪人", style: .Done, target: nil, action: nil)
                navigationItem.backBarButtonItem = backButtonItem
                
                navigationController?.pushViewController(productBuyVC, animated: true)
                break
            
        default:
            break
        }
    }
    func lookproductDetail(productID: Int) {
        print("查看商品详情")
    }
    
    func goToCreateMyFavoriteList() {
        //去 创建心愿单
        let createFavoriteVC = CreateFavoriteListViewController.init(leftTitle: "取消", rightTitle: "完成")
        let nav = BaseNavigationController.init(rootViewController: createFavoriteVC)
        
        navigationController!.presentViewController(nav, animated: true, completion: nil)
//        navigationController?.pushViewController(createFavoriteVC, animated: true)
        
    }
    
    //用户推荐 cell.delegate
    func userRecommednClickCenter(clickType:ListDetailCellClickType,indexPath:NSIndexPath){
        switch clickType
        {
        case .AllowComment_type:
            
            TipView.showMessage("去评论啦")
            let commentVC = CommentViewController.init(leftTitle: "取消", rightTitle:"发表")
            let nav = BaseNavigationController.init(rootViewController: commentVC)
            navigationController?.presentViewController(nav, animated: true, completion: nil)
            
            break
        case .LikeIt_type:
            print("_收藏耶_")
            let userRecommendModel = recommendArr![indexPath.section]
            userRecommendModel.productArray![0].isCollect = true
            NSUserDefaults.standardUserDefaults().setObject(true,forKey:"\(userRecommendModel.productArray![0].isCollect)")
            
            break
        case .BuyThisProduct_type:
            print("去购买了yeah!")
            let userRecommendModel = recommendArr![indexPath.section]
            
            let productBuyVC = ProductBuyViewController.init()
            productBuyVC.productUrl = userRecommendModel.productArray![0].url
            
            let backButtonItem = UIBarButtonItem.init(title: "闪人", style: .Done, target: nil, action: nil)
            navigationItem.backBarButtonItem = backButtonItem
            
            navigationController?.pushViewController(productBuyVC, animated: true)
            break
            
        default:
            break
        }

    
    
    
    }
    
}



//MARK: UIScrollViewDelegate
extension ListDetailViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {

        if(headView.frame.origin.y == -headView.frame.size.height+64)
        {
            navBackView.backgroundColor = CustomBarTintColor
        }
        
        
        //向上滑动
        if(scrollView.contentOffset.y > 0 && headView.frame.origin.y > -headView.frame.size.height + 64)
        {
            //设定navBackView 的颜色
            if( (scrollView.contentOffset.y) / 32 < 1.0)
            {
                navBackView.backgroundColor = UIColor.init(hexString: "EC5252", alpha: (scrollView.contentOffset.y) / 32 )
            }
            
            
            scrollView.center = CGPointMake(SCREEN_WIDTH/2, scrollView.center.y - scrollView.contentOffset.y)
            headView.center = CGPointMake(SCREEN_WIDTH/2, headView.center.y - scrollView.contentOffset.y)
            segmentView.frame = CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, SCREEN_WIDTH, 45)
            
            //防止tableview拖动太快导致 顶部进入导航栏范围
            if(headView.frame.origin.y < -headView.frame.size.height+64)
            {
                headView.frame = CGRectMake(0, -headView.frame.size.height+64, SCREEN_WIDTH, headView.frame.size.height)
                segmentView.frame = CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, SCREEN_WIDTH, 45)
                scrollView.frame = CGRectMake(0, CGRectGetMaxY(segmentView.frame), SCREEN_WIDTH, SCREEN_HEIGHT)
            }
        
        }else if(scrollView.contentOffset.y < 0 && headView.frame.origin.y <= 0)
        {
            if(-scrollView.contentOffset.y/32 < 1.0 )
            {
                navBackView.backgroundColor = UIColor.init(hexString: "EC5252", alpha: (scrollView.contentOffset.y) / 32 )
            }
            
        
            scrollView.center = CGPointMake(SCREEN_WIDTH/2, scrollView.center.y - scrollView.contentOffset.y)
            headView.center = CGPointMake(SCREEN_WIDTH/2, headView.center.y - scrollView.contentOffset.y)
            segmentView.frame = CGRectMake(0, headView.frame.origin.y+headView.frame.size.height, SCREEN_WIDTH, 45)
            
            //防止tableview拖动太快 导致上面显示空白
            if(headView.frame.origin.y > 0)
            {
                weak var weakSelf = self
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    weakSelf?.headView.frame = CGRectMake(0, 0,SCREEN_WIDTH, weakSelf!.headView.frame.size.height)
                    weakSelf!.segmentView.frame = CGRectMake(0, weakSelf!.headView.frame.origin.y+weakSelf!.headView.frame.size.height, SCREEN_WIDTH, 45)
                    scrollView.frame = CGRectMake(0, CGRectGetMaxY(weakSelf!.segmentView.frame), SCREEN_WIDTH, SCREEN_HEIGHT)
                    })
            }
        }
    }
}