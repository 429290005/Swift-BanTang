//
//  DrawLine.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/28.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit


enum DrawType{
    /// 实线
    case RealLine
    /// 虚线
    case DottedLine
    /// 折线
    case BrokenLine
}

class DrawLine: UIView {
    
    private var drawType:DrawType?
    
    //虚线
    private var lineRect:CGRect?

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if(drawType == DrawType.RealLine)
        {
        
        }else if(drawType == DrawType.DottedLine)
        {
            drawDottedLine()
        }else if(drawType == DrawType.BrokenLine)
        {
        
        
        }
        
    }
    
    
    //虚线
    func drawDottedLine()
    {
        let dottedLineLayer = CAShapeLayer()
        
        //绘制路径
        let path = CGPathCreateMutable()
        dottedLineLayer.fillColor = UIColor.clearColor().CGColor
        dottedLineLayer.strokeColor = GrayLineColor.CGColor
        dottedLineLayer.lineWidth = frame.height
        
        let shapeArr = NSArray(objects: NSNumber(int: 1),NSNumber(int: 1))
        dottedLineLayer.lineDashPattern = shapeArr as? [NSNumber]
        
        CGPathMoveToPoint(path, nil, frame.origin.x, 0)

        CGPathAddLineToPoint(path, nil, frame.origin.x+frame.width, 0)

        dottedLineLayer.path = path
        self.layer.addSublayer(dottedLineLayer)
    }
    
    //折线  app中 清单->用户推荐 ->点击商品图片的时候  会出现画折线的动画
    func createBrokenLine(titleDic:NSDictionary)
    {
        //1.计算绘制路径点
            //-- 1 中心点
        
        ////////////此处遇到的问题: json 字符串中 对应的 x 和 y 有时候是字符串，有时候是 CGFloat类型 ，所以此处需要判断
        
        
        
        
        var center_Xstr:CGFloat = 0.0
        if let result = titleDic.objectForKey("x") as? CGFloat
        {
            center_Xstr = result
        }else if let result = titleDic.objectForKey("x") as? String
        {
            center_Xstr = CGFloat( NSString(string: result).doubleValue )
        }
        
        let center_X = center_Xstr * frame.size.width

        var center_Ystr:CGFloat = 0.0
        if let result = titleDic.objectForKey("y") as? CGFloat
        {
            center_Ystr = result
        }else if let result = titleDic.objectForKey("y") as? String
        {
            center_Ystr = CGFloat( NSString(string: result).doubleValue )
        }
        
        let center_Y = center_Ystr * frame.size.height
        
        let centerPoint =  CGPointMake( center_X , center_Y)
        //中心点处的小圆点
        let centerView = UIView.init(frame: CGRectMake(12, 12, 16.0, 16.0))
        centerView.center = centerPoint
        centerView.layer.cornerRadius = 8.0
        addSubview(centerView)
    
            //-- 2 上方两个点
        let topPoint_1 = CGPointMake(center_X - 18, center_Y - 40)
        let topPoint_2 = CGPointMake(center_X - 42, center_Y - 40)

            //-- 3 右侧一个点
        let rightPoint = CGPointMake(center_X + 22, center_Y)
            //-- 3 下方两个点
        let bottomPoint_1 = CGPointMake(center_X - 18, center_Y + 40)
        let bottomPoint_2 = CGPointMake(center_X - 42, center_Y + 40)
        
        //2.绘制路径
        let drawLayer = CAShapeLayer()
        
        let path = CGPathCreateMutable()
        drawLayer.fillColor = UIColor.clearColor().CGColor
        drawLayer.strokeColor = UIColor(hexString: "000000").CGColor
        drawLayer.lineWidth = 1.0
        
        let shapeArr = NSArray(objects: NSNumber(int: 10),NSNumber(int: 0))
        drawLayer.lineDashPattern = shapeArr as? [NSNumber]
        
        
        if let text1 = titleDic.objectForKey("text1") as? String {
            addSubview(titleLabel(text1, SidePoint: topPoint_2, type: 2))
            CGPathMoveToPoint(path, nil, center_X, center_Y)
            //画上方
            MoveAndDrawLine(path, endPoint: topPoint_1)
            MoveAndDrawLine(path, endPoint: topPoint_2)
        }
        
        
        if let text2 = titleDic.objectForKey("text2") as? String {
            addSubview(titleLabel(text2, SidePoint: rightPoint, type: 1))
            //点移动到中心 继续画右侧
            CGPathMoveToPoint(path, nil, center_X, center_Y)
            
            MoveAndDrawLine(path, endPoint: rightPoint)
        }
        
        
        
        if let text3 = titleDic.objectForKey("text3") as? String
        {
            addSubview(titleLabel(text3, SidePoint: bottomPoint_2, type: 2))
            //点移动到中心 画左侧
            CGPathMoveToPoint(path, nil, center_X, center_Y)
            MoveAndDrawLine(path, endPoint: bottomPoint_1)
            MoveAndDrawLine(path, endPoint: bottomPoint_2)
        }
        
        drawLayer.path = path
        layer.addSublayer(drawLayer)
        
    }
    
    //划线 并且 移动点
    func MoveAndDrawLine(path:CGMutablePath,endPoint:CGPoint){

        //划线
        CGPathAddLineToPoint(path, nil, endPoint.x , endPoint.y)
        //点移动到结束的位置
        CGPathMoveToPoint(path, nil, endPoint.x, endPoint.y)
    }
    
    
    /**
     返回一个右边框被裁剪的圆角label
     
     - parameter title:          title
     - parameter rightSidePoint: 右边边界点
     
     - returns: 右边框被裁剪的圆角label
     */
    //根据point加载label
    func titleLabel(title:String,SidePoint:CGPoint,type:Int) -> UILabel
    {
        let label = UILabel.init()
        label.text = title
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(11.0)
        label.backgroundColor = UIColor(hexString: "000000", alpha: 0.6)
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.sizeToFit()
        
        
        var rect = CGRectZero
//        let path = CGPathCreateMutable()
//        let drawSideLayer = CAShapeLayer()
//        drawSideLayer.fillColor = UIColor.clearColor().CGColor
//        drawSideLayer.strokeColor = UIColor(hexString: "000000").CGColor
//        drawSideLayer.lineWidth = 1.0
//        
//        let shapeArr = NSArray(objects: NSNumber(int: 10),NSNumber(int: 0))
//        drawSideLayer.lineDashPattern = shapeArr as? [NSNumber]
        
        if(type == 1)
        {
            //边界点在左侧
            
            rect = CGRectMake(SidePoint.x, SidePoint.y - (label.frame.height+14)/2, label.frame.width+34, label.frame.height+14)
            
//            CGPathMoveToPoint(path, nil, SidePoint.x, SidePoint.y)
//            MoveAndDrawLine(path, endPoint: CGPointMake(SidePoint.x + 10, SidePoint.y - rect.height/2))
//            MoveAndDrawLine(path, endPoint: CGPointMake(SidePoint.x + rect.width - 20, SidePoint.y - rect.height/2))
//            
//            MoveAndDrawLine(path, endPoint: CGPointMake(SidePoint.x + rect.width - 10, SidePoint.y + rect.height/2))
//            MoveAndDrawLine(path, endPoint: CGPointMake(SidePoint.x + 10, SidePoint.y + rect.height/2))
//            MoveAndDrawLine(path, endPoint: SidePoint)
//            
//            drawSideLayer.path = path
//            label.layer.mask = drawSideLayer
////            label.layer.addSublayer(drawSideLayer)
            
        }else if(type == 2)
        {
            //边界点在右侧
            rect = CGRectMake(SidePoint.x - label.frame.width - 34, SidePoint.y - 7, label.frame.width+34, label.frame.height+14)
        }
        label.frame = rect
        
        //如果 label 超出屏幕了，就缩小字体
        if(CGRectGetMaxX(label.frame) > SCREEN_WIDTH)
        {
            label.font = UIFont.systemFontOfSize(8.0)
            label.sizeToFit()
            label.frame = CGRectMake(SidePoint.x, SidePoint.y - (label.frame.height + 10)/2, label.frame.width+20, label.frame.height+10)
            label.layer.cornerRadius = 2.0
        }else if(label.frame.origin.x < 0)
        {
            label.font = UIFont.systemFontOfSize(8.0)
            label.sizeToFit()
            label.frame = CGRectMake(SidePoint.x - label.frame.width - 10, SidePoint.y - 5, label.frame.width+10, label.frame.height+10)
            label.layer.cornerRadius = 2.0
        }
    
        return label
    }
    
    
    /**
     画出 虚线
     
     - parameter drawType: 线的类型
     - parameter lineRect: 线的frame
     
     - returns: 返回包含线段的view
     */
    class func createLine(drawType:DrawType,lineRect:CGRect) -> DrawLine
    {
        let line = DrawLine.init(frame: lineRect)
        line.backgroundColor = UIColor.clearColor()
        line.lineRect = lineRect
        line.drawType = drawType
        
        return line
    }
    
    
    
    
    /**
     在view上，画出折线
     
     - parameter drawType:    线的类型
     - parameter contentView: 所在的view上
     - parameter titleArray:  线的末端显示title
     */
    class func createLineInView(drawType:DrawType,contentView:UIView,titleDic:NSDictionary){
        let lineView = DrawLine.init(frame: contentView.frame)
        lineView.backgroundColor = UIColor.clearColor()
        lineView.createBrokenLine(titleDic)
        contentView.addSubview(lineView)
        
    }
    
    
}
