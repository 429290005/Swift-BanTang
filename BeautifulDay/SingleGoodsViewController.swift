//
//  SingleGoodsViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/1.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SingleGoodsViewController: BaseViewController{

    private var showTableView = UITableView()
    private var listData: [SearchSingleGoodsModel]?
    
    override init(leftTitle: String, rightTitle: String) {
        super.init(leftTitle: leftTitle, rightTitle: rightTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        buildTableView()
    }
    
    
    //MARK: load data
    func loadData()
    {
        listData = SearchSingleGoodsModel.createSearchSingleGoodsModel()
    }

    //MARK: build UI
    
    func buildTableView()
    {
        showTableView = UITableView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
//        showTableView.registerClass(SingleGoodsCell.self, forCellReuseIdentifier: "SingleGoodsCellIdentifier")
        showTableView.separatorStyle = .None
        showTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
        showTableView.delegate = self
        showTableView.dataSource = self
        view.addSubview(showTableView)
    }
}


extension SingleGoodsViewController: UITableViewDelegate,UITableViewDataSource{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listData != nil && listData?.count > 0 {
            return (listData?.count)!
        }
        
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return indexPath.row % 2 == 0 ? 135.0 : 5.0
    }

    //利用空cell 作为分割
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = listData![indexPath.row]
        let cell = SingleGoodsCell.singleGoodsCell(indexPath, tableview: tableView, model: model)
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath != NSIndexPath(forRow: 0, inSection: 0))
        {
            TipView.showMessage("暂时没没有数据哦")
        }else
        {
            let id = (listData![indexPath.row].productID)!
            let productDetailVC = ProductDetailViewController.init(productID:id)
            navigationController?.pushViewController(productDetailVC, animated: true)
            
        }
        
    }

}