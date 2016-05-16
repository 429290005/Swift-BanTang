//
//  TitleView.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/13.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

protocol TitleViewDelegate:NSObjectProtocol
{
    func TitleViewClick(titleVIew:TitleView,clickBtnIndex:Int)
}

class TitleView: UIScrollView {
    
    //默认文字 是两位
    private var textLength: CGFloat = 2.0
    
    //默认 button 的间隔
    private var buttonSpacing:CGFloat = 30
    
    private var titleArr = NSArray()
    private var normalColor = UIColor()
    private var highLightColor = UIColor()
    private var fontSize = CGFloat()
    var currentPage:Int = 0
    private var indicator = UIView()  //水平指示器
    weak var clickDelegate:TitleViewDelegate?
    
    convenience init(titleArr:NSArray,normalColor:UIColor,highlightColor:UIColor,fontSize:CGFloat)
    {
        
        self.init()
        self.titleArr = titleArr
        self.normalColor = normalColor
        self.highLightColor = highlightColor
        self.fontSize = fontSize
        
        self.createTitleLabel()
    }
    
    convenience init(titleArr:NSArray,normalColor:UIColor,highlightColor:UIColor,fontSize:CGFloat,textLength: CGFloat,buttonSpacing: CGFloat) {
        self.init()
        self.titleArr = titleArr
        self.normalColor = normalColor
        self.highLightColor = highlightColor
        self.fontSize = fontSize
        self.textLength = textLength
        self.buttonSpacing = buttonSpacing
        self.createTitleLabel()
    }
    
    private func createTitleLabel()
     {
        //创建文字button
        for(var index = 0;index < titleArr.count;index++)
        {
            //创建button 并且添加到 scrollview中
            let btn = UIButton(frame:CGRectMake(CGFloat(index)*textLength*fontSize+buttonSpacing*CGFloat(index)+12, 8, textLength*fontSize, fontSize+2))
            
            btn.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
            btn.setTitle(titleArr[index] as? String, forState: UIControlState.Normal)
            btn.tag = index+100
            btn.selected = btn.tag == 100 ? true:false
            btn.setTitleColor(self.normalColor, forState: UIControlState.Normal)
            btn.setTitleColor(self.highLightColor, forState: UIControlState.Selected)
            btn.addTarget(self, action: "changeCateGory:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(btn)
            
            
        }
        //设置分类的滑动范围
        self.contentSize = CGSizeMake(CGFloat(titleArr.count)*2*fontSize+CGFloat(titleArr.count-1)*30+24, 0)

        self.backgroundColor = UIColor.whiteColor()
        self.showsHorizontalScrollIndicator = false
        
        //create bottomView
        indicator = UIView.init(frame: CGRectMake(12, 34, fontSize * textLength, 2))
        indicator.layer.zPosition = 2
        indicator.backgroundColor = highLightColor
        currentPage = 0
        self.addSubview(indicator)
    }

    //这个方法提供给 HomeViewController
     func setBottomView(btnIndex:Int)
    {
        //将其他btn的selected状态设置为 false
        for  view in self.subviews
        {
            if(view.isKindOfClass(UIButton) && view.tag != btnIndex+100)
            {
               (view as! UIButton).selected = false
            }
        }

        let btn = self.viewWithTag(btnIndex+100) as? UIButton
        btn?.selected = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.indicator.center = CGPointMake(btn!.center.x, self.indicator.center.y)
            }) { (finished:Bool) -> Void in
                self.currentPage = btnIndex
                
                if( btnIndex > 1 && btnIndex < 11)
                {
                    //将指示器所指向的标签分类放置到屏幕中间
                    let width = (btn?.frame.origin.x)! - self.contentOffset.x
                    //要移动的距离
                    let needMoveWidth = width - SCREEN_WIDTH/2
                    
                    self.setContentOffset(CGPointMake(self.contentOffset.x+needMoveWidth, 0), animated: true)
                }
        }   }
    
//MARK:点击label 改变文字颜色，达到高亮效果
    func changeCateGory(sender:UIButton)
    {
        
        if(sender.selected == true)
        {
            //点击是的当前页面btn
            return
        }else
        {
            for view in self.subviews
            {
                //将其他btn.selected -> false
                if(view.isKindOfClass(UIButton) && view.tag != sender.tag)
                {
                    let unselectedBtn = view as? UIButton
                    unselectedBtn?.selected = false
                }
            }
            
            sender.selected = true
            //当前点击的btn.tag
            let clickIndex:Int = sender.tag-100
            //执行动画
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.indicator.center = CGPointMake((sender.center.x), self.indicator.center.y)
            })
            currentPage = clickIndex
            //执行代理 返回点击btn的tag
            clickDelegate?.TitleViewClick(self, clickBtnIndex: clickIndex)
        }
    }
}
