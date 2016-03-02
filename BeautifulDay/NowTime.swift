//
//  NowTime.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/24.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class NowTime: NSObject {

    
    class func getNowtime() -> String{
        let date = "\(NSDate())" as NSString

        let str = date.substringToIndex(19)
        
        return str as String
    }
}
