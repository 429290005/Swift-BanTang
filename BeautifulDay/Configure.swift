//
//  Configure.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/14.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

//MARK:app启动图片
public let app_startImageUrl = NSURL(string: "http://7xiwnz.com2.z0.glb.qiniucdn.com/newyear.jpg")


public let NavigationH: CGFloat = 64
public let SCREEN_WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width
public let SCREEN_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height
public let MainBounds: CGRect = UIScreen.mainScreen().bounds



//app中所用到的字体
//enum AppFont: String{
//    case Ultralight = "PingFangSC-Ultralight"
//    case Regular    = "PingFangSC-Regular"
//    case Semibold   = "PingFangSC-Semibold"
//    case Thin       = "PingFangSC-Thin"
//    case Light      = "PingFangSC-Light"
//    case Medium     = "PingFangSC-Medium"
//}
public let ThinFont:String = "PingFangSC-Thin"
public let LightFont:String = "PingFangSC-Light"
public let RegularFont:String = "PingFangSC-Regular"

//MARK:文字颜色，背景颜色

public let CustomBarTintColor = UIColor(hexString: "EC5252")
public let MainTitleColor:UIColor = UIColor.init(red: 109/255.0, green: 109/255.0, blue: 109/255.0, alpha: 1.0)
public let SubTitleColor:UIColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
public let LightLineColor:UIColor = UIColor.init(hexString: "F9F9F9")
public let GrayLineColor:UIColor = UIColor.init(hexString: "D8D8D8")
public let TitleGrayCorlor:UIColor = UIColor(hexString: "A7A7A7")
/// textView/textfield placeHolder titleColor
public let PlaceHolderColor:UIColor = UIColor(hexString: "B6B6B6")
 /// view灰色背景
public let ViewGrayBackGroundColor = UIColor(hexString: "F5F5F5")
/// 文字半黑色
public let HalfBlackTitleColor:UIColor = UIColor(hexString: "959595")

public var MyFavoriteList = Array() as [String]
public var RecommendList = Array() as [String]

///分割线的 cell 背景颜色
public let CellSeparatotBackColor:UIColor = UIColor(hexString: "EEEEEE")
/// cell 中 商品价格，喜欢人数标签的背景颜色
public let TagBackOrangeColor:UIColor = UIColor(hexString: "FFA429")


//MARK:淘宝，京东，亚马逊 icon

//platform = 0  淘宝
public let icon_tabbaoURl = NSURL(string: "http://7viiaj.com2.z0.glb.qiniucdn.com/shop/taobao-order.png?v=1")

//platform = 0  京东
public let icon_JDURl = NSURL(string: "http://7viiaj.com2.z0.glb.qiniucdn.com/shop/jd-order.png?v=1")

//platform = 0  亚马逊
public let icon_AmazonURl = NSURL(string: "http://7viiaj.com2.z0.glb.qiniucdn.com/shop/z-order.png?v=1")



//MARK:友盟分享 sdk
public let UMSocialShareKey:String = "56aeb312e0f55a035e000fae"


//MARK: 通知中心
/// 用户有新的消息
public let UserHasNewMessage:String = "UserHasNewMessage"

//MARK: 用户信息中心
/// 用户积分
public let UserPoint: String = "199999.8"
/// 朋友姓名
public let UserFriendName = ["ManoBoo","一号","花","维尼的小熊","涛涛","康康","璐璐"]
/// 盆友介绍
public let UserFriendWord = ["这是我的昵称啦~😄","这是我的好基友1","这是我的好基友2","这是我的老师啦，师从其门下","草丛三基友1","草丛三基友2","草丛三基友3"]
/// 用户性别
public var UserSex: String = "帅哥"


//MARK: 分享所用到的一些链接

public let MyIntroduce: String = "  你好，我是ManoBoo\n很高兴能在这里遇到你😊,遇到什么问题或者bug您可以联系我的QQ、微博及简书,Boo诚意敬上~~"
public let JianShuURL: String = "http://www.jianshu.com/p/7b57eb0c4abe"
public let GitHubURL: String = "https://github.com/jiachenmu/Swift-BanTang"
public let SinaWeiBoURL: String = "http://weibo.com/u/3484140182"
public let ShareTitle: String = "Swift开源项目-高仿半糖APP"
public let ShareSubTitle: String = "ManoBoo非常感谢您的分享，喜欢的童鞋点一点star啦😘"

struct configure {
    
}