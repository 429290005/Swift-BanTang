//
//  ExperienceViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/14.
//  Copyright © 2016年 jiachen. All rights reserved.
//  广场、关注  
//  tips：  广场页面已经完成， 热门推荐下的 collectionVieWCell都没有进一步抓去 json    "关注"没有抓去数据

import UIKit

class SquareViewController: UIViewController,SegmentViewDelegate ,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    TitleViewDelegate

{

    private var segmentView = SegmentView()
    
    //view 容器
    private var showTableView = UITableView()
    
    /// 各个分类显示的 collectionView
    private var showCollectionView: UICollectionView?
    
    /// 种草小分队
    private var plantGrassTeamView: UICollectionView?
    
    
    //model
    private var teamModel: [PlantGrassTeamModel]?
    //选择的四个分类中的一个  二级分类
    private var elementModel: [SearchListModel]?
    private var cateGoryModel: [SquareModel]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        loadData()
        
        buildBarButtonItem()
        
        buildTitleView()
        
        buildCollectionView()
        
        buildPlantGrassTeamView()
        
        
    }

    //MARK: loadData
    func loadData() {
        teamModel = PlantGrassModel.readTeamData()
        cateGoryModel = SquareModel.createSearchListModel()
        elementModel = cateGoryModel![0].elements
    }
    
    //MARK: build navigationBar
    func buildBarButtonItem() {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let searchBtnItem = UIBarButtonItem(image: UIImage(named: "searchBtn"), style: .Done, target: self, action: "clickSearchBarButtonItem")
        navigationItem.leftBarButtonItem = searchBtnItem
        
        let addFriendBtn = UIBarButtonItem(title: "添加朋友", style: .Done, target: self, action: "clickAddFriend")
        navigationItem.rightBarButtonItem = addFriendBtn
        
        segmentView = SegmentView(frame: CGRectMake(SCREEN_WIDTH/2 - segmentView.frame.width/2, 0, 184/2, 44), firstTitle: "广场", secondTitle: "关注")
        segmentView.delegate = self
        segmentView.normalTextColor = UIColor(hexString: "FFB4B4")
        segmentView.selectedTextColor = UIColor.whiteColor()
        segmentView.isShowSeprator = false
        segmentView.isShowIndictor = true
        segmentView.backgroundColor = CustomBarTintColor
        navigationItem.titleView = UIView()
        navigationItem.titleView = segmentView
    }
    func clickSearchBarButtonItem() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    func clickAddFriend() {
        TipView.showMessage("找呀找呀找朋友😝")
    }

    //segmengtView 点击处理
    func clickSegmentView(clickIndex: Int) {
        if clickIndex == 2 {
            TipView.showMessage("木有关注啦😁")
        }
    }
   
    //MARK: build titleView
    func buildTitleView() {
        let titleView = TitleView(titleArr: NSArray(objects: "热门推荐","深夜食堂","变美神器","一种生活"), normalColor: MainTitleColor, highlightColor: CustomBarTintColor, fontSize: 15.0,textLength: 4.0,buttonSpacing: 20.0)
        titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45)
        titleView.clickDelegate = self
        view.addSubview(titleView)
    }
    // titleViewDelegate
    func TitleViewClick(titleVIew: TitleView, clickBtnIndex: Int) {
        elementModel = cateGoryModel![clickBtnIndex].elements
        showCollectionView?.reloadData()
    }
    
    //MARK: build colelcitonView
    func buildCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 30
        
        showCollectionView = UICollectionView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 450/2), collectionViewLayout: layout)
        showCollectionView?.backgroundColor = UIColor.whiteColor()
        showCollectionView?.scrollEnabled = false
        showCollectionView!.registerClass(SquareCategoryCell.self, forCellWithReuseIdentifier: "SquareCellIdentifier")
        showCollectionView!.delegate = self
        showCollectionView!.dataSource = self
        
//        view.addSubview(showCollectionView!)
    }
    // uicollectionViewDelegate UICollectionViewFlowLayout
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == showCollectionView {
            return 8
        }else {
            if teamModel != nil && teamModel?.count > 0 {
                return (teamModel?.count)!
            }
            return 1
        }
    
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == showCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SquareCellIdentifier", forIndexPath: indexPath) as! SquareCategoryCell
            
            let model = elementModel![indexPath.row]
            cell.squareModel = model

            return cell
        }else {
            
            let cell = PlantGrassCell.cell(collectionView, Indexpath: indexPath, model: teamModel![indexPath.row])
            
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView == showCollectionView {
            return CGSizeMake(50, 170/2)
        }
        return CGSizeMake(300, 228/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if collectionView == showCollectionView {
            return UIEdgeInsetsMake(15, 15, 20, 15)
        }
        return UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView.contentOffset.y > 0 {
            cell.alpha = 0.0
            UIView.animateWithDuration(0.4) { () -> Void in
                cell.alpha = 1.0
            }
        }
    }
    //MARK: build plantGrassTeamView
    func buildPlantGrassTeamView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 450/2+45)
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        
        plantGrassTeamView = UICollectionView.init(frame: CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 45), collectionViewLayout: layout)
        plantGrassTeamView?.backgroundColor = UIColor.whiteColor()
        plantGrassTeamView!.registerClass(PlantGrassCell.self, forCellWithReuseIdentifier: "PlantGrassTeamCellIDentfier")
        plantGrassTeamView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeaderView")
        plantGrassTeamView!.delegate = self
        plantGrassTeamView!.dataSource = self
    
        plantGrassTeamView!.addPullToRefreshWithActionHandler { () -> Void in
            TipView.showMessage("疯狂刷新中🙏")
            //模拟 网络刷新
            weak var weakSelf = self
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                weakSelf!.plantGrassTeamView!.pullToRefreshView.stopAnimating()
                weakSelf!.plantGrassTeamView!.pullToRefreshView.setTitle("上次刷新时间 \( NowTime.getNowtime() )", forState: .Stopped)
            })
        }
        //设置 下拉刷新的样式
        plantGrassTeamView!.pullToRefreshView.backgroundColor = UIColor.blackColor()
        plantGrassTeamView!.pullToRefreshView.textColor = UIColor.whiteColor()
        plantGrassTeamView!.pullToRefreshView.setSubtitle("👕送货上门哦", forState: SVPullToRefreshState.Stopped)
        plantGrassTeamView!.pullToRefreshView.setTitle("我就说说而已😝", forState: SVPullToRefreshState.Triggered)
        plantGrassTeamView!.pullToRefreshView.setTitle("耐心等会", forState: .Loading)
        plantGrassTeamView!.pullToRefreshView.setSubtitle("上次刷新时间 \( NowTime.getNowtime() )", forState: .Loading)
        
        view.addSubview(plantGrassTeamView!)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reuseView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeaderView", forIndexPath: indexPath)

            let tipLabel = UILabel.init(frame: CGRectMake(0, 450/2, SCREEN_WIDTH, 45))
            tipLabel.text = "--------种草小分队--------"
            tipLabel.font = UIFont(name: LightFont, size: 15.0)
            tipLabel.textColor = MainTitleColor
            tipLabel.textAlignment = .Center
            headView.addSubview(tipLabel)
            headView.addSubview(showCollectionView!)
            reuseView = headView
            
        }
        return reuseView
    }

    
    
    
}
