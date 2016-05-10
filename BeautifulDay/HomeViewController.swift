//
//  ViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/13.
//  Copyright © 2016年 jiachen. All rights reserved.
//首页

import UIKit


class HomeViewController: UIViewController,TitleViewDelegate,BannerViewDelegate {
    /// 顶部自定义导航条
    var customBar = UIView()
    
    ///顶部轮播视图
    var bannerView = BannerView()
    /// 标签
    var titleView = TitleView()
    /// 轮播视图 ，标签视图 的容器
    var headView = UIView()
    ///tableview 容器
    var showScrollView:UIScrollView!
    /// tableview容器
    var showCollectionView:UICollectionView!
    
    ///当前显示的tableview 左侧内容
    var leftTableView:UITableView!
    ///当前显示的tableview
    var currentTableView:UITableView!
    ///当前显示的tableview 右侧内容
    var rightTableView:UITableView!
    
    var dataStr = ProductRecommend()
    var productArr:NSMutableArray?
    
    var currentIndex = Int()  //当前显示的页面
    var tmpCount = Int()
    var currentContentOffSetX = CGFloat() // 当前的contentOffset.X
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tmpCount = currentIndex
        
        self.loadData()

        self.createCustomNavigationBar()
        
        self.createBannerView()
        
        self.createNavTitleView()
        
        self.createCollectionView()
        
        self.add3DTouch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:创建 ，模拟导航条
    func createCustomNavigationBar()
    {
        customBar = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 64))
        customBar.alpha = 0.0
        customBar.layer.zPosition = 2.0
        customBar.backgroundColor = UIColor(hexString: "EC5252")
        self.view.addSubview(customBar)
        
        //搜索按钮  点击 页面滑动至 搜索
        let searchBtn = UIButton.init(frame: CGRectMake(16, 35, 20, 20))
        searchBtn.setImage(UIImage(named: "searchBtn"), forState:.Normal)
        searchBtn.addTarget(self, action: "scrollToSearchButton", forControlEvents: .TouchUpInside)
        customBar.addSubview(searchBtn)
        
        //签到按钮
        let signInBtn = UIButton.init(frame: CGRectMake(SCREEN_WIDTH-18-30, 40, 30, 12))
        signInBtn.setTitle("签到", forState: .Normal)
        signInBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        signInBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInBtn.addTarget(self, action: "toSignInViewController", forControlEvents: .TouchUpInside)
        customBar.addSubview(signInBtn)
        
        let nameLabel = UILabel.init(frame: CGRectMake(SCREEN_WIDTH/2 - 20, 30, 40, 20))
        nameLabel.text = "半糖"
        nameLabel.font = UIFont.systemFontOfSize(20.0)
        nameLabel.textColor = UIColor.whiteColor()
        customBar.addSubview(nameLabel)
        
    }
    
    ///签到 ViewController
    func toSignInViewController()
    {
        print("toSignInViewController")
        let signInVC = SignInViewController.init(leftTitle: "", rightTitle: "")
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    //页面滚动到 搜索处
    func scrollToSearchButton()
    {
        
    }
    
    
    
    //MARK:create titleView
    func createNavTitleView()
    {
        //创建标题数组
        let titleArr = NSArray.init(objects: "最新","文艺","礼物","指南","爱美","设计","吃货","厨房","上班","学生","聚会","节日","宿舍")
        titleView = TitleView.init(titleArr: titleArr, normalColor: SubTitleColor, highlightColor: UIColor.redColor(),fontSize:16.0)
        titleView.clickDelegate = self
        titleView.frame = CGRectMake(0, 514/2, SCREEN_WIDTH, 36.0)
        headView.addSubview(titleView)
    }
    //顶部 分类 点击
    func TitleViewClick(titleVIew: TitleView, clickBtnIndex: Int) {
        print("delegate-> ：\(clickBtnIndex)")
        
        weak var weakSelf = self
        UIView.animateWithDuration(0.3) { () -> Void in
            weakSelf!.showCollectionView!.contentOffset = CGPointMake(CGFloat(clickBtnIndex)*SCREEN_WIDTH, 0)
        }
        
    }

    
    
    //MARK:创建顶部轮播视图
    func createBannerView()
    {
        headView = UIView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 293))
        headView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(headView)
        
        bannerView = BannerView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 514/2))
        bannerView.delegate = self
        headView.addSubview(bannerView)
    }
    //按钮点击代理
    func bannerVierFourButtonClicked(clickType: ClickType) {
        switch clickType{
        
        case ClickType.GoodSomeThingClickType:
            //好物
            print("好物")
            let goodThingVC = GoodThingViewController()
            self.navigationController?.pushViewController(goodThingVC, animated: true)
            break
        case ClickType.SearchClickType:
            //搜索
            print("搜索")
            let searchVC = SearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
            break
        case ClickType.PlantGrassClickType:
            //种草
            print("种草")
            let plantGrassVC = PlantGrassViewController(leftTitle: "", rightTitle: "")
            self.navigationController?.pushViewController(plantGrassVC, animated: true)
            break
        case ClickType.SignInClickType:
            //签到
            print("签到")
            let signInVC = SignInViewController.init(leftTitle: "", rightTitle: "")
            self.navigationController?.pushViewController(signInVC, animated: true)
            break
        }
    }
    
    
    //MARK:创建CollectionVIew
    func createCollectionView()
    {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        showCollectionView = UICollectionView.init(frame: CGRectMake(0, 586/2, SCREEN_WIDTH, SCREEN_HEIGHT), collectionViewLayout: layout)
        showCollectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIDentifier")
        showCollectionView?.contentSize = CGSizeMake(13*SCREEN_WIDTH, 0)
        showCollectionView.bounces = false
        showCollectionView.pagingEnabled = true
        showCollectionView.backgroundColor = UIColor.whiteColor()
        showCollectionView?.delegate = self
        showCollectionView?.dataSource = self
        self.view.addSubview(showCollectionView!)

    }
    
    
    //加载 分类"最新" 数据
    func loadData()
    {
        //默认显示0行
        self.productArr = dataStr.createProductRecommendModel(0)
        print("product.count = \(self.productArr!.count)")
    }
}



//MARK:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == showCollectionView)
        {
            
            
            //当前显示页面 全部加载到scrollview里面
            if(showCollectionView!.contentOffset.x % SCREEN_WIDTH == 0)
            {
                currentIndex = Int(showCollectionView!.contentOffset.x / SCREEN_WIDTH)
                print("result is \(currentIndex)")
                
                titleView.setBottomView(currentIndex)
                tmpCount = currentIndex
                
            }
           
            currentContentOffSetX = showCollectionView!.contentOffset.x
        }else
        {
            if(headView.frame.origin.y == -257+64)
            {
                customBar.alpha = 1.0
            }else if(headView.frame.origin.y == 0)
            {
                customBar.alpha = 0.0
            }
            //拖动当前currentTableView,先向上移动frame 257的距离 ，同时改变导航栏颜色

            if(headView.frame.origin.y > -257+64 && scrollView.contentOffset.y > 0)
            {
                if(scrollView.contentOffset.y / 43.0 < 1.0)
                {
                    customBar.alpha = scrollView.contentOffset.y / 43.0
                    
                }
                
                showCollectionView.frame = CGRectMake(0, showCollectionView.frame.origin.y - scrollView.contentOffset.y, SCREEN_WIDTH, SCREEN_HEIGHT)
                headView.center = CGPointMake(SCREEN_WIDTH/2, headView.center.y-scrollView.contentOffset.y)
                if(headView.frame.origin.y < -257+64)
                {
                    headView.frame = CGRectMake(0, -257+64, SCREEN_WIDTH, 293)
                    showCollectionView!.frame = CGRectMake(0, 64+36, SCREEN_WIDTH, SCREEN_HEIGHT)
                }
                
            }else if(headView.frame.origin.y <= 0 && showCollectionView.frame.origin.y <= 293 && scrollView.contentOffset.y < 0)
            {
             
                if(-scrollView.contentOffset.y / 43.0 < 1.0 && headView.frame.origin.y < 0)
                {
                    customBar.alpha = -scrollView.contentOffset.y / 43.0
                   
                }

                showCollectionView.center = CGPointMake(showCollectionView.center.x, showCollectionView.center.y-scrollView.contentOffset.y)
                headView.center = CGPointMake(SCREEN_WIDTH/2, headView.center.y -  scrollView.contentOffset.y)
                if(headView.frame.origin.y > 0 || showCollectionView.frame.origin.y > 293)
                {
                    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 293)
                    showCollectionView.frame = CGRectMake(0, 293, SCREEN_WIDTH, SCREEN_HEIGHT)
                    self.navigationController?.navigationBar.alpha = 0.0
                }
            }
            
            
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //开始滚动 current的时候 将CustomBar 放置到图层最上层 按钮才会响应，不然会被其他按钮覆盖
        self.view.bringSubviewToFront(customBar)
    }
   



//MARK:UITableViewDelegate,UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArr?.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 171+63
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.productArr = dataStr.createProductRecommendModel(currentIndex)
        
        let cell = HomeCell.cell(tableView, model: (self.productArr![indexPath.row]) as? ProductRecommendModel)
        return cell
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? HomeCell
        print("selected cell listID = \(cell!.listID)")
        
        let listDetailVC = ListDetailViewController(listId: cell!.listID,transImage: (cell?.imgView.image!)!)
        navigationController?.pushViewController(listDetailVC, animated: true)
    }
    
    
}

//MARK:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 13
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellID = "cellIDentifier"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        //将tableview 添加到cell中来
        
        for aview in cell.contentView.subviews
        {
            if aview.isKindOfClass(UITableView.self) {
                aview.removeFromSuperview()
            }
        }
        let tableView = UITableView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT), style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 64+84, 0)
        currentIndex = indexPath.section
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        cell.contentView.addSubview(tableView)
        
        return cell
        
     
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }


    
    func refreshData(tableview:UITableView)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            tableview.showsPullToRefresh = false
        })
    }
    
    //MARK: 添加 3D touch功能
    func add3DTouch() {
        //1.检测 3D touch 是否可用
        if traitCollection.forceTouchCapability == .Available {
            //可用
            registerForPreviewingWithDelegate(self, sourceView: view)
        }else {
            //不可用
            TipView.showMessage("不支持3Dtouch,换个6S吧,不谢😂")
            let alertController = UIAlertController(title: "手指不支持3D touch耶，换一台吧", message: "链接都给你备好了，想去看看吧", preferredStyle: UIAlertControllerStyle.Alert)
            let action_confirm = UIAlertAction(title: "我是土豪我任性", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "http://mall.jd.com/index-1000004067.html")!)
            })
            let action_cancel = UIAlertAction(title: "没钱，先攒着~", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addAction(action_confirm)
            alertController.addAction(action_cancel)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
   
}
