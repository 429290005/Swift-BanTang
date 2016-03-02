//
//  PlantGrassTeamModel.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/20.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class PlantGrassTeamModel: NSObject {
    var teamID: String?
    var teamName: String?
    
    //首页显示的是  第二张图片
    var pic1: String?
    var pic2: String?
    var pic3: String?
    

 /// 浏览次数
    var lookCount: Int?
 /// 喜欢次数
    var likeCount: Int?
 /// 帖子数量
    var postsCount: Int?
 /// 详情描述
    var teamDetail: String?
    
    //从 json 中读取数据 并返回 listdata
   class func readfromJSON() -> NSArray{
        let path = NSBundle.mainBundle().pathForResource("种草小分队", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let dict = Dict.objectForKey("data") as! NSDictionary
        let listData = dict.objectForKey("list") as! NSArray
        return listData
    }
    
    class func readTeamData() -> [PlantGrassTeamModel]{
        var teamArray = [PlantGrassTeamModel]()
        let listData = PlantGrassTeamModel.readfromJSON()
        for var i = 0 ; i < listData.count ; i++ {
            let modelData = listData[i] as! NSDictionary
            let model = PlantGrassTeamModel()
            model.teamID = modelData.objectForKey("id") as? String
            model.teamName = modelData.objectForKey("name") as? String
            model.pic1 = modelData.objectForKey("pic1") as? String
            model.pic2 = modelData.objectForKey("pic2") as? String
            model.pic3 = modelData.objectForKey("pic3") as? String
            
            model.teamDetail = modelData.objectForKey("desc") as? String
            
            let dynamicData = modelData.objectForKey("dynamic") as! NSDictionary
            model.lookCount = dynamicData.objectForKey("views") as? Int
            model.likeCount = dynamicData.objectForKey("attentions") as? Int
            model.postsCount = dynamicData.objectForKey("posts") as? Int
        
            teamArray.append(model)
        }
        
        return teamArray
    }
    
}

class PlantGrassModel: PlantGrassTeamModel {
    //作者
    var author: Author?
    //关注者
    var attentionUsers: [Author]?
    
    var postList: [PostModel]?
    
    //从 json 中读取数据
    class func readFromJSON() -> NSDictionary {
        let path = NSBundle.mainBundle().pathForResource("深夜图书馆", ofType: nil)
        let nsData = NSData(contentsOfFile: path!)
        /// json整体转换为字典
        let Dict = ( try! NSJSONSerialization.JSONObjectWithData(nsData!, options:.AllowFragments) ) as! NSDictionary
        let dict = Dict.objectForKey("data") as! NSDictionary
        return dict
    }
    
    class func createPlantGrassModel() -> PlantGrassModel {
        
        
        let dict = PlantGrassModel.readFromJSON()
        let model = PlantGrassModel()
        
        // tableHeaderView 信息
        let infoData = dict.objectForKey("info") as! NSDictionary
        model.teamID = infoData.objectForKey("id") as? String
        model.teamName = infoData.objectForKey("name") as? String
        model.pic1 = infoData.objectForKey("pic1") as? String
        model.pic2 = infoData.objectForKey("pic2") as? String
        model.pic3 = infoData.objectForKey("pic3") as? String
        model.teamDetail = infoData.objectForKey("desc") as? String
        
        let authorData = infoData.objectForKey("author") as! NSDictionary
        model.author = Author.createAutor(authorData)
        
        //关注者
        let attentionData = infoData.objectForKey("attention_users") as! NSArray
        model.attentionUsers = [Author]()
        for var i = 0 ; i < attentionData.count ; i++ {
            let modelData = attentionData[i] as! NSDictionary
            let user = Author.createAutor(modelData)
            model.attentionUsers?.append(user)
        }
        
        //帖子
        let postData = dict.objectForKey("post_list") as! NSArray
        model.postList = PostModel.createPostModel(postData)
    
        return model
    }
}

class PostModel: NSObject {
    var id: String?
    var title: String?
    var content: String?
    var author_id: String?
    //  作者
    var author: Author?
    //  标签
    var tagsArray: [UserRecommendTags]?
    //  商品
    var productArray: [UserRecommendProductModel]?
    //  图片
    var picArray: [UserRecommendPicModel]?
    
    var praisesCount: String?
    var lookCount: String?
    var commentCount: String?
    var likesCount: String?
    
    var is_collection: Bool?
    var is_comment: Bool?
    //  评论
    var commentArray: [CommentModel]?
    //  分享链接
    var shareUrl: String?
    
    
    class func createPostModel(postListData:NSArray) -> [PostModel] {
        var postArray = [PostModel]()
    
        for var i = 0; i < postListData.count ; i++ {
            let modelData = postListData[i] as! NSDictionary
            let model = PostModel()
            model.id = modelData.objectForKey("id") as? String
            model.title = modelData.objectForKey("title") as? String
            model.content = modelData.objectForKey("content") as? String
            model.author_id = modelData.objectForKey("author_id") as? String
        
            //标签 
            let tagData = modelData.objectForKey("tags") as? NSArray
            model.tagsArray = UserRecommendTags.createTagArray(tagData!)
            
            //图片
            let picData = modelData.objectForKey("pics") as! NSArray
            model.picArray = [UserRecommendPicModel]()
            for var i = 0; i < picData.count ; i++ {
                let picObj = picData[i] as! NSDictionary
                let picModel = UserRecommendPicModel()
                picModel.url = picObj.objectForKey("url") as? String
                picModel.tag = picObj.objectForKey("tags") as? String
                picModel.width = picObj.objectForKey("width") as? CGFloat
                picModel.height = picObj.objectForKey("height") as? CGFloat
                model.picArray?.append(picModel)
            }
            
            //赞 浏览次数 喜欢次数 是否收藏 是否评论
            let dynamicData = modelData.objectForKey("dynamic") as! NSDictionary
            model.praisesCount = dynamicData.objectForKey("praises") as? String
            model.lookCount = dynamicData.objectForKey("views") as? String
            model.commentCount = dynamicData.objectForKey("comments") as? String
            model.likesCount = dynamicData.objectForKey("likes") as? String
            model.is_collection = dynamicData.objectForKey("is_collect") as? Bool
            model.is_comment = dynamicData.objectForKey("is_comment") as? Bool
            
            //商品数组
            let productData = modelData.objectForKey("product") as! NSArray
            model.productArray = UserRecommendProductModel.createProductArray(productData)
            
            //作者
            let authorData = modelData.objectForKey("author") as! NSDictionary
            model.author = Author.createAutor(authorData)
            
            //分享链接
            model.shareUrl = modelData.objectForKey("share_url") as? String
            
            //评论
            let commentData = modelData.objectForKey("comments") as! NSArray
            model.commentArray = CommentModel.createCommentList(commentData)
        
            postArray.append(model)
        }
        return postArray
    }
    
    
}








