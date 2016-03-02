//
//  PersonCenterViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/18.
//  Copyright © 2016年 jiachen. All rights reserved.
//  tips:  设计思路 ：topView是个透明的 view      backImgView 是在其后面 collectionView 向下滑动的时候 backImgView 发生形变
//  设计思路： 下面是 collectionView   上面是 headerView  backImgView随着collectionView的 contentoffset.y变化 而 transfrom 变化
import UIKit

enum ShowCollectionViewType {
    /// 单品
    case SingleMode
    /// 清单
    case ListMode
    /// 互动
    case ActivityMode
    /// 发布
    case PublishMode
}


class PersonCenterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
    TitleViewDelegate

{

    private var topView = PersonCenterHeaderImageView()
    /// 头像
    private var headerImgView = UIImageView()

    private var titleView: TitleView?
    
    private var backImgView = UIImageView()
    
    private var collectionHeadView = UIView()
    
    private var showCollectionView: UICollectionView?
    
    private var collectionViewMode: ShowCollectionViewType?
    
    //单品 model
    private var singleListData: [SearchSingleGoodsModel]?
    
    //清单 model
    private var listArray = NSMutableArray()
    
    //互动model
    private var activityArray: [UserRecommendModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        loadData()
    
        buildCollectionHeaderView()
        
        buildCollectionView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if UserSex.containsString("帅哥") {
            topView.selectSexBtn.setImage(UIImage(named: "iconfont-男人"), forState: .Normal)
        }else {
            topView.selectSexBtn.setImage(UIImage(named: "iconfont-女人"), forState: .Normal)
        }
    }
    
    //MARK: loadData
    func loadData() {
        singleListData = SearchSingleGoodsModel.createSearchSingleGoodsModel()
        
        listArray = ProductRecommend().createProductRecommendModel(0)
        
        activityArray = UserRecommendModel.createUserRecommendModel("1872")
    }
    
    
    //MARK: Build collectionheaderView
    func buildCollectionHeaderView() {
    
        collectionHeadView = UIView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 385))
        collectionHeadView.backgroundColor = UIColor.clearColor()
        
        backImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230)
//        backImgView.backgroundColor = UIColor.blackColor()
        backImgView.image = UIImage(named: "PersonCenterbackImage")
        view.addSubview(backImgView)
        
        topView = PersonCenterHeaderImageView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, 230))
        
        //更换头像
        topView.clickHeaderImage = { () -> () in
            let alertController = UIAlertController(title: "更换头像", message: "选取一张你喜欢的图片哦", preferredStyle: .ActionSheet)
            
            let action_TakeingPhotos = UIAlertAction(title: "拍照", style: .Default, handler: { (alertAction) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }else {
                    TipView.showMessage("骚年，找个有摄像头的手机吧。。")
                }
            })
            let action_ReadFromPhotos = UIAlertAction(title: "从相册取", style: .Default, handler: { (alertAction) -> Void in
                let showMeVC = ShowMeViewController.init(leftTitle: "取消", rightTitle: "")
                let nav = BaseNavigationController(rootViewController: showMeVC)
                self.presentViewController(nav, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "不换咯", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertController.addAction(action_ReadFromPhotos)
            alertController.addAction(action_TakeingPhotos)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        topView.clickSettingButton = { () -> () in
            let settingVC = SettingViewController.init(leftTitle:"",rightTitle: "投稿")
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
        topView.clickSelectSex = { () -> () in
            let selectSexVC = SelectedSexViewController.init(leftTitle:"", rightTitle: "")
            let nav = BaseNavigationController(rootViewController: selectSexVC)
            self.navigationController?.presentViewController(nav, animated: true, completion: nil)
        }
        collectionHeadView.addSubview(topView)
        
        //订单 好友 积分 小队
        let fourButtonView = FourButtonView(frame: CGRectMake(0 ,230,SCREEN_WIDTH,111))
        //fourButtonView 点击事件处理
        fourButtonView.fourButtonClickCenter = { (ButtonTag: Int) -> () in

            switch ButtonTag {
            case FourButtonType.OrderButtonClick.rawValue:
                TipView.showMessage("暂时木有订单噢~")
                break
            case FourButtonType.FriedButtonClick.rawValue:
                let friendVC = FriendViewController.init(leftTitle:"",rightTitle:"")
                let nav = BaseNavigationController(rootViewController: friendVC)
                self.presentViewController(nav, animated: true, completion: nil)
                break
                
              
                
                
            case FourButtonType.PointBUttonClick.rawValue:
                TipView.showMessage("骚年你的积分还有 \(UserPoint)")
                break
                
            case FourButtonType.TeamButtonClick.rawValue:
                //种草
                let teamVC = PlantGrassViewController.init(leftTitle:"",rightTitle:"")
                self.navigationController?.pushViewController(teamVC, animated: true)
                
                break
            default:
                break
            }
        }
        collectionHeadView.addSubview(fourButtonView)
        
        
        //分类 titleView
        titleView = TitleView(titleArr: NSArray(objects: "单品","清单","互动","发布"), normalColor: MainTitleColor, highlightColor: CustomBarTintColor, fontSize: 15.0, textLength: 2, buttonSpacing: 114/2)
        titleView?.frame = CGRectMake(0, CGRectGetMaxY(topView.frame) + 111, SCREEN_WIDTH, 45)
        titleView?.clickDelegate = self
        collectionHeadView.addSubview(titleView!)
    }
    //titleView 点击事件处理
    func TitleViewClick(titleVIew: TitleView, clickBtnIndex: Int) {

        switch clickBtnIndex {
            case 0:
                collectionViewMode = .SingleMode
                showCollectionView?.reloadData()
                break
            case 1:
                collectionViewMode = .ListMode
                showCollectionView?.reloadData()
                break
            case 2:
                collectionViewMode = .ActivityMode
                showCollectionView?.reloadData()
                break
            case 3:
                collectionViewMode = .PublishMode
                showCollectionView?.reloadData()
                break
            default:
                break
        }
    }
    
    //MARK: build collectionView 
    func buildCollectionView() {
        collectionViewMode = ShowCollectionViewType.SingleMode
        
        let layout = UICollectionViewFlowLayout.init()
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 385)
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        showCollectionView = UICollectionView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49), collectionViewLayout: layout)
        showCollectionView?.showsVerticalScrollIndicator = false
        //设置 showCollectionView 的颜色   会导致 headerView 的颜色设置失效，试试就知道了😛
        showCollectionView?.backgroundColor = UIColor.clearColor()
        
        //注册 单品 cell
        showCollectionView?.registerClass(PersonCenterSingleCell.self, forCellWithReuseIdentifier: "PersonCenterSingleCell")
        //注册 清单 cell
        showCollectionView?.registerClass(PersonCenterListCell.self, forCellWithReuseIdentifier: "PersonCenterListCell")
        //注册 互动 cell
        showCollectionView?.registerClass(PersonCenterActivityCell.self, forCellWithReuseIdentifier: "PersonCenterActivityCell")
        //注册 发布 cell
        showCollectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "PersonCenterPublishCell")
        //注册headerView
        showCollectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeaderView")
        showCollectionView!.delegate = self
        showCollectionView!.dataSource = self
        
        view.addSubview(showCollectionView!)
    }
    
    //MARK: UICollectionVIewDelegate uiCollecitonVIewDataSource UICollectionViewDelegateFlowLayout
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionViewMode == .SingleMode {
            return (singleListData?.count)!
        }else if collectionViewMode == .ListMode {
            return listArray.count
        }else if collectionViewMode == .ActivityMode {
            return (activityArray?.count)!
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionViewMode == ShowCollectionViewType.SingleMode {
            let model = singleListData![indexPath.row]
            let cell = PersonCenterSingleCell.cell(collectionView, indexPath: indexPath, model: model)
            return cell
        }else if collectionViewMode == .ListMode {
            let model = listArray[indexPath.row] as! ProductRecommendModel
            let cell = PersonCenterListCell.cell(collectionView, indexPath: indexPath, model: model)
            return cell
        }else if collectionViewMode == .ActivityMode {
            let model = activityArray![indexPath.row]
            let cell = PersonCenterActivityCell.cell(collectionView, indexPath: indexPath, model: model)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCenterPublishCell", forIndexPath: indexPath)
            cell.contentView.backgroundColor = UIColor.whiteColor()
            let imgView = UIImageView(frame: CGRectMake(SCREEN_WIDTH/2 - 85, 60, 170, 170))
            imgView.image = UIImage(named: "PersonCenterPublish")
            cell.contentView.addSubview(imgView)
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if collectionViewMode == .SingleMode {
            return CGSizeMake(145, 170)
        }else if collectionViewMode == .ListMode {
            return CGSizeMake(SCREEN_WIDTH, 171+63)
        }else if collectionViewMode == .ActivityMode {
            return CGSizeMake(145, 225)
        }
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45 - 49 - 45)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if collectionViewMode == .SingleMode {
            return UIEdgeInsetsMake(10, 10, 10, 10)
        }
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reuseView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeaderView", forIndexPath: indexPath)
            
            headView.addSubview(collectionHeadView)
            reuseView = headView
        }
        return reuseView
    }
    
    
    
    
    
    //MARK: imagePickViewControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            picker.dismissViewControllerAnimated(true, completion: nil)
            self.topView.headerImage = image
        }
        
    }
    
    // collectionView 滚动时的 效果
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == showCollectionView {
            
            if scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < 230+111 {
                backImgView.frame = CGRectMake(0, -scrollView.contentOffset.y, SCREEN_WIDTH, 230)
                //将 titleView 又放回到 collectionHeaderView 中去
                titleView?.removeFromSuperview()
                titleView?.frame = CGRectMake(0, 230+111, SCREEN_WIDTH, 45)
                collectionHeadView.addSubview(titleView!)
            }else if scrollView.contentOffset.y <= 0 && scrollView.contentOffset.y >= -50 {
                let scale = (230 - scrollView.contentOffset.y) / 230
                backImgView.transform = CGAffineTransformMakeScale(scale, scale)
                backImgView.frame = CGRectMake(-SCREEN_WIDTH * (scale - 1)/2, 0, SCREEN_WIDTH * scale, scale * 230)
            }else if scrollView.contentOffset.y == 341 || (scrollView.contentOffset.y > 341 && titleView?.frame.origin.y != 45){
                //(scrollView.contentOffset.y > 341 && titleView?.frame.origin.y != 45)  防止滚动过快  titleView 没有从 view 中移除出来
            
                titleView?.removeFromSuperview()
                titleView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45)
                titleView?.layer.zPosition = 2.0
                view.addSubview(titleView!)
            }else if scrollView.contentOffset.y < -50 {
                //最多可以向下拉动50的距离
                scrollView.contentOffset = CGPointMake(0, -50)
            }
        }
    }
    
}
