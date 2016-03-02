//
//  ListRecommendCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/27.
//  Copyright © 2016年 jiachen. All rights reserved.
//  用户推荐cell

import UIKit


// 按钮tag值
private let CommentBtnTag = 10000
private let CollectBtnTag = 10001
private let ShareBtnTag   = 10002


protocol ListRecommendCellDelegate
{
    func userRecommednClickCenter(clickType:ListDetailCellClickType,indexPath:NSIndexPath)
}

class ListRecommendCell: UITableViewCell {

    private var headerImageView = UIImageView()
    private var authorNameLabel = UILabel()
    private var createTimeLabel = UILabel()
    private var identifierImgView = UIImageView()
    
    private var picImgView = UIImageView()
    
    private var commentBtn = UIButton()
    private var collectBtn = UIButton()
    private var shareBtn   = UIButton()
    
    private var shareImgView = UIImageView()
    private var shareUrl = NSURL()
    
    private var currentIndexPath = NSIndexPath()

    //计算控件的orgin.Y
    private var orginY: CGFloat = 0.0
    
    var delegate: ListRecommendCellDelegate?
    
    var recommendModel:UserRecommendModel?{
        didSet{
            //作者姓名 信息  商品图片
            let imageUrl = recommendModel?.author?.headerImageUrl!
            headerImageView.sd_setImageWithURL(NSURL(string: imageUrl!) , placeholderImage: UIImage(named: "placeHolder"))
            
            authorNameLabel.text = recommendModel?.author?.nickName!
            authorNameLabel.sizeToFit()
            identifierImgView.frame = CGRectMake(CGRectGetMaxX(authorNameLabel.frame)+10, 10, 36, 36)
            createTimeLabel.text = recommendModel?.createTime!
            createTimeLabel.sizeToFit()
            createTimeLabel.frame = CGRectMake(SCREEN_WIDTH - createTimeLabel.frame.size.width - 10, 22, createTimeLabel.frame.size.width, 10.0)
            orginY = 55
            
            picImgView.sd_setImageWithURL(NSURL(string: (recommendModel?.picArray![0].url)!), placeholderImage: UIImage(named: "placeHolder"))
            picImgView.userInteractionEnabled = true
            //添加点击手势
            let tapGesture = UITapGestureRecognizer.init(target: self, action: "clickProductImage:")
            picImgView.addGestureRecognizer(tapGesture)
            picImgView.frame = CGRectMake(0, orginY, (recommendModel?.picArray![0].width)!, (recommendModel?.picArray![0].height)!)
            orginY += (recommendModel?.picArray![0].height)!
            
            buildToolView()
            
            buildTags()
            
            buildDescriptionView()
            
            buildShareView()
            
            buildLikeAndCommentLabel()
            
            buildCommentView()
            if(recommendModel?.cellHieght == nil)
            {
                recommendModel?.cellHieght = orginY
            }
            
            print(recommendModel?.picArray![0].tagDic?.objectForKey("text1"))
        }
    
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildHeadView()
    {
        headerImageView = UIImageView.init(frame: CGRectMake(0, 15, 30, 30))
        headerImageView.layer.cornerRadius = 15.0
        headerImageView.layer.masksToBounds = true
        contentView.addSubview(headerImageView)
        
        authorNameLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(headerImageView.frame)+10, 21, 30, 15))
        authorNameLabel.textColor = HalfBlackTitleColor
        authorNameLabel.font = UIFont.systemFontOfSize(15.0)
        contentView.addSubview(authorNameLabel)
        
        identifierImgView = UIImageView.init(frame: CGRectMake(CGRectGetMaxX(authorNameLabel.frame)+10, 21, 18, 18))
        identifierImgView.image = UIImage(named: "imperialcrown")
        contentView.addSubview(identifierImgView)
        
        createTimeLabel = UILabel.init(frame: CGRectZero)
        createTimeLabel.font = UIFont.systemFontOfSize(10.0)
        createTimeLabel.textColor = GrayLineColor
        contentView.addSubview(createTimeLabel)
        
        orginY += 55.0
    }
    
    func buildToolView()
    {
        commentBtn = UIButton.init(frame: CGRectMake(16, 13+orginY, 23, 23))
        commentBtn.tag = CommentBtnTag
        commentBtn.setImage(UIImage(named: "comments"), forState: .Normal)
        commentBtn.setImage(UIImage(named: "comments"), forState: .Highlighted)
        commentBtn.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        contentView.addSubview(commentBtn)
    
        collectBtn = UIButton.init(frame: CGRectMake(CGRectGetMaxX(commentBtn.frame)+20, 13+orginY, 23, 23))
        collectBtn.setImage(UIImage(named: "addToFavoriteBtn"), forState: .Normal)
        collectBtn.setImage(UIImage(named: "addToFavorite_selected"), forState: .Selected)
        let isCollect = recommendModel?.productArray![0].isCollect
        if(isCollect == true)
            {
                collectBtn.selected = true
            }
        collectBtn.tag = CollectBtnTag
        collectBtn.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        contentView.addSubview(collectBtn)
        
        shareBtn = UIButton.init(frame: CGRectMake(CGRectGetMaxX(collectBtn.frame)+20, 13+orginY, 24, 24))
        shareBtn.tag = ShareBtnTag
        shareBtn.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        shareBtn.setImage(UIImage(named: "Share_fire"), forState: .Normal)
        shareBtn.setImage(UIImage(named: "Share_fire"), forState: .Highlighted)
        contentView.addSubview(shareBtn)
        
        orginY += 50
        
        //添加分割线
        contentView.addSubview(DrawLine.createLine(DrawType.DottedLine, lineRect: CGRectMake(5, orginY-1, SCREEN_WIDTH-5, 1.0)))
    }
    
    func buildTags()
    {
        let tagsImgView = UIImageView.init(frame: CGRectMake(10, 18+orginY, 12, 12))
        tagsImgView.image = UIImage(named: "btn_publish_tag_icon")
        contentView.addSubview(tagsImgView)
        
        var orginX:CGFloat = 10+12+10
        var orgin_Y:CGFloat = 18+orginY
        orginY += 35
        for var i = 0;i < recommendModel?.tagArray?.count;i++
        {
      
            let tagLabel = UILabel.init()
            tagLabel.text = recommendModel?.tagArray![i].name
            tagLabel.textColor = CustomBarTintColor
            tagLabel.font = UIFont.systemFontOfSize(14.0)
            tagLabel.sizeToFit()
            
            if(SCREEN_WIDTH - orginX - 10 < tagLabel.frame.size.width)
            {
                //剩余空间不足以显示 taglabel
                orginX = 10
                orgin_Y += 27
                orginY += 70
                
            }
            tagLabel.frame = CGRectMake(orginX, orgin_Y, tagLabel.frame.size.width, tagLabel.frame.size.height)
            
            contentView.addSubview(tagLabel)
            orginX += tagLabel.frame.size.width+5.0
        }
    
    
    }
    
    func buildDescriptionView()
    {
        let  descriptionLabel = CMLabel.init(frame: CGRectMake(0, orginY, SCREEN_WIDTH, 20), title: (recommendModel?.content!)!, font: UIFont.systemFontOfSize(15.0), textColor: HalfBlackTitleColor, lineSpacing: 6.0, textEdgeInsets: UIEdgeInsetsMake(12.0, 10.0, 0, 0))
        contentView.addSubview(descriptionLabel)
        
        orginY = CGRectGetMaxY(descriptionLabel.frame)
    }
    
    func buildShareView()
    {
        
        let tiplabel = UILabel.init(frame: CGRectMake(10, orginY, 4*14, 14))
        tiplabel.text = " 相关链接"
        tiplabel.textColor = SubTitleColor
        tiplabel.font = UIFont.systemFontOfSize(14.0)
        contentView.addSubview(tiplabel)
        
        orginY += 12+14
        
        
        let backView = UIView.init(frame: CGRectMake(10, orginY, SCREEN_WIDTH-20, 65))
        backView.backgroundColor = UIColor(hexString: "F4F4F4")
        let ctrl = UIControl.init(frame: backView.bounds)
        ctrl.tag = 10086
        ctrl.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        ctrl.backgroundColor = UIColor.clearColor()
        backView.addSubview(ctrl)
        
        shareImgView = UIImageView(frame: CGRectMake(0, 0, 65, 65))
        shareImgView.sd_setImageWithURL(NSURL(string: (recommendModel?.productArray![0].picUrl)!), placeholderImage: UIImage(named: "placeHolder"))
        backView.addSubview(shareImgView)
        //商品名称
        let productNameLabel = UILabel.init(frame: CGRectMake(65+10, 14.0, 150, 14.0))
        productNameLabel.text = recommendModel?.productArray![0].title
        productNameLabel.textAlignment = .Left
        productNameLabel.textColor = MainTitleColor
        productNameLabel.font = UIFont.systemFontOfSize(14.0)
        backView.addSubview(productNameLabel)
        //平台来源
        
        
        let platformImgView = UIImageView.init(frame: CGRectMake(75, 36, 16.0, 16.0))
        let platformLabel = UILabel.init()
        platformLabel.textColor = SubTitleColor
        platformLabel.font = UIFont.systemFontOfSize(14.0)
        if(recommendModel?.productArray![0].platform == "0")
        {
            //淘宝订单
            platformImgView.sd_setImageWithURL(icon_tabbaoURl, placeholderImage: UIImage(named: "icon_Tabbao"))
            platformLabel.text = "来自淘宝"
        
        }else if(recommendModel?.productArray![0].platform == "1")
        {
            //京东订单
            platformImgView.sd_setImageWithURL(icon_JDURl, placeholderImage: UIImage(named: "icon_Tabbao"))
            platformLabel.text = "来自京东"
        }else if(recommendModel?.productArray![0].platform == "2")
        {
            //亚马逊订单
            platformImgView.sd_setImageWithURL(icon_AmazonURl, placeholderImage: UIImage(named: "icon_Tabbao"))
            platformLabel.text = "来自亚马逊"
        }
        platformLabel.sizeToFit()
        platformLabel.frame = CGRectMake(CGRectGetMaxX(platformImgView.frame)+10, 36, platformLabel.frame.width, platformLabel.frame.height)
        backView.addSubview(platformImgView)
        backView.addSubview(platformLabel)
        
        //价格
        let priceLabel = UILabel.init()
        priceLabel.font = UIFont.systemFontOfSize(11.0)
        priceLabel.textColor = CustomBarTintColor
        priceLabel.text = "¥\((recommendModel?.productArray![0].price)!)软妹币"
        priceLabel.sizeToFit()
        priceLabel.frame = CGRectMake(CGRectGetMaxX(platformLabel.frame)+6, 36.0, priceLabel.frame.width, priceLabel.frame.height)
        backView.addSubview(priceLabel)
        
        //购物图标
        
        let icon_back = UIView.init(frame: CGRectMake(backView.frame.width - 45, 0, 45, backView.frame.height))
        icon_back.backgroundColor = UIColor(hexString: "EBEBEB")
        let icon_shopImgView = UIImageView.init(frame: CGRectMake(45/2-12, 65/2-12, 24, 24))
        icon_shopImgView.image = UIImage(named: "iconfont-shop")
        icon_back.addSubview(icon_shopImgView)
        backView.addSubview(icon_back)

        contentView.addSubview(backView)

        orginY += 65
    }
    
    func buildLikeAndCommentLabel()
    {
        let iconImgView = UIImageView.init(frame: CGRectMake(10, orginY+22, 23, 23))
        iconImgView.image = UIImage(named: "addToFavorite_selected")
        contentView.addSubview(iconImgView)
        
        let likeLabel = UILabel.init(frame: CGRectMake(43, orginY+22, 12, 13))
        likeLabel.text = "\((recommendModel?.dynamic?.likesCount!)!)人喜欢吖"
        likeLabel.textColor = GrayLineColor
        likeLabel.font = UIFont.systemFontOfSize(13.0)
        likeLabel.sizeToFit()
        contentView.addSubview(likeLabel)
        
        let lookCountLabel = UILabel.init()
        lookCountLabel.textColor = GrayLineColor
        lookCountLabel.font = UIFont.systemFontOfSize(13.0)
        lookCountLabel.text = " \((recommendModel?.dynamic?.lookHistoryCount!)!)人浏览"
        lookCountLabel.sizeToFit()
        lookCountLabel.frame = CGRectMake(SCREEN_WIDTH - lookCountLabel.frame.width - 10, orginY+22, lookCountLabel.frame.width,lookCountLabel.frame.size.height)
        contentView.addSubview(lookCountLabel)
        
        orginY += 50
        
        //添加分割线
        contentView.addSubview(DrawLine.createLine(DrawType.DottedLine, lineRect: CGRectMake(5, orginY-1, SCREEN_WIDTH-5, 1.0)))
    }
    
    func buildCommentView()
    {
        let commentView = UIView.init(frame: CGRectMake(0, orginY, SCREEN_WIDTH, 50))
        commentView.backgroundColor = UIColor.whiteColor()
        //icon
        let icon_ImgView = UIImageView.init(frame: CGRectMake(10, 10, 32, 32))
        icon_ImgView.image = UIImage(named: "PersonCenter_normal_login")
        commentView.addSubview(icon_ImgView)
        //评论
        let commentButton = UIButton.init(frame: CGRectMake(CGRectGetMaxX(icon_ImgView.frame)+8, 10, 524/2, 32))
        commentButton.tag = CommentBtnTag
        commentButton.setImage(UIImage(named: "SayTwoWords"), forState: .Normal)
        commentButton.setImage(UIImage(named: "SayTwoWords"), forState: .Highlighted)
        commentButton.addTarget(self, action: "clickCenter:", forControlEvents: .TouchUpInside)
        commentView.addSubview(commentButton)
        
        contentView.addSubview(commentView)
        
        orginY += 50
    }
    
    //MARK:事件处理
    func clickCenter(sender:UIButton)
    {
        if(sender.tag == CommentBtnTag)
        {
            delegate?.userRecommednClickCenter(ListDetailCellClickType.AllowComment_type, indexPath: currentIndexPath)
        }else if(sender.tag == CollectBtnTag)
        {
            sender.selected = !sender.selected
            delegate?.userRecommednClickCenter(ListDetailCellClickType.LikeIt_type, indexPath: currentIndexPath)
        }else if(sender.tag == ShareBtnTag)
        {
            delegate?.userRecommednClickCenter(ListDetailCellClickType.ShareProduct_type, indexPath: currentIndexPath)
        }else if(sender.tag == 10086)
        {
            delegate?.userRecommednClickCenter(ListDetailCellClickType.BuyThisProduct_type, indexPath: currentIndexPath)
        }

    }
    
    func clickProductImage(tapGesture:UITapGestureRecognizer)
    {

       //显示 折线 动画   或者隐藏该动画
        let imgView = tapGesture.view
        if(recommendModel?.picArray![0].tagDic?.objectForKey("x") != nil && recommendModel?.picArray![0].tagDic?.objectForKey("y") != nil)
        {
            DrawLine.createLineInView(DrawType.BrokenLine, contentView: imgView!, titleDic:(recommendModel?.picArray![0].tagDic)!)
        }

    }
    
    //MARK: build UI
    func buildUI()
    {
        //用户头像  创建时间
        buildHeadView()
        
        //目前只有一张图片，就先放一个ImgView
        picImgView = UIImageView.init(frame: CGRectMake(0, orginY, SCREEN_WIDTH, 12))
        contentView.addSubview(picImgView)
        
        orginY += SCREEN_WIDTH
        
        
        recommendModel?.cellHieght = orginY
    }
    
    
    
    private static let cellID = "cellIdentifier"
    class func listRecommendCell(tableview:UITableView,model:UserRecommendModel,indexPath:NSIndexPath) -> ListRecommendCell
    {
        var cell = tableview.dequeueReusableCellWithIdentifier(cellID) as? ListRecommendCell
        if(cell == nil)
        {
            cell = ListRecommendCell.init(style: .Default, reuseIdentifier: nil)
            cell?.selectionStyle = .None
        }
        cell?.currentIndexPath = indexPath
        cell?.recommendModel = model
    
        return cell as ListRecommendCell!
    }
    
}
