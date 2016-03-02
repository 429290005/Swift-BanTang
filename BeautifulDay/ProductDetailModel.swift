//
//  ProductDetailModel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/2.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class ProductDetailModel: ListDetailProduct {
    var comment_list: [CommentModel]?
    var share_URL:String?

    
    //此处商品中的喜欢列表与清单中的喜欢列表 属性不尽相同，所以重写
    var likeUser: [CommentUsers]?
    
    class func createProductDetailModel() -> ProductDetailModel
    {
        let path = NSBundle.mainBundle().pathForResource("stylenand 打底霜", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let data = Dict.objectForKey("data") as! NSDictionary
    
        let model = ProductDetailModel()
        model.productID = data.objectForKey("id") as? String
        model.likeNumbers = data.objectForKey("likes") as? String
        model.comments = data.objectForKey("comments") as? String
        model.isComments = data.objectForKey("iscomments") as? Bool
        
        let productObj = data.objectForKey("product") as! NSDictionary
        model.topic_id = productObj.objectForKey("topic_id") as? String
        model.productName = productObj.objectForKey("title") as? String
        model.category = productObj.objectForKey("category") as? String
        model.detailText = productObj.objectForKey("desc") as? String
        model.price = productObj.objectForKey("price") as? String
        model.productUrl = productObj.objectForKey("url") as? String
        model.platform = productObj.objectForKey("platform") as? String
        model.share_URL = productObj.objectForKey("sgare_url") as? String
        
        //商品图片
        model.picArray = [PicModel]()
        let picData = productObj.objectForKey("pic") as? NSArray
        for var i = 0 ; i < picData?.count ; i++ {
            let picObj = picData![i] as! NSDictionary
            let picModel = PicModel()
            //此处不存储 image 的高度和宽度了，因为 高度、宽度基本上都是 screen_width
            picModel.imageUrl = picObj.objectForKey("pic") as? String
            
            model.picArray?.append(picModel)
        }
        
        //评论列表
        let commentData = data.objectForKey("comment_list") as? NSArray
        model.comment_list = [CommentModel]()
        
        for var i = 0; i < commentData?.count ; i++ {
            let obj = commentData![i] as! NSDictionary
            let commentModel = CommentModel()
            commentModel.id = obj.objectForKey("id") as? String
            commentModel.user_id = obj.objectForKey("user_id") as? String
            commentModel.nickname = obj.objectForKey("nickname") as? String
            commentModel.headerImageurl = obj.objectForKey("avatar") as? String
            commentModel.content = obj.objectForKey("conent") as? String
            commentModel.createTime = obj.objectForKey("datestr") as? String
            commentModel.praiseCount = obj.objectForKey("praise") as? String
            commentModel.is_praise = obj.objectForKey("is_praise") as! Bool
            commentModel.is_hot = obj.objectForKey("is_hot") as! Bool
            commentModel.is_official = obj.objectForKey("is_official") as! Int
            
            let userData = obj.objectForKey("at_user") as? NSDictionary
            if userData?.count != 0 {
                //该评论是否 @某人
                commentModel.isAtSomeOne = true
            }
            let userModel = Author()
            userModel.user_id = userData?.objectForKey("user_id") as? String
            userModel.nickName = userData?.objectForKey("nickname") as? String
            userModel.headerImageUrl = userData?.objectForKey("avatar") as? String
            userModel.is_official = userData?.objectForKey("is_official") as? Int
            
            commentModel.at_User = userModel
        
            model.comment_list?.append(commentModel)
        }
        
        //喜欢列表
        let likeData = data.objectForKey("likes_list") as? NSArray
        model.likeUser = [CommentUsers]()
        for var i = 0 ;i < likeData?.count ; i++ {
            let obj = likeData![i] as! NSDictionary
            let likeModel = CommentUsers()
            likeModel.user_id = obj.objectForKey("user_id") as? String
            likeModel.nickname = obj.objectForKey("nickname") as? String
            likeModel.imageUrls = obj.objectForKey("avatar") as? String
        
            model.likeUser?.append(likeModel)
        
        }
        
        return model
    }
    
}



class CommentModel {
    var id:String?
    var user_id:String?
    var nickname:String?
    var headerImageurl:String?
    var content:String?
 /// 是否对某人回复
    var isAtSomeOne:Bool?
    
    var createTime:String?
 /// 赞的数量
    var praiseCount:String?
 /// 是否赞过
    var is_praise:Bool = false
 /// 是否热评
    var is_hot:Bool = false
 /// 是否2B小编
    var is_official:Int = 0
 /// 这人@的对象
    var at_User:Author?
    /// cell 自适应高度
    var cellHeight: CGFloat?
    
    class func createCommentList(commentData: NSArray) -> [CommentModel]
    {
        var commentArray = [CommentModel]()
        for var i = 0 ; i < commentData.count ; i++ {
            let commentObj = commentData[i] as! NSDictionary
            let model = CommentModel()
            model.id = commentObj.objectForKey("id") as? String
            model.user_id = commentObj.objectForKey("user_id") as? String
            model.nickname = commentObj.objectForKey("username") as? String
            model.headerImageurl = commentObj.objectForKey("avatar") as? String
            model.content = commentObj.objectForKey("content") as? String
            model.createTime = commentObj.objectForKey("datastr") as? String
            model.praiseCount = commentObj.objectForKey("praise") as? String
            model.is_praise = commentObj.objectForKey("is_praise") as! Bool
            
            commentArray.append(model)
        }
        return commentArray
    }
}

class CommentUsers: NSObject {
    var user_id: String?
    var nickname: String?
    var imageUrls: String?
}

