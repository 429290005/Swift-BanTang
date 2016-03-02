//
//  UserRecommendModel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/27.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class UserRecommendModel: NSObject {
    
    var userRecommendID:String?
    var title:String?
    /// 推荐文字
    var content:String?
    /// 创建日期
    var createTime:String?
    var author_id:String?
    
    /// 用户配置
    var dynamic:UserRecommendDynamic?
    /// 用户给它贴的标签
    var tagArray:[UserRecommendTags]?
    /// 图片数组
    var picArray:[UserRecommendPicModel]?
    /// 商品
    var productArray:[UserRecommendProductModel]?
    /// 作者
    var author:Author?
    /// 分享url
    var share_url:String?
    /// cell高度
    var cellHieght:CGFloat?
    
    
    //MARK:从json 中读取用户推荐数据

    
    //类方法 返回一个用户推荐model ，目前只做了"刷牙"这个清单😄
    class func createUserRecommendModel(listID:String) -> [UserRecommendModel]?{
        
        if(listID != "1872")
        {
            TipView.showMessage("这个清单名字太烂，没抓包😄")
            return nil
        }else{
            var userRecommendArray = [UserRecommendModel]()
            
            let path = NSBundle.mainBundle().pathForResource("用户推荐", ofType: nil)
            let nsData = NSData(contentsOfFile: path!)
            /// json整体转换为字典
            let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
            
            let data = Dict.objectForKey("data") as! NSDictionary
            
            let list = data.objectForKey("list") as! NSArray
            
            print("用户推荐中共有 \(list.count)")
            
            for var i = 0; i < list.count ; i++ {
                let obj = list[i]
                let recommendModel = UserRecommendModel()
                recommendModel.userRecommendID = obj.objectForKey("id") as? String
                recommendModel.title = obj.objectForKey("title") as? String
                recommendModel.content = obj.objectForKey("content") as? String
                recommendModel.author_id = obj.objectForKey("author_id") as? String
                recommendModel.share_url = obj.objectForKey("share_url") as? String
                recommendModel.createTime = obj.objectForKey("datestr") as? String
                
                //作者
                let authorDict = obj.objectForKey("author") as! NSDictionary
                recommendModel.author = Author.createAutor(authorDict)
                
                //picArray
                let picData = obj.objectForKey("pics") as! NSArray
                recommendModel.picArray = UserRecommendPicModel.createPicArray(picData)
                
                //tags
                let tagData = obj.objectForKey("tags") as! NSArray
                recommendModel.tagArray = UserRecommendTags.createTagArray(tagData)
                
                //dynamic
                let dynamicData = obj.objectForKey("dynamic") as! NSDictionary
                recommendModel.dynamic = UserRecommendDynamic.createUserRecommendDynamic(dynamicData)
                
                //product
                let productData = obj.objectForKey("product") as! NSArray
                recommendModel.productArray = UserRecommendProductModel.createProductArray(productData)
                
                userRecommendArray.append(recommendModel)
            }

            return userRecommendArray
        
        }
        
        
    }
    
}








/// 用户贴的标签  id+name
class UserRecommendTags {
 /// tag id
    var id:String?
 /// tag name
    var name:String?
    
 /// 返回tags数组
    
    class func createTagArray(tagData:NSArray) -> [UserRecommendTags]
    {
        var tagArray = [UserRecommendTags]()
        for var i = 0;i < tagData.count;i++
        {
            let tagObj = tagData[i]
            let tagModel = UserRecommendTags()
            tagModel.id = tagObj.objectForKey("id") as? String
            tagModel.name = tagObj.objectForKey("name") as? String
            tagArray.append(tagModel)
        }
        return tagArray
    }
    
}

/// 用户推荐中的商品模型
class UserRecommendPicModel {
    //图片url
    var url:String?
    /// 宽度
    var width:CGFloat?{
        didSet{
            if(width == 900)
            {
                width = SCREEN_WIDTH   //320
            }
        }
    }
    /// 高度
    var height:CGFloat?{
        didSet{
        
            if(height == 900)
            {
                height = SCREEN_WIDTH  //320
            }
        }
    }
    
    
    var tagDic:NSDictionary?
    
    /// 图片上的标记
    var tag:String?{
        didSet{
            if(tag != nil)
            {
                tagDic = NSDictionary()
                let stringData = tag!.dataUsingEncoding(NSUTF8StringEncoding)
                let dic = try! NSJSONSerialization.JSONObjectWithData(stringData!, options: .AllowFragments) as! NSArray
                tagDic = dic[0] as? NSDictionary
            }
        }
    }
    
    class func createPicArray(picData:NSArray) -> [UserRecommendPicModel]{
    
        var picArray = [UserRecommendPicModel]()
        
        
        for var i = 0; i < picData.count ; i++
        {
            let picObj = picData[i]
            
            let picModel = UserRecommendPicModel()
            
            picModel.url = picObj.objectForKey("url") as? String
            picModel.tag = picObj.objectForKey("tags") as? String
            picModel.width = picObj.objectForKey("width") as? CGFloat
            picModel.height = picObj.objectForKey("height") as? CGFloat
            picArray.append(picModel)
        }
        
        
        return picArray
        
    }
    
}

/// 一些配置 浏览次数 评论人数等等
class UserRecommendDynamic {
 /// 浏览次数
    var lookHistoryCount:String?
 /// 评论次数
    var commentCount:String?
 /// 喜欢人数
    var likesCount:String?
 /// 是否收藏
    var is_collect:Bool?
 /// 是否评论
    var is_comment:Bool?
    
    class func createUserRecommendDynamic(dynamicDict:NSDictionary) -> UserRecommendDynamic{
        
        let dynamicModel = UserRecommendDynamic()
        dynamicModel.lookHistoryCount = dynamicDict.objectForKey("views") as? String
        dynamicModel.commentCount = dynamicDict.objectForKey("comments") as? String
        dynamicModel.likesCount = dynamicDict.objectForKey("likes") as? String
        dynamicModel.is_collect = dynamicDict.objectForKey("is_collect") as? Bool
        dynamicModel.is_comment = dynamicDict.objectForKey("is_comment") as? Bool
        
        return dynamicModel
    }
    
}

/// 用户推荐的商品model

class UserRecommendProductModel {
    var id:String?
    var title:String?
    var price:String?
    var url:String?
    var platform:String?
    var picUrl:String?
    var isCollect = false
    
    class func createProductArray(productData:NSArray) -> [UserRecommendProductModel]
    {
        var productArr = [UserRecommendProductModel]()
        for var i = 0;i < productData.count ;i++
        {
            let productObj = productData[i]
            let productModel = UserRecommendProductModel()
            productModel.id = productObj.objectForKey("id") as? String
            productModel.title = productObj.objectForKey("title") as? String
            productModel.price = productObj.objectForKey("price") as? String
            productModel.url = productObj.objectForKey("url") as? String
            productModel.platform = productObj.objectForKey("platform") as? String
            productModel.picUrl = productObj.objectForKey("pic") as? String
            
            productArr.append(productModel)
        }
        return productArr
    }
}



class Author {
 /// 用户ID
    var user_id:String?
 /// 昵称
    var nickName:String?
 /// 头像url
    var headerImageUrl:String?
 /// 是不是2B小编
    var is_official:Int?
    
    
    class func createAutor(authorDict:NSDictionary) -> Author{
        let author = Author()
        author.user_id = authorDict.objectForKey("user_id") as? String
        author.nickName = authorDict.objectForKey("nickname") as? String
        author.headerImageUrl = authorDict.objectForKey("avatar") as? String
        author.is_official = authorDict.objectForKey("is_official") as? Int
    
        return author
    }
}









