//
//  CMSearchBar.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/30.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit


//模仿搜索栏的几种状态
enum SearchBarStatus{
    /// 正常类型
    case NormalStatus
    /// 点击 searchBar 显示热词 和历史纪录
    case ShowSearchHotWordsStatus
}

class CMSearchBar: UIView ,UITextFieldDelegate{

    var font: UIFont?{
        didSet{
            textField.font = font
        }
    }
    var textColor = UIColor(){
        didSet{
            textField.textColor = textColor
        }
    }
    var placeHolder:String?{
        didSet{
            textField.placeholder = placeHolder
        }
    }
    
    //每次改变 textField 中 text 都会触发 clourse
    private var conText = 0
    var changetextfieldClourse: ( (text:String) -> () )?
    
    var textField = UITextField()
    private var iconImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame:CGRect,Font:UIFont,TextColor:UIColor,PlaceHolder:String?,HotWords:NSMutableArray?)
    {
        self.init(frame:frame)
        layer.borderColor = UIColor.clearColor().CGColor
        layer.cornerRadius = 3.0
        layer.borderWidth = 1.0
        backgroundColor = UIColor.whiteColor()
        buildSearchIcon()
        buildTextField(Font, Textcolor: TextColor, placeHolder: PlaceHolder)
        
    }
    
    func buildSearchIcon()
    {
        iconImgView = UIImageView.init(frame: CGRectMake(88/2, 29/2-12, 24, 24))
        iconImgView.image = UIImage(named: "iconfont-category")
        addSubview(iconImgView)
    }
    
    func buildTextField(fontSize:UIFont,Textcolor:UIColor,placeHolder:String?)
    {
        textField = UITextField.init(frame: CGRectMake(CGRectGetMaxX(iconImgView.frame)+2, 0, frame.width - 70, frame.height))
        textField.addTarget(self, action: "changeText", forControlEvents: UIControlEvents.EditingChanged)
        textField.placeholder = placeHolder
        textField.font = fontSize
        textField.textColor = Textcolor
        
        
        textField.delegate = self
        addSubview(textField)
    }
    
    //外界调用
    
    func cancelSearch()
    {
        textField.resignFirstResponder()
        
        weak var weakSelf = self
        
        UIView.animateWithDuration(0.3) { () -> Void in
            weakSelf!.frame = CGRectMake(weakSelf!.frame.origin.x, weakSelf!.frame.origin.y, 265, weakSelf!.frame.size.height)
            weakSelf!.iconImgView.center = CGPointMake(weakSelf!.iconImgView.center.x + 38, weakSelf!.iconImgView.center.y)
            weakSelf!.textField.center = CGPointMake(weakSelf!.textField.center.x + 38, weakSelf!.textField.center.y)
            weakSelf!.textField.text = ""
        }
    
    }
    
    //MARK:uitextfieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //view 左移
        weak var weakSelf = self
        UIView.animateWithDuration(0.3) { () -> Void in
            weakSelf!.frame = CGRectMake(weakSelf!.frame.origin.x, weakSelf!.frame.origin.y, 220, weakSelf!.frame.size.height)
            weakSelf!.iconImgView.center = CGPointMake(weakSelf!.iconImgView.center.x - 38, weakSelf!.iconImgView.center.y)
            weakSelf!.textField.center = CGPointMake(weakSelf!.textField.center.x - 38, weakSelf!.textField.center.y)
        }
    
        
     //加载热词 view
        
        return true
    }

    func changeText() {
        changetextfieldClourse!(text: textField.text!)
    }
    
}
