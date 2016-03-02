//
//  SearchViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/19.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout ,SegmentViewDelegate{

    private var singleTableView = UITableView()
    private var singleCollectionView: UICollectionView?
    
    private var showCollectionView: UICollectionView?
    private var listCollectionView: UICollectionView?

    private var customBar = UIView()
    private var cancelBtn = UIButton()
    private var searchBar = CMSearchBar()
    private var myContext = 0
    private var segmentView:SegmentView?
    
    private var searchSingleModel: [SearchModel]?
    private var subClassModel: [SearchModel]?
    
    private  var searchListModel:[SearchListModel]?
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        loadData()
        
        buildCustomBar()
        
        buildSegmentView()
        
        buildCollectionView()
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:导入数据
    func loadData()
    {
        searchSingleModel = SearchModel.createSearchModel()
    
        subClassModel = searchSingleModel![0].subList
        
        searchListModel = SearchListModel.createSearchListModel()
    }
    
    //MARK:cuistomBar
    func buildCustomBar()
    {
        customBar = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 64))
        customBar.layer.zPosition = 2.0
        customBar.backgroundColor = UIColor(hexString: "EC5252")
        self.view.addSubview(customBar)
        
        //搜索按钮  点击 页面滑动至 搜索
        let backBtn = UIButton.init(frame: CGRectMake(16, 35, 20, 20))
        backBtn.setImage(UIImage(named: "back"), forState:.Normal)
        backBtn.addTarget(self, action: "backPop", forControlEvents: .TouchUpInside)
        customBar.addSubview(backBtn)
        
        
        cancelBtn = UIButton.init(frame: CGRectMake(SCREEN_WIDTH-18-30, 40, 30, 12))
        cancelBtn.setTitle("取消", forState: .Normal)
        cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelBtn.addTarget(self, action: "toCancelSearchBar:", forControlEvents: .TouchUpInside)
        customBar.addSubview(cancelBtn)

        buildSearchBar()
    }
    
    func backPop()
    {
        navigationController?.popViewControllerAnimated(true)
    }
    func toCancelSearchBar(sender:UIButton)
    {
        if searchBar.textField.text != ""{
            TipView.showMessage("暂时没有你想要的东东，试试 底妆吧")
        }else {
            //取消搜索 bar
            searchBar.cancelSearch()
        }
    }
    
    //MARK:顶部搜索栏
    func buildSearchBar()
    {
        //受制与 系统自带的导航栏并不好用 ，此处自定义搜索栏，
        searchBar = CMSearchBar.init(frame:CGRectMake(36, 30, 265, 29),Font: UIFont.systemFontOfSize(12.0),TextColor:MainTitleColor,PlaceHolder:"搜索 单品/清单/帖子/用户",HotWords:nil)
        weak var weakSelf = self
        searchBar.changetextfieldClourse = { (text: String) -> () in
            if text.characters.count == 0 {
                print("searchBar 已清空")
                weakSelf!.cancelBtn.setTitle("取消", forState: .Normal)
            }else if text.characters.count > 0 {
                weakSelf!.cancelBtn.setTitle("搜索", forState: .Normal)
            }
        }
        customBar.addSubview(searchBar)
    }
    
    //MARK:collection容器
    func buildCollectionView()
    {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        
        showCollectionView = UICollectionView.init(frame: CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT), collectionViewLayout: layout)
        showCollectionView?.backgroundColor = UIColor.whiteColor()
        showCollectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIDentifier")
        showCollectionView?.contentSize = CGSizeMake(2*SCREEN_WIDTH, 0)
        showCollectionView!.bounces = false
        showCollectionView!.pagingEnabled = true
        showCollectionView!.backgroundColor = UIColor.whiteColor()
        showCollectionView!.delegate = self
        showCollectionView!.dataSource = self
        view.addSubview(showCollectionView!)
    }
    //MARK:清单 vs 新品
    func buildSegmentView()
    {
        segmentView = SegmentView.init(frame: CGRectMake(0, 64, SCREEN_WIDTH, 44), firstTitle: "单品", secondTitle: "清单")
        segmentView?.delegate = self
        view.addSubview(segmentView!)
    }
    //segmentView delegate
    func clickSegmentView(clickIndex: Int) {
        showCollectionView?.setContentOffset(CGPointMake(CGFloat(clickIndex - 1) * SCREEN_WIDTH, 0), animated: true)
    }
    
    //MARK:单品
    func buildSingleTableView()
    {
        singleTableView = UITableView.init(frame: CGRectMake(0, 0, 80, SCREEN_HEIGHT), style: .Plain)
        singleTableView.separatorStyle = .None
        singleTableView.delegate = self
        singleTableView.dataSource = self
        singleTableView.contentInset = UIEdgeInsetsMake(0, 0, 64+44, 0)
    }
    
    func buildSingleCollectionView()
    {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        
        singleCollectionView = UICollectionView.init(frame: CGRectMake(80, 0, SCREEN_WIDTH-80, SCREEN_HEIGHT), collectionViewLayout: layout)
        singleCollectionView?.backgroundColor = UIColor.whiteColor()
        singleCollectionView?.registerClass(SearchSingleCell.self, forCellWithReuseIdentifier: "SearchSingleCellIdentifier")
        singleCollectionView?.contentSize = CGSizeMake(0, SCREEN_HEIGHT*1.5)
        singleCollectionView!.bounces = true
        singleCollectionView!.pagingEnabled = true
        singleCollectionView!.delegate = self
        singleCollectionView!.dataSource = self
    }
    
    //MARK:清单
    func buildListCollectionView()
    {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 35.0
        layout.minimumLineSpacing = 0.0
        
        listCollectionView = UICollectionView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT), collectionViewLayout: layout)
        listCollectionView?.contentInset = UIEdgeInsetsMake(0, 0, 64+44, 0)
        listCollectionView?.backgroundColor = UIColor.whiteColor()
        listCollectionView?.registerClass(SearchListCell.self, forCellWithReuseIdentifier: "SearchListCellIdentifier")
        listCollectionView!.bounces = true
        listCollectionView!.pagingEnabled = true
        listCollectionView!.delegate = self
        listCollectionView!.dataSource = self
        
    }

    //MARK:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == singleCollectionView)
        {
            if(section == numberOfSectionsInCollectionView(singleCollectionView!)-1)
            {
                return (subClassModel?.count)! % 3
            }
            return 3
        }else if(collectionView == listCollectionView)
        {
            if(section == numberOfSectionsInCollectionView(listCollectionView!)-1)
            {
                return (searchListModel?.count)! % 3
            }
            return 3
        }
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if(collectionView == singleCollectionView)
        {
            if(subClassModel != nil && subClassModel?.count > 0)
            {
                return   (subClassModel?.count)! % 3 == 0 ? (subClassModel?.count)! / 3 :  (subClassModel?.count)! / 3+1
            }
        }else if(collectionView == listCollectionView)
        {
            if(searchListModel != nil && searchListModel?.count > 0)
            {
                return   (searchListModel?.count)! % 3 == 0 ? (searchListModel?.count)! / 3 :  (searchListModel?.count)! / 3+1
            }
        }
        return 2
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if(collectionView == showCollectionView)
        {
            let cellID = "cellIDentifier"
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
            //将tableview 添加到cell中来
            if(indexPath.section == 0)
            {
                //单品
                buildSingleTableView()
                //默认显示第一个分类 "美妆"
                singleTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
                cell.contentView.addSubview(singleTableView)
                
                //单品 collection
                buildSingleCollectionView()
                cell.contentView.addSubview(singleCollectionView!)
                
            }else if(indexPath.section == 1)
            {
                //清单
                buildListCollectionView()
                cell.contentView.addSubview(listCollectionView!)
            }
            return cell
        }else if(collectionView == singleCollectionView)
        {
            let cellID = "SearchSingleCellIdentifier"
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! SearchSingleCell
            
            let model = subClassModel![indexPath.row + indexPath.section * 3]
            
            cell.searchModel = model
    
            return cell
        }
        //清单 collectionView
        let cellID = "SearchListCellIdentifier"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! SearchListCell
        let model = searchListModel![indexPath.row + indexPath.section * 3]
        cell.listModel = model
            
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        //先点击执行 放大动画
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            cell?.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { (finished:Bool) -> Void in
                if(finished){
                    cell?.transform = CGAffineTransformIdentity
                }
        }
        if(collectionView == singleCollectionView)
        {
            if(indexPath == NSIndexPath(forRow: 0, inSection: 0))
            {
                let singleGoodViewController = SingleGoodsViewController.init(leftTitle: "",rightTitle:"")
                singleGoodViewController.title = "底妆"
                navigationController?.pushViewController(singleGoodViewController, animated: true)
            }else{
                TipView.showMessage("还没有数据😉")
            }
        }
        
    }
    
    //MARK:--UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(collectionView == showCollectionView)
        {
            return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
        }else if(collectionView == singleCollectionView)
        {
            return CGSizeMake(60, 80)
        }
        
            return CGSizeMake(60, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if(collectionView == showCollectionView)
        {
            return UIEdgeInsetsZero
        }else if(collectionView == singleCollectionView)
        {
            return UIEdgeInsetsMake(15, 15, 0, 15)
        }
            return UIEdgeInsetsMake(15, 35, 0, 35)
    }
    
    //MARK:scrollViewDelegate
 
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView == showCollectionView)
        {
            segmentView?.currentIndex = (showCollectionView?.contentOffset.x)! / SCREEN_WIDTH
        }
    }

}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchSingleModel != nil && searchSingleModel?.count > 0)
        {
            return (searchSingleModel?.count)!
        }
        return 1
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellID)

            
            cell?.contentView.backgroundColor = UIColor(hexString: "F0F0F0")
            
            //选中背景 view
            let bgView = UIView.init(frame: cell!.frame)
            bgView.backgroundColor = UIColor.whiteColor()
                //选中指示器
            let indictor = UIView.init(frame: CGRectMake(0, 0, 1, 50))
            indictor.backgroundColor = CustomBarTintColor
            bgView.addSubview(indictor)
            cell?.selectedBackgroundView = bgView
            
            let listLabel = UILabel.init(frame: CGRectMake(40-13, 25-13/2, 26, 13))
            listLabel.text = searchSingleModel![indexPath.row].name
            listLabel.font = UIFont.systemFontOfSize(13.0)
            listLabel.textColor = CustomBarTintColor
            cell?.contentView.addSubview(listLabel)
        }else {
            for label in cell!.contentView.subviews {
                if label.isKindOfClass(UILabel) {
                    let lbl = label as! UILabel
                    // //////////////////////////
                    lbl.text = searchSingleModel![indexPath.row].name
                }
                
            }
            
        }
        
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //点击一级分类 ，刷新二级分类 singleCollectionView
        subClassModel = searchSingleModel![indexPath.row].subList
        singleCollectionView?.reloadData()
    }
}


