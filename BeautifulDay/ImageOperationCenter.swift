//
//  ImageOperationCenter.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/22.
//  Copyright © 2016年 jiachen. All rights reserved.
//  图片处理中心

import UIKit
import Accelerate.vImage

class ImageOperationCenter: NSObject {

    
    //利用 core Image做高斯模糊处理，， 耗时！！！！
    class func GaussianBlurWithCoreImage(imgView:UIImageView) {
        var image = imgView.image
        let context = CIContext(options: nil)
        
        //滤镜效果
        let filter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image!)
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        filter?.setValue(8.0, forKey: "inputRadius")
        
        let result = filter?.valueForKey(kCIOutputImageKey) as! CIImage
        let outImage = context.createCGImage(result, fromRect: result.extent)
        image = UIImage(CGImage: outImage)
        
        imgView.image = image
    }
    
//    class func GaussianBlurWithVImage(imgView:UIImageView) {
//        var image = imgView.image
//        
//        
//    
//    }
    
    // 图片 按比例缩放  缩放比例 按照 图片最接近理想宽度 那条边
    /**
    图片 按比例缩放
    
    - parameter image:     输入图片
    - parameter goalWidth: 目标缩放宽度
    
    - returns: 输出图片
    */
    class func ScaleImage(image: UIImage,goalWidth: CGFloat) -> UIImage{
    
        var scale: CGFloat = 0.0
        if goalWidth - image.size.width > goalWidth - image.size.height {
            //宽度 《 高度
            scale = goalWidth / image.size.width
            
        }else {
            scale = goalWidth / image.size.height
            
        }
        let goalSize = CGSizeMake(scale * image.size.width, scale * image.size.height)
        
        UIGraphicsBeginImageContext(goalSize)
        image.drawInRect(CGRectMake(0, 0, goalSize.width, goalSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // 图片大小是 60 * 60 的  不用再次修改大小
    class func HeaderImageOperation( image: UIImage,borderColor: UIColor,borderWidth: CGFloat) -> UIImage {
        
        
        //开启上下文
        let sizeImage = image.size
        
        
        
        UIGraphicsBeginImageContextWithOptions(sizeImage, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        //画边框  大圆
        borderColor.set()
        CGContextAddArc(ctx, image.size.width/2, image.size.height/2, image.size.height/2, 0, CGFloat(M_PI * 2.0) , 0)
        CGContextFillPath(ctx)
        
        //画小圆
        CGContextAddArc(ctx, image.size.width/2, image.size.width/2, image.size.width/2 - borderWidth, 0, CGFloat(M_PI * 2.0), 0)
        CGContextClip(ctx)
        
        //画图
        image.drawInRect(CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height))
        
        //取图
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //结束上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // 从相机拍照  后修改
    class func HeaderImageFromCamera(image: UIImage,borderColor: UIColor,borderWidth: CGFloat) -> UIImage {
        //开启上下文
        let sizeImage = image.size
        
        
        
        UIGraphicsBeginImageContextWithOptions(sizeImage, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        //画边框  大圆
        borderColor.set()
        CGContextAddArc(ctx, image.size.width/2, image.size.height/2, 30, 0, CGFloat(M_PI * 2.0) , 0)
        CGContextFillPath(ctx)
        
        //画小圆
        CGContextAddArc(ctx, image.size.width/2, image.size.width/2, 30 - borderWidth, 0, CGFloat(M_PI * 2.0), 0)
        CGContextClip(ctx)
        
        //画图
        image.drawInRect(CGRectMake(30+borderWidth, 30+borderWidth, 60, 60))
        
        //取图
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //结束上下文
        UIGraphicsEndImageContext()
        
        return newImage
    
    
    }
}


