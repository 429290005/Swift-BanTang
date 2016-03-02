//
//  SearchModel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/30.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class SearchModel: NSObject {

 /// 分类 id
    var categoryID:String?
 /// 分类 名称
    var name:String?
 /// 图片URL
    var iconUrl:String?
 /// 英文名
    var en_name:String?
    
    var subList:[SearchModel]?
    
    
    
    /**
     返回搜索列表 model
     
     - returns: 返回搜索列表 model
     */
    class func createSearchModel() -> [SearchModel]
    {
        let path = NSBundle.mainBundle().pathForResource("搜索列表", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let data = Dict.objectForKey("data") as? NSArray
        
        var searchArr = [SearchModel]()
        
        for var i = 0 ; i < data?.count ; i++ {
        
            let model = SearchModel()
            let obj = data![i] as! NSDictionary
            model.categoryID = obj.objectForKey("id") as? String
            model.name = obj.objectForKey("name") as? String
            model.en_name = obj.objectForKey("en_name") as? String
            model.iconUrl = obj.objectForKey("icon") as? String
            
            //二级分类
            let subListData = obj.objectForKey("subclass") as? NSArray
            
            model.subList = [SearchModel]()
            for var i = 0 ; i < subListData?.count ; i++
            {
                let subListModel = SearchModel()
                let subObj = subListData![i] as! NSDictionary
                
                subListModel.categoryID = subObj.objectForKey("id") as? String
                subListModel.name = subObj.objectForKey("name") as? String
                subListModel.en_name = ""
                subListModel.iconUrl = subObj.objectForKey("icon") as? String
                //二级分类下没有 三级分类了 先置空
                subListModel.subList = nil
                
                model.subList?.append(subListModel)
            }
            searchArr.append(model)
        }
        return searchArr
    }
    
}

/// 搜索清单 model
class SearchListModel:NSObject {
    /// 分类 id
    var categoryID:String?
    /// 分类 名称
    var name:String?
    /// 图片URL
    var iconUrl:String?
    /// 英文名
    var en_name:String?

    //  广场 viewController 中可能会用到
    var sub_title: String?
    
    
    /**
     返回搜索清单 model
     */
    class func createSearchListModel() -> [SearchListModel]{
        let path = NSBundle.mainBundle().pathForResource("搜索清单", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let data = Dict.objectForKey("data") as? NSArray
        
        var searchArr = [SearchListModel]()
        
        for var i = 0 ; i < data?.count ; i++ {
            
            let model = SearchListModel()
            let obj = data![i] as! NSDictionary
            model.categoryID = obj.objectForKey("id") as? String
            model.name = obj.objectForKey("name") as? String
            model.en_name = obj.objectForKey("en_name") as? String
            model.iconUrl = obj.objectForKey("icon") as? String
            
            searchArr.append(model)
        }
        return searchArr
    }
        
}

//点击 搜索列表中 的结果
class SearchSingleGoodsModel: ListDetailProduct {
    var imageUrl:String?
    var author:Author?
    
    class func createSearchSingleGoodsModel() -> [SearchSingleGoodsModel]
    {
        let path = NSBundle.mainBundle().pathForResource("底妆", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let data = Dict.objectForKey("data") as? NSDictionary
        let listData = data?.objectForKey("list") as? NSArray
        
        var searchSingleResult = [SearchSingleGoodsModel]()
        
        for var i = 0 ; i < listData?.count ; i++ {
            
            let listObj = listData![i] as! NSDictionary
            let model = SearchSingleGoodsModel()
            model.productID = listObj.objectForKey("id") as? String
            model.productName = listObj.objectForKey("title") as? String
            model.detailText = listObj.objectForKey("desc") as? String
            model.price = listObj.objectForKey("price") as? String
            model.imageUrl = listObj.objectForKey("pic") as? String
            model.likeNumbers = listObj.objectForKey("likes") as? String
        
            let user = listObj.objectForKey("user") as! NSDictionary
            let author = Author()
            author.user_id = user.objectForKey("user_id") as? String
            author.nickName = user.objectForKey("nickname") as? String
            author.headerImageUrl = user.objectForKey("avatar") as? String
            author.is_official = user.objectForKey("is_offical") as? Int
            
            model.author = author
            
            searchSingleResult.append(model)
         }
        return searchSingleResult
    
    }
    
}
