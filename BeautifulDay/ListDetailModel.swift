//
//  ListDetailModel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/19.
//  Copyright © 2016年 jiachen. All rights reserved.
//  列表详情 名称，连接，列表中包含的商品

import UIKit

class ListDetailModel: NSObject {

    let listJsonName = NSArray(objects:"1872","1898")
    var dict = NSDictionary()
   class func readDataFromJSON(fileName:String) ->NSDictionary?
    {
        let listDetailModel = ListDetailModel()
        //先判断json本地数据中 有没有要显示的list
        var isExist = false
        for name in listDetailModel.listJsonName
        {
            if(name as! String == fileName)
            {
                isExist = true
            }
        }
        if(!isExist)
        {
            print("该清单尚未获取json数据")
            return nil
        }else
        {
            //获取资源文件
            let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil)
            let data = NSData(contentsOfFile: path!)

            listDetailModel.dict = ( try! NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments) ) as! NSDictionary
            return listDetailModel.dict
        
        }
        
        
    }
}



class ListModel {
 /// 列表 ID
    var listID:String?
 /// 列表分类
    var category:String?
 /// title
    var title:String?
 /// 文字描述详情
    var detailText:String?
 ///imageUrl
    var imageUrl:String?
 ///喜欢人数
    var likesNum:String?
 /// 是否已经收藏
    var islike:Bool?
 /// 清单便签
    var tags:String?
 /// 分享链接
    var share_url:String?
 /// 分享图片
    var share_imageUrl:String?
 /// imageHost
    var imageHost:String?
 /// imageHost
    var user_avatr_host:String?
    var productArray:[ListDetailProduct]?
    
    //清单的构造方法
   class func createListModel(listID:String)->ListModel?
    {
        let model = ListModel()
        var tmpProductArray = [ListDetailProduct]()
        
        let dict = ListDetailModel.readDataFromJSON(listID)
        if(dict == nil)
        {
            return nil
        }
        let dataDict = dict?.objectForKey("data") as! NSDictionary
        
        //清单的属性
        model.listID = listID
        model.category = dataDict.objectForKey("category") as? String
        if let aaa = dataDict.objectForKey("category") {
            model.category = aaa as? String
        }
        model.title = dataDict.objectForKey("title") as? String
        model.detailText = dataDict.objectForKey("desc") as? String
        model.imageUrl = dataDict.objectForKey("pic") as? String
        model.likesNum = dataDict.objectForKey("likes") as? String
        model.islike = dataDict.objectForKey("islike") as? Bool
        model.tags = dataDict.objectForKey("tags") as? String
        model.share_url = dataDict.objectForKey("share_url") as? String
        model.share_imageUrl = dataDict.objectForKey("share_pic") as? String
        model.imageHost = dataDict.objectForKey("product_pic_host") as? String
        model.user_avatr_host = dataDict.objectForKey("user_avatr_host") as? String
        
        //清单中包含的子商品
        let productArray = dataDict.objectForKey("product") as! NSArray
        print("清单中包含的子商品个数: \(productArray.count)")
        
        for var index = 0; index < productArray.count ; index++
        {
            let obj = productArray[index] as! NSDictionary
            
            let productModel = ListDetailProduct()
            productModel.productID = obj.objectForKey("id") as? String
            productModel.topic_id = obj.objectForKey("topic_id") as? String
            productModel.productName = obj.objectForKey("title") as? String
            productModel.category = obj.objectForKey("category") as? String
            productModel.likeNumbers = obj.objectForKey("likes") as? String
            productModel.detailText = obj.objectForKey("desc") as? String
            productModel.price = obj.objectForKey("price") as? String
            productModel.productUrl = obj.objectForKey("url") as? String
            productModel.isComments = obj.objectForKey("iscomments") as? Bool
            productModel.comments = obj.objectForKey("comments") as? String
            productModel.isLike = obj.objectForKey("islike") as? Bool
            productModel.platform = obj.objectForKey("platform") as? String

            //获取商品图片数组
            let imageArr = obj.objectForKey("pic") as? NSArray
            productModel.picArray = Array()
            for var i = 0 ; i < imageArr!.count ; i++
            {
                let picObject = imageArr![i] as! NSDictionary
                
                let picModel = PicModel()
                picModel.imageUrl = picObject.objectForKey("p") as? String
                picModel.width = picObject.objectForKey("w") as? CGFloat
                picModel.height = picObject.objectForKey("h") as? CGFloat
                
                productModel.picArray?.append(picModel)
            }
            
            //获取喜欢列表
            let likeList = obj.objectForKey("likes_list") as? NSArray
            productModel.likes_list = Array()
            for var i = 0 ; i < likeList?.count ; i++
            {
                let listObject = likeList![i] as! NSDictionary
                
                let listModel = LikeList()
                listModel.userID = listObject.objectForKey("u") as? Int
                listModel.headerImageUrl = listObject.objectForKey("a") as? String
                productModel.likes_list?.append(listModel)
            }
            tmpProductArray.append(productModel)
        }
        
        model.productArray = tmpProductArray
        
        return model
    }
}

///清单明细model
class ListDetailProduct {
 /// 商品id
    var productID:String?
 /// topic _id
    var topic_id:String?
    /// 商品图片数组
    var picArray:[PicModel]?
 /// ccategory
    var category:String?
 /// 商品名称
    var productName:String?
 /// 详情描述
    var detailText:String?
 /// 价格
    var price:String?
 /// 商品的链接：包括 淘宝，京东，亚马逊等
    var productUrl:String?
 /// 商品所在平台
    var platform:String?
 /// 是否评论过该商品
    var isComments:Bool?
 /// 评论次数
    var comments:String?
 /// 是否已经收藏
    var isLike:Bool?
 /// 喜欢人数
    var likeNumbers:String?
 /// 喜欢列表
    var likes_list:[LikeList]?
 /// cell高度
    var cellHieght:CGFloat?
}

class PicModel {
    ///图片连接
    var imageUrl:String?{
        didSet{
            if imageUrl?.characters.count < 30 {
                //如果 链接省略了 前缀 拼接imageUrl
                imageUrl = "http://bt.img.17gwx.com/\(imageUrl!)"
            }
        }
    }

    /// 图片宽度
    var width:CGFloat?
    /// 图片高度
    var height:CGFloat?
    
   }

/// 喜欢某个商品的喜欢列表
class LikeList {
 /// 用户id
    var userID:Int?
    /// 昵称
    var nickname:String?
 /// 用户头像
    var headerImageUrl:String?{
        didSet{
            headerImageUrl = "http://7te7t9.com2.z0.glb.qiniucdn.com/\(headerImageUrl!)"
        }
    
    }
    
}
