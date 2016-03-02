//
//  ProductBuyViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/25.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class ProductBuyViewController: UIViewController {
    /// url
    var productUrl:String?{
        didSet{
            showWebView = UIWebView.init(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
            if(productUrl != nil)
            {
                let urlRequest = NSURLRequest.init(URL: NSURL(string: productUrl!)!)
                showWebView.loadRequest(urlRequest)
            }
            view.addSubview(showWebView)
        
        }
    
    }
    
    var showWebView = UIWebView()

    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = CustomBarTintColor
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    
    }

    
}
