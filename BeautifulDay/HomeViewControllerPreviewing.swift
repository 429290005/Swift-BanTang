//
//  HomeViewControllerPreviewing.swift
//  BeautifulDay
//
//  Created by jiachen on 16/3/1.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

extension HomeViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        
        //-----这一过程这么繁琐  说白了就是找到当前手指点到的 tableviewCell，后面 3Dtouch 预览的时候会用到 原尺寸 cell.frame
        let index = Int( showCollectionView.contentOffset.x / SCREEN_WIDTH )
        let collectionViewCell = showCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: index))
        var tableView = UITableView()
        for aview in collectionViewCell!.contentView.subviews {
            if aview.isKindOfClass(UITableView.self) {
                tableView = aview as! UITableView
            }
        }
        //*******
        
        let indexPath = tableView.indexPathForRowAtPoint(location)
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! HomeCell
        
        let detailListContrller = ListDetailViewController(listId: "1872",transImage: cell.imgView.image!)
        
    
        //预显示的尺寸
        detailListContrller.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 600)
        //源尺寸
        previewingContext.sourceRect = cell.frame
        
        return detailListContrller
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}

