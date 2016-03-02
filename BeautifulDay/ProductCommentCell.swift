//
//  ProductCommentCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/18.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class ProductCommentCell: UITableViewCell {
 /// 头像
    private var headerImgView = UIImageView()
 /// 评论者
    private var commentAuthorLabel = UILabel()
    /// 历史纪录图标
    private var iconHistoryView = UIImageView()
 /// 评论时间
    private var commentTimeLabel = UILabel()
 /// 评论内容
    private var contentLabel = UILabel()
    /// 点赞按钮
    private var zanButton = UIButton()
    /// 评论详情
    private var model: CommentModel? {
        didSet{
            headerImgView.sd_setImageWithURL(NSURL(string: (model?.headerImageurl)!), placeholderImage: UIImage(named: "HeaderPlaceHolder"))
            commentAuthorLabel.text = model?.nickname
            commentAuthorLabel.sizeToFit()
            commentAuthorLabel.frame = CGRectMake(CGRectGetMaxX(headerImgView.frame) + 10, 18, commentAuthorLabel.frame.width, commentAuthorLabel.frame.height)
            
            commentTimeLabel.text = model?.createTime
            
            // 是否 评论是@ someone 的
            buildContentLabel()
            
            //是否已经赞过
            if model?.is_praise == true {
                zanButton.selected = true
            }
            zanButton.setTitle((model?.praiseCount)!, forState: .Normal)
            
            //是否 cell 创建过
//            if model?.cellHeight == nil {
                model?.cellHeight = CGRectGetMaxY(contentLabel.frame) + 25
//            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func buildUI(){
        headerImgView.frame = CGRectMake(10, 18, 30, 30)
        headerImgView.layer.cornerRadius = 15.0
        contentView.addSubview(headerImgView)
        
        commentAuthorLabel.font = UIFont.init(name: LightFont, size: 14.0)
        commentAuthorLabel.textColor = UIColor(hexString: "6AA4C1")
        contentView.addSubview(commentAuthorLabel)
        
        iconHistoryView.frame = CGRectMake(SCREEN_WIDTH - 253/2, 18, 10, 10)
        iconHistoryView.image = UIImage(named: "iconfont-lishi")
        contentView.addSubview(iconHistoryView)
        
        commentTimeLabel.frame = CGRectMake(CGRectGetMaxX(iconHistoryView.frame) + 5, 19, 124/2, 10)
        commentTimeLabel.font = UIFont(name: LightFont, size: 10.0)
        commentTimeLabel.textColor = UIColor(hexString: "DDDDDD")
        contentView.addSubview(commentTimeLabel)
        
        zanButton.frame = CGRectMake(CGRectGetMaxX(commentTimeLabel.frame) + 10 , 16, 34, 16)
        zanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0)
        zanButton.setImage(UIImage(named: "iconfont-icondianzan"), forState: .Normal)
        zanButton.setImage(UIImage(named: "iconfont-icondianzanhou"), forState: .Selected)
        zanButton.setTitle("0", forState: .Normal)
        zanButton.setTitleColor(SubTitleColor, forState: .Normal)
        zanButton.addTarget(self, action: "zanOrCancelZan:", forControlEvents: .TouchUpInside)
        contentView.addSubview(zanButton)
        
        contentView.addSubview(contentLabel)
    }
    
    func buildContentLabel() {
        var contentStr = "哈哈哈哈"
        //是否该评论是@某人的
        if model?.isAtSomeOne == true {
            print(" \( (model?.nickname)!) @ \( (model?.at_User?.nickName)! )")
            contentStr = "回复 @\( (model?.at_User?.nickName)! ): \( (model?.content)! )"
            let content = NSMutableAttributedString(string: contentStr)
            //添加 文字颜色
            content.addAttribute(NSForegroundColorAttributeName, value: SubTitleColor, range: NSMakeRange(0, contentStr.characters.count))
            let str = "@\( (model?.at_User?.nickName)! )"
            content.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "6AA4C1"), range: NSMakeRange(3, str.characters.count))
            //添加 字体
            content.addAttribute(NSFontAttributeName, value: UIFont(name: LightFont, size: 15.0)!, range: NSMakeRange(0, contentStr.characters.count))
            //添加行间距
            let style1 = NSMutableParagraphStyle.init()
            style1.lineBreakMode = NSLineBreakMode.ByWordWrapping
            style1.lineSpacing = 11.0
            content.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, contentStr.characters.count))
            contentLabel.attributedText = content
        }else{
            contentStr = "\( (model?.content)! )"
            let content = NSMutableAttributedString(string: contentStr)
            //添加 文字颜色
            content.addAttribute(NSForegroundColorAttributeName, value: SubTitleColor, range: NSMakeRange(0, contentStr.characters.count))
            //添加 字体
            content.addAttribute(NSFontAttributeName, value: UIFont(name: LightFont, size: 15.0)!, range: NSMakeRange(0, contentStr.characters.count))
            //添加行间距
            let style1 = NSMutableParagraphStyle.init()
            style1.lineBreakMode = NSLineBreakMode.ByWordWrapping
            style1.lineSpacing = 2.5
            content.addAttribute(NSParagraphStyleAttributeName, value: style1, range: NSMakeRange(0, contentStr.characters.count))
            
            contentLabel.attributedText = content
        }
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()
        contentLabel.frame = CGRectMake(commentAuthorLabel.frame.origin.x, 50, 510/2, contentLabel.frame.height)
        
    }
    
    //MARK: 赞或不赞
    func zanOrCancelZan(sender:UIButton) {
        
        var newPraiseCount = Int( (sender.titleLabel?.text)! )!
        if sender.selected == true {
            newPraiseCount--
            model?.praiseCount = "\(newPraiseCount)"
            sender.setTitle("\(newPraiseCount)", forState: .Normal)
        }else{
            newPraiseCount++
            model?.praiseCount = "\(newPraiseCount)"
            sender.setTitle("\(newPraiseCount)", forState: .Normal)
        }
        sender.selected = !sender.selected
        model?.is_praise = !(model?.is_praise)!
    }
    
    //MARK: 创建 cell
    static let cellID = "CommentCellIdentifier"
    class func productCommentCell(tableview:UITableView,Model:CommentModel) -> ProductCommentCell
    {
        var cell = tableview.dequeueReusableCellWithIdentifier(cellID) as? ProductCommentCell
        if cell == nil {
            cell = ProductCommentCell.init(style: .Default, reuseIdentifier: cellID)
        }
        cell!.model = Model
        
        return cell!
    }
}
