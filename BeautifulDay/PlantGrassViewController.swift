//
//  PlantGrassViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/19.
//  Copyright © 2016年 jiachen. All rights reserved.
//  种草小分队

import UIKit

class PlantGrassViewController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    private var showCollectionView: UICollectionView?
    private var teamModel: [PlantGrassTeamModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "种草小分队"
        
       
        loadData()
        
        buildCollectionView()
    }

    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK: loadData
    func loadData() {
        teamModel = PlantGrassTeamModel.readTeamData()
    }
    
    //MARK: build collectionView
    func buildCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
    
        showCollectionView = UICollectionView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64), collectionViewLayout: layout)
        showCollectionView?.backgroundColor = UIColor.whiteColor()
        showCollectionView!.registerClass(PlantGrassCell.self, forCellWithReuseIdentifier: "PlantGrassTeamCellIDentfier")
        showCollectionView!.delegate = self
        showCollectionView!.dataSource = self
        
        view.addSubview(showCollectionView!)
    }
    
    //MARK: UICollectionViewDelegate DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if teamModel != nil && teamModel?.count > 0 {
            return (teamModel?.count)!
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = PlantGrassCell.cell(collectionView, Indexpath: indexPath, model: teamModel![indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //cell 出现时  会有向上滑动的效果
        var aFrame = cell.frame
        let oldFrame = cell.frame
        aFrame.origin.y += 15
        cell.frame = aFrame
        aFrame.origin.y -= 15
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.frame = aFrame
            }) { (finished:Bool) -> Void in
                if finished == true {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.frame = oldFrame
                    })
                }
        }
    }
    
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(300, 228/2)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    //点中 cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            let plantGrassDeatailVC = PlantGrassDetailViewController()
            plantGrassDeatailVC.teamModel = teamModel![indexPath.row]
            navigationController?.pushViewController(plantGrassDeatailVC, animated: true)
        }else {
            TipView.showMessage("暂木有数据啦👻")
        }
    }
}
