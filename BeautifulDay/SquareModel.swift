//
//  SquareModel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/24.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SquareModel: NSObject {
    /// id
    var id: String?
    /// title
    var title: String?
    /// 二级分类
    var elements: [SearchListModel]?
    
    
    /**
     返回 SquareModel 数组
     */
    class func createSearchListModel() -> [SquareModel]{
        let path = NSBundle.mainBundle().pathForResource("广场", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let data = Dict.objectForKey("data") as! NSDictionary
        let moduleData = data.objectForKey("module_elements") as! NSArray
    
        var squareArray = [SquareModel]()
        for var i = 0 ; i < moduleData.count ; i++ {
            let squareModel = SquareModel()
            let obj = moduleData[i] as! NSDictionary
            squareModel.id = obj.objectForKey("id") as? String
            squareModel.title = obj.objectForKey("title") as? String
            squareModel.elements = [SearchListModel]()
            
            //二级分类
            let subData = obj.objectForKey("elements") as! NSArray
            for var i = 0 ; i < subData.count ; i++ {
                let subModel = SearchListModel()
                let obj = subData[i] as! NSDictionary
                subModel.categoryID =  obj.objectForKey("id") as? String
                subModel.name = obj.objectForKey("title") as? String
                subModel.sub_title = obj.objectForKey("sub_title") as? String
                subModel.iconUrl = obj.objectForKey("photo") as? String
            
                squareModel.elements?.append(subModel)
            }
            squareArray.append(squareModel)
        }
        
        
        
        return squareArray
    }
}
