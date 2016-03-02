//
//  AppDelegate.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/13.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UITabBarControllerDelegate,WXApiDelegate {

    var window: UIWindow?
    var tabbarController:UITabBarController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)

       

        
        
        self.createTabBarController()
        
        
        
        self.configure()
        
        self.window?.rootViewController = mainViewController()
        self.window?.makeKeyAndVisible()
        
        //设置 友盟分享 sdk
        setUMSocialDataAppkey()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeRootViewController", name: DismissFirstViewController_Notification, object: nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


//MARK:创建tabbarController
    func createTabBarController()
    {
        self.tabbarController = UITabBarController.init()
        tabbarController.delegate = self
        
        //首页
        let homeVC = HomeViewController.init()
        homeVC.navigationController?.navigationBarHidden = true
        homeVC.tabBarItem = UITabBarItem.init(title: nil, image: UIImage(named: "Home_unselected"),selectedImage:UIImage(named:"Home_selected"))
        let homeNav = UINavigationController.init(rootViewController: homeVC)
        
        //广场
        let SquareVC = SquareViewController.init()
        SquareVC.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "Square_normal"), selectedImage: UIImage.init(named: "Square_selected"))
        let SquareNav = UINavigationController.init(rootViewController: SquareVC)
        
        
        //秀
        let showMeVC = UIViewController()
        showMeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Show_normal"), selectedImage: UIImage(named: "Show_normal"))
        let showMeNav = UINavigationController(rootViewController: showMeVC)
        
        //消息中心
        let messageCenterVC = MessageCenterViewController()
        messageCenterVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Message_normal"), selectedImage: UIImage(named: "Message_selected"))
        let messageCenterNav = UINavigationController(rootViewController: messageCenterVC)
        
        //个人中心
        let personCenterVC = PersonCenterViewController()
        personCenterVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "PersonCenter_unlogin"), selectedImage: UIImage(named: "PersonCenter_unlogin"))
        let personCenterNav = UINavigationController(rootViewController: personCenterVC)
        
        let viewControlersArr = NSArray.init(objects: homeNav,SquareNav,showMeNav,messageCenterNav,personCenterNav)
        self.tabbarController.tabBar.translucent = false

        self.tabbarController.viewControllers = viewControlersArr as! [UINavigationController]
        
        //设置主题色 为红色
        for var i = 0;i < tabbarController.viewControllers?.count;i++
        {
            let nav = tabbarController.viewControllers![i] as! UINavigationController
            nav.navigationBar.barTintColor = CustomBarTintColor
            nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            nav.navigationBar.translucent = false
        }
        
    }

//MARK:UITabBarControllerDelegate
    
     func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        
        let childArray = tabbarController.childViewControllers
        let index = childArray.indexOf(viewController)
        if index == 2 {
            print("Show me!")
            presentShowMeViewController(viewController)
            return false
        }else if index == 3 {
            //点击 '消息中心' 延迟5s 后发出通知
            //模拟网络刷新
            viewController.tabBarItem.title = nil
            postNotificationCenter(tabbarController.viewControllers!)
        }
        
        return true
    }
    
//弹出 ShowMeViewController
    func presentShowMeViewController(viewController:UIViewController) {
        let showMeVC = ShowMeViewController.init(leftTitle: "取消", rightTitle: "")
        let nav = BaseNavigationController(rootViewController: showMeVC)
        viewController.presentViewController(nav, animated: true, completion: nil)
    }
//MARK: 公共配置
    func configure()
    {
        MyFavoriteList = Array()
        MyFavoriteList.append("我的喜欢")
        
        RecommendList = Array()
        RecommendList.append("仅仅是好看就够了")
        RecommendList.append("我想要有个温馨的小窝")
        RecommendList.append("摆在家里一定很好看")
    }
//MARK: App首次启动显示 app的简介
    func mainViewController() -> UIViewController{
        //firstStart不为空,不是是第一次启动
        if  NSUserDefaults.standardUserDefaults().objectForKey("FirstStart") != nil {
            
            return self.tabbarController
        }else {
            //是第一次启动
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "FirstStart")
            let firstVC = FirstStartViewController()
            
            return firstVC
        }
    }
    //firstVC 点击 开启app之旅 按钮后发出通知 此处接收通知
    func changeRootViewController() {
        self.window!.rootViewController = self.tabbarController
    }
}


//友盟 appkey ->   56aeb312e0f55a035e000fae
extension AppDelegate{

    func setUMSocialDataAppkey()
    {
        
        UMSocialData.setAppKey(UMSocialShareKey)
        WXApi.registerApp("wx818610eb304dca09")
        print("用户是否注册成功： \(WXApi.registerApp("wx818610eb304dca09"))")
    }
}

//微信 wxapiDelegate
extension AppDelegate{

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
 
        print("用户是否安装微信：\(WXApi.handleOpenURL(url, delegate: self))")
        return WXApi.handleOpenURL(url, delegate: self)

    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

        return WXApi.handleOpenURL(url, delegate: self)
    }
}

//MARK: 模拟网络操作 给自己推送新的消息 等等
extension AppDelegate {
    func postNotificationCenter(viewControllers: [UIViewController]) {
        //延迟10秒  推送 消息
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: UserHasNewMessage, object: nil))
            let item = viewControllers[3].tabBarItem
            item.title = nil
            item.badgeValue = "NEW"
        })
    }

}


