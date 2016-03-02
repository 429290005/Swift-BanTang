//
//  ShowMeViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/18.
//  Copyright © 2016年 jiachen. All rights reserved.
//  tips: IOS 9.0以后系统提示用 PHPhotoLibrary 替代 AssetsLibrary

import UIKit
import AssetsLibrary
import Photos

class ShowMeViewController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    //当前 collectionView 用到的 PHAssetCollection
    private var currentPhotoData = PHFetchResult()
    
    //相机管理类
    private var imageManger = PHCachingImageManager()
    
    //展示图片 collectionView
    private var showCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readImagesFromPhone()
        
        buildCollectionView()
    }

    //MARK: 获取相册数据
    func readImagesFromPhone() {
        // 列出所有的智能相册
        let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumRegular, options: nil)
        
        
        
        imageManger = PHCachingImageManager()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        //currentPhotoData 只会获取到 '相机胶卷'中的照片
        for var i = 0 ; i < smartAlbums.count ; i++ {
            print(smartAlbums[i].localizedTitle)
            if smartAlbums[i].localizedTitle == "相机胶卷" || smartAlbums[i].localizedTitle == "Camera Roll"{
                currentPhotoData = PHAsset.fetchAssetsInAssetCollection(smartAlbums[i] as! PHAssetCollection , options: options)
            }
        }
    }
    
    
    //MARK: build collectionView
    func buildCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 4
        
        showCollectionView = UICollectionView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64), collectionViewLayout: layout)
        showCollectionView?.backgroundColor = UIColor.whiteColor()
        showCollectionView!.registerClass(ShowMeCell.self, forCellWithReuseIdentifier: "ShowMeCollectionViewCell")
        showCollectionView!.delegate = self
        showCollectionView!.dataSource = self
        view.addSubview(showCollectionView!)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + currentPhotoData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        let cell = ShowMeCell.cell(collectionView, indexPath: indexPath, displayImage: nil)
        if indexPath.row != 0 {
            let assets = currentPhotoData[indexPath.row - 1]
            
            imageManger.requestImageForAsset(assets as! PHAsset, targetSize: CGSizeMake(103, 103), contentMode: .AspectFit, options: nil) { (image, array) -> Void in
                cell.image = image
            }
        }else {
            cell.image = nil
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(206/2, 206/2)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(4, 2, 0, 2)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            clickOpenImagePickVC()
        }else {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.layer.zPosition = 2.0
            //执行cell  弹簧动画
            UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 50.0, options: .CurveEaseInOut, animations: { () -> Void in
                cell?.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }, completion: { (finished: Bool) -> Void in
                    cell?.transform = CGAffineTransformIdentity
                    cell?.layer.zPosition = 0.0
                    TipView.showMessage("我没有做诶😅")
            })
            
        }
    }
    
    //MARK: 点击拍照 
    func clickOpenImagePickVC() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }else {
            TipView.showMessage("骚年，找个有摄像头的手机吧。。")
        }
        
    }
    //拍照 代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        //拍完照 看看拍的怎怎么样 。。
        let imageView = UIImageView.init(frame: CGRectMake(0, SCREEN_HEIGHT/2 - SCREEN_WIDTH/2, SCREEN_WIDTH, SCREEN_WIDTH))
        imageView.image = image
        view.addSubview(imageView)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            imageView.removeFromSuperview()
            TipView.showMessage("看看你拍照技术怎样👀")
        })
    }
    
}
