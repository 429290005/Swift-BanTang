//
//  CommentViewController.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/27.
//  Copyright © 2016年 jiachen. All rights reserved.
//  评论ViewController

import UIKit

class CommentViewController: BaseViewController,UITextViewDelegate {

    var commentTextView = UITextView()
    var placeHolderlabel = UILabel()
    
    
    override init(leftTitle: String, rightTitle: String) {
        super.init(leftTitle: leftTitle, rightTitle: rightTitle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:BUILD UI
    func buildUI()
    {
        commentTextView = UITextView.init(frame: CGRectMake(5, 8, SCREEN_WIDTH-10, 500))
        commentTextView.layer.cornerRadius = 3.0
        commentTextView.layer.borderColor = LightLineColor.CGColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.delegate = self
        commentTextView.font = UIFont.systemFontOfSize(15.0)
        commentTextView.textColor = MainTitleColor
        view.addSubview(commentTextView)
        
        
        //placeHolderLabel 模拟placrHolder
        placeHolderlabel = UILabel.init(frame:CGRectMake(6, 16, 60, 15.0))
        placeHolderlabel.text = "写评论👍"
        placeHolderlabel.textColor = GrayLineColor
        placeHolderlabel.sizeToFit()
        view.addSubview(placeHolderlabel)
        

    }
    
    override func barOK() {
        if(checkInputLegal())
        {
            //先弹出键盘
            commentTextView.resignFirstResponder()
            super.barOK()
        }
    }
    
    override func barCancel() {
        commentTextView.resignFirstResponder()
        super.barCancel()
    }
    //MARK:view did/will/diddis....
    override func viewDidLoad() {
        view.backgroundColor = ViewGrayBackGroundColor
        title = "发表评论"
        buildUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        commentTextView.becomeFirstResponder()
    }
    
    
    //MARK:检查输入是否合法
    func checkInputLegal() -> Bool{
        if(commentTextView.text.characters.count == 0)
        {
            TipView.showMessage("写点东西再走呗😏")
            return false
        }
        return true
    }
    
    //MARK:UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if(textView.text.characters.count == 0)
        {
            placeHolderlabel.text = "写评论👍"
        }else{
            placeHolderlabel.text = ""
        }
    }
}
