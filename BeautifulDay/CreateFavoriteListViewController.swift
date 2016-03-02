//
//  CreateFavoriteListViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/26.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class CreateFavoriteListViewController: BaseViewController,UITextViewDelegate {
    
    private var titleTextField = UITextField()
    private var descriptionTextView = UITextView()
    private var tipLabel = UILabel()
    private var tip1Label = UILabel()
    private var placeLabel = UILabel()
    
    override init(leftTitle: String, rightTitle: String) {
        super.init(leftTitle: leftTitle, rightTitle: rightTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:Build UI
    func buildUI()
    {
        title = "编辑心愿单 "
        
        titleTextField = UITextField.init(frame: CGRectMake(114/2, 0, SCREEN_WIDTH-114/2, 44))
        titleTextField.placeholder = "请填写亲的心愿单哦(填了我也不给你买)"
        titleTextField.font = UIFont.systemFontOfSize(15.0)
        titleTextField.textColor = MainTitleColor
        view.addSubview(titleTextField)
        
        tipLabel = UILabel.init(frame: CGRectMake(0, 0, 114/2, 44))
        tipLabel.text = "标题"
        tipLabel.font = UIFont.systemFontOfSize(15.0)
        tipLabel.textColor = GrayLineColor
        tipLabel.textAlignment = .Center
        view.addSubview(tipLabel)
        
        
        tip1Label = UILabel.init(frame: CGRectMake(0,44, 114/2, 44))
        tip1Label.text = "描述"
        tip1Label.font = UIFont.systemFontOfSize(15.0)
        tip1Label.textColor = GrayLineColor
        tip1Label.textAlignment = .Center
        view.addSubview(tip1Label)
        
        //placeLabel 实现 descriptionTextView 的placeHolder功能
        placeLabel = UILabel.init(frame: CGRectMake(114/2, 44+12, 114/2, 15))
        placeLabel.text = "给心愿单添加描述"
        placeLabel.sizeToFit()
        placeLabel.layer.zPosition = 2.0
        placeLabel.font = UIFont.systemFontOfSize(15.0)
        placeLabel.textColor = GrayLineColor
        view.addSubview(placeLabel)
        
        
        
        descriptionTextView = UITextView.init(frame: CGRectMake(114/2, 44+10, SCREEN_WIDTH-114/2, 150))
        descriptionTextView.delegate = self
        descriptionTextView.textColor = MainTitleColor
        view.addSubview(descriptionTextView)
        
        
        //分割线
        let topLine = UIView.init(frame: CGRectMake(0, 44, SCREEN_WIDTH, 1.0))
        topLine.backgroundColor = GrayLineColor
        view.addSubview(topLine)
        let bottomLine = UIView.init(frame: CGRectMake(0, 44+150, SCREEN_WIDTH, 1.0))
        bottomLine.backgroundColor = GrayLineColor
        view.addSubview(bottomLine)
        
        
    }
    
    func checkInputLegal() -> Bool
    {
        if(titleTextField.text?.characters.count == 0)
        {
            TipView.showMessage("请输入标题,嗯哼啊哈")
            return false
        }else if(descriptionTextView.text.characters.count == 0)
        {
            TipView.showMessage("亲，好歹写点东西嘛😊")
            return false
        }
        return true
    }
    
    //MARK: navigationItem bar  OK / Cancel
    
    override func barCancel()
    {
    
        
        super.barCancel()
    }
    override func barOK(){
        
        if(checkInputLegal())
        {
            //将标题存到 myfavorite中
            MyFavoriteList.append(titleTextField.text!)
            
            super.barOK()
        }
        
    }
    
    //MARK:textViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        if(textView.text.characters.count == 0)
        {
            placeLabel.text = "给心愿单添加描述"
        }else{
            placeLabel.text = ""
        }
    }
}
