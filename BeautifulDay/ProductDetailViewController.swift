//
//  ProductDetailViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/2.
//  Copyright © 2016年 jiachen. All rights reserved.
//  从搜索结果跳向商品详情页面

import UIKit

class ProductDetailViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{

    /// 自定义导航栏
    private var customBar = UIView()
    /// 收藏按钮
    private var favoriteBtn = UIButton()
    /// 分享按钮
    private var shareBtn = UIButton()
    /// 控制 导航栏背景View
    private var navBackView = UIView()
    
    private var productModel: ProductDetailModel?
    /// 图片展示
    private var showScrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private var showTableView = UITableView()
    
    //商品详情描述
    private var productNameLabel = UILabel()
    private var productDetailLabel = UILabel()
    
    //底部 view
    private var bottomView = UIView()
    private var commentBtn = UIButton()
    private var likeBtn = UIButton()
    private var buyBtn = UIButton()
    
    init(productID:String)
    {
        super.init(nibName: nil, bundle: nil)
        automaticallyAdjustsScrollViewInsets = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        loadData()
        
        buildImageScrollVIew()
        
        buildCustomBar()
        
        buildTableView()
        
        buildBottomBar()
    }
    
    //MARK:load data
    func loadData()
    {
        productModel = ProductDetailModel.createProductDetailModel()
    }
    
    
    //MARK: Build UI
    //MARK:导航栏
    func buildCustomBar(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        customBar = UIView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 64))
        customBar.backgroundColor = UIColor.clearColor()
        navBackView = UIView.init(frame: customBar.frame)
        navBackView.backgroundColor = UIColor.init(hexString: "EC5252", alpha: 0.0)
        view.addSubview(navBackView)
        
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
    //分享
    func share()
    {
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: nil, shareText: "贾宸穆 umsocialShare test", shareImage: nil, shareToSnsNames: [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline], delegate: nil)
    }
    
    //MARK:image scrollView
    func buildImageScrollVIew()
    {
        showScrollView = UIScrollView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH))
        showScrollView.bounces = false
        showScrollView.delegate = self
        showScrollView.contentSize = CGSizeMake(CGFloat((productModel?.picArray!.count)!) * SCREEN_WIDTH, 0)
        showScrollView.showsHorizontalScrollIndicator = false
        showScrollView.pagingEnabled = true
        
        for var i = 0 ; i < productModel?.picArray!.count ; i++ {
            let imgView = UIImageView.init(frame: CGRectMake(SCREEN_WIDTH * CGFloat(i), 0, SCREEN_WIDTH, SCREEN_WIDTH))
            
            imgView.sd_setImageWithURL(NSURL(string:(productModel?.picArray![i].imageUrl)!) , placeholderImage: UIImage(named: "placeHolder"))
            
            showScrollView.addSubview(imgView)
        
        }
        
        view.addSubview(showScrollView)
        
        
        //build pageControl

        pageControl.numberOfPages = (productModel?.picArray!.count)!
        let size = pageControl.sizeForNumberOfPages((productModel?.picArray!.count)!)
        pageControl.frame = CGRectMake(0, SCREEN_WIDTH - 14, size.width, 6)
        pageControl.layer.zPosition = 3.0
        pageControl.center = CGPointMake(SCREEN_WIDTH/2, pageControl.center.y)
        pageControl.pageIndicatorTintColor = UIColor(hexString: "E2D9D6")
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "FFFFFF")
        pageControl.currentPage = 0
        view.addSubview(pageControl)
    
    }
    
    //MARK: build product detail description 
    func buildProductDetailView() -> UIView
    {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        
        
        //商品名称
        productNameLabel = UILabel.init(frame: CGRectMake(0, 39/2-15/2, 65, 15))
        productNameLabel.textColor = MainTitleColor
        productNameLabel.font = UIFont(name: RegularFont, size: 15.0)
        productNameLabel.text = (productModel?.productName)!
        productNameLabel.sizeToFit()
        productNameLabel.center = CGPointMake(SCREEN_WIDTH/2, productNameLabel.center.y)
        tableHeaderView.addSubview(productNameLabel)
        
        //商品价格
        let priceLabel = UILabel(frame: CGRectMake(0, 45, SCREEN_WIDTH, 15))
        priceLabel.text = "软妹币:\( (productModel?.price)! )"
        priceLabel.font = UIFont(name: LightFont, size: 12.0)
        priceLabel.textColor = CustomBarTintColor
        priceLabel.textAlignment = .Center
        tableHeaderView.addSubview(priceLabel)
        
        //虚线
        tableHeaderView.addSubview(DrawLine.createLine(DrawType.DottedLine, lineRect: CGRectMake(7.5, 64.5, SCREEN_WIDTH - 7.5 , 0.5)))
        
        //商品详情描述
        let productDetailLabel = CMLabel(frame: CGRectMake(10, 65+15, SCREEN_WIDTH - 20, 50), title: (productModel?.detailText)!, font: UIFont(name: LightFont, size: 15.0)!, textColor: UIColor(hexString: "7C7C7C"), lineSpacing: 5.0, textEdgeInsets: UIEdgeInsetsZero)
        tableHeaderView.addSubview(productDetailLabel)
    
        //虚线
        tableHeaderView.addSubview(DrawLine.createLine(DrawType.DottedLine, lineRect: CGRectMake(7.5, CGRectGetMaxY(productDetailLabel.frame)+0.5, SCREEN_WIDTH - 7.5 , 0.5)))
        
        tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(productDetailLabel.frame) + 10)
        return tableHeaderView
    }
    
    //MARK: build BottomBar
    func buildBottomBar() {
        bottomView = UIView.init(frame: CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49))
        bottomView.backgroundColor = UIColor.whiteColor()
        view.addSubview(bottomView)
        
        //评论按钮
        commentBtn.frame = CGRectMake(26, 15, 60, 20)
        commentBtn.addTarget(self, action: "goToComment", forControlEvents: .TouchUpInside)
        commentBtn.setTitle("评论", forState: .Normal)
        commentBtn.setTitleColor(GrayLineColor, forState: .Normal)
        commentBtn.titleLabel?.font = UIFont(name: LightFont, size: 15.0)
        commentBtn.setImage(UIImage(named: "comments"), forState: .Normal)
        commentBtn.setImage(UIImage(named: "comments"), forState: .Highlighted)
        bottomView.addSubview(commentBtn)
        
        //喜欢按钮
        likeBtn.frame = CGRectMake(CGRectGetMaxX(commentBtn.frame) + 50, 15, 60, 20)
        likeBtn.addTarget(self, action: "favoriteThisProduct:", forControlEvents: .TouchUpInside)
        likeBtn.setTitle("喜欢", forState: .Normal)
        likeBtn.setTitleColor(GrayLineColor, forState: .Normal)
        likeBtn.titleLabel?.font = UIFont(name: LightFont, size: 15.0)
        likeBtn.setImage(UIImage(named: "addToFavoriteBtn"), forState: .Normal)
        likeBtn.setImage(UIImage(named: "addToFavoriteBtn"), forState: .Highlighted)
        likeBtn.setImage(UIImage(named: "addToFavorite_selected"), forState: .Selected)
        bottomView.addSubview(likeBtn)
    }
    //评论
    func goToComment() {
    
    }
    //喜欢
    func favoriteThisProduct(sender:UIButton) {
        
        sender.selected = !sender.selected
        // 切图太粗糙 只能这样了。
        if(sender.selected == true)
        {
            sender.setImage(UIImage(named: "addToFavorite_selected"), forState: .Highlighted)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }, completion: { (finished:Bool) -> Void in
                    if finished == true {
                        sender.transform = CGAffineTransformIdentity
                    }
            })
            productModel?.isLike = true
        }else {
            sender.setImage(UIImage(named: "addToFavoriteBtn"), forState: .Highlighted)
        }
        
    }
    
    //MARK: build tableView 
    
    func buildTableView()
    {
        showTableView = UITableView.init(frame: CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_WIDTH))
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.tableHeaderView = buildProductDetailView()
        view.addSubview(showTableView)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (productModel?.comment_list?.count)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let commentModel = productModel?.comment_list![indexPath.row]
        if commentModel?.cellHeight != nil {
            return (commentModel?.cellHeight)!
        }
        
        return 100
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let commentModel = productModel?.comment_list![indexPath.row]
        let cell = ProductCommentCell.productCommentCell(tableView, Model: commentModel!)
        return cell
    }
    // UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == showTableView)
        {
            if showTableView.contentOffset.y > 0 && showTableView.frame.origin.y > SCREEN_WIDTH-49  ||
                showTableView.contentOffset.y < 0 && showTableView.frame.origin.y < SCREEN_WIDTH
            {
                view.bringSubviewToFront(showTableView)
                view.bringSubviewToFront(customBar)
                view.bringSubviewToFront(bottomView)
                showTableView.center = CGPointMake(SCREEN_WIDTH/2, showTableView.center.y - showTableView.contentOffset.y)
            }else if showTableView.frame.origin.y >= 0 && showTableView.frame.origin.y <= SCREEN_WIDTH+49 && showTableView.contentOffset.y < 0 {
                let transScale = -showTableView.contentOffset.y / SCREEN_WIDTH
                showScrollView.transform = CGAffineTransformMakeScale(1+transScale, 1+transScale)
                view.bringSubviewToFront(showScrollView)
                view.bringSubviewToFront(customBar)
                view.bringSubviewToFront(bottomView)
                showScrollView.clipsToBounds = false
            }

        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == showScrollView
        {
            let currentIndex = Int(showScrollView.contentOffset.x / SCREEN_WIDTH )
            pageControl.currentPage = currentIndex
        }
        
    }
    
}
