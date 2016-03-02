//
//  ListDetailCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/1/22.
//  Copyright © 2016年 jiachen. All rights reserved.
//  清单详情 cell
/*
1.自定义cell 高度自适应
2.
*/

import UIKit


private  let AllowComment    = 1100   //允许评论
private  let NotAllowComment = 1110   //不允许评论，跳向商品详情


enum ListDetailCellClickType
{
    //comment
    case AllowComment_type
    case NotAllowComment_type
    
    //收藏该商品
    case LikeIt_type
    case MoveToOtherFavoriteList_type
    
    //购买该商品
    case BuyThisProduct_type
    
    //分享哦耶
    case ShareProduct_type
}


protocol ListDetailClickToProductDelegate:NSObjectProtocol
{
    /**
     查看商品详情
     
     - parameter productID: 商品IID
     */
    func lookproductDetail(productID:Int)

    func clickCenter(clickType:ListDetailCellClickType,indexPath:NSIndexPath)
}

class ListDetailCell: UITableViewCell {
    
    var countLabel = UILabel()
    var titleLabel = CMLabel()
    var subTitleLabel = CMLabel()
    var currentIndexPath = NSIndexPath(){
        didSet{
            if(currentIndexPath.row < 9)
            {
                countLabel.text = "0\(currentIndexPath.section+1)"
            }else
            {
                countLabel.text = "\(currentIndexPath.section+1)"
            }
        }
    }
    
    var delegate:ListDetailClickToProductDelegate?
    /// 商品价格
    var priceLabel = UILabel()
    /// 头像view 包括 多少人喜欢。。
    var showHeaderView = UIView()
    /// 喜欢人数展示
    var likeNumLabel = UILabel()
    /// 最后一行 评论人数 喜欢人数 购买按钮
    var showToolView = UIView()
    
    var productModel = ListDetailProduct()
    {
        didSet{
        
            //product name
            titleLabel = CMLabel.init(frame: CGRectMake(36, 0, SCREEN_WIDTH-44, 54), title: productModel.productName!, font: UIFont.systemFontOfSize(18.0), textColor: MainTitleColor, lineSpacing: 0.0, textEdgeInsets: UIEdgeInsetsMake(17.0/2, 0, 0, 0))
            contentView.addSubview(titleLabel)
            
            // product detail
            subTitleLabel = CMLabel.init(frame: CGRectMake(0, 54, SCREEN_WIDTH-10, 45), title: productModel.detailText!, font: UIFont.systemFontOfSize(15.0), textColor: SubTitleColor, lineSpacing: 10.0, textEdgeInsets: UIEdgeInsetsMake(0, 10, 0, 0))
            contentView.addSubview(subTitleLabel)
            
            //product image
            var orginY = CGRectGetMaxY(subTitleLabel.frame) //orgin.y
            for var index = 0;index < productModel.picArray?.count;index++
            {
                let pic = productModel.picArray![index]
                let imageView = UIImageView.init(frame: CGRectMake(10, orginY+5, pic.width!/2 > SCREEN_WIDTH ? 300 : pic.width!/2, pic.height!/2 > SCREEN_WIDTH ? 300 : pic.height!/2))
                imageView.tag = Int(productModel.productID!)!
                imageView.userInteractionEnabled = true
                imageView.sd_setImageWithURL(NSURL(string: pic.imageUrl!), placeholderImage: UIImage(named: "placeHolder"))
                //给imageview 添加点击事件
                let tapGesture = UITapGestureRecognizer.init(target:self, action: "lookProductDetail:")
            
                imageView.addGestureRecognizer(tapGesture)
                contentView.addSubview(imageView)
                
                orginY += 300+5
            }
            
            //product price
            priceLabel.frame = CGRectMake(0, orginY, SCREEN_WIDTH-15, 50.0)
            priceLabel.text = "参考价：\(productModel.price!)"
            orginY += 50
        
            let topLine = UIView.init(frame: CGRectMake(0, orginY, SCREEN_WIDTH, 0.5))
            topLine.backgroundColor = LightLineColor
            contentView.addSubview(topLine)

            //喜欢列表 头像
            
            showHeaderView = UIView.init(frame: CGRectMake(0, orginY,SCREEN_WIDTH, 75))
            
            let showHeadNum = productModel.likes_list?.count > 7 ? 7:productModel.likes_list?.count
            
                //喜欢人数展示
            likeNumLabel.frame = CGRectMake(10, 11, SCREEN_WIDTH, 14)
            likeNumLabel.text = "\(productModel.likeNumbers!)人喜欢"
            showHeaderView.addSubview(likeNumLabel)
            
            var orginX:CGFloat = 10
            for var i = 0;i < showHeadNum;i++
            {
                let likeList = productModel.likes_list![i]
                let headImageView = UIImageView.init(frame: CGRectMake(orginX,32, 27, 27))
                headImageView.layer.cornerRadius = 27/2.0
                headImageView.layer.borderColor = UIColor.clearColor().CGColor
                headImageView.layer.masksToBounds = true
                headImageView.sd_setImageWithURL(NSURL(string: likeList.headerImageUrl!), placeholderImage: UIImage(named: "placeHolder"))
                showHeaderView.addSubview(headImageView)
                orginX += 10+27
            }
                //右侧箭头 
            let arrow = UIImageView.init(frame:CGRectMake(SCREEN_WIDTH-15-14, 39, 9, 14))
            arrow.image = UIImage(named: "subject_arrow_right")
            showHeaderView.addSubview(arrow)
            
            orginY += 75
            contentView.addSubview(showHeaderView)
                //分割线
            
            let bottomLine = UIView.init(frame: CGRectMake(0, orginY-0.5, SCREEN_WIDTH, 0.5))
            bottomLine.backgroundColor = LightLineColor
            contentView.addSubview(bottomLine)
        
            //toolView
            showToolView = UIView.init(frame: CGRectMake(0, orginY, SCREEN_WIDTH, 50))
                //comment button
            let commentBnt = UIButton.init(frame: CGRectMake(33, 14, 40, 23))
            commentBnt.setImage(UIImage(named: "comments"), forState: .Normal)
            commentBnt.setImage(UIImage(named: "comments"), forState: .Highlighted)
            if(productModel.comments != "0" && productModel.comments != "")
            {
                commentBnt.setTitle(productModel.comments!, forState: .Normal)
                commentBnt.setTitleColor(TitleGrayCorlor, forState: .Normal)
                commentBnt.titleLabel?.font = UIFont.systemFontOfSize(12.0)
                commentBnt.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
                commentBnt.tag = AllowComment
            }else if(productModel.comments == "")
            {
                commentBnt.tag = NotAllowComment
            }
            commentBnt.addTarget(self, action: "clickComment:", forControlEvents: .TouchUpInside)
            showToolView.addSubview(commentBnt)
            contentView.addSubview(showToolView)
                //like button
            let likeNums_length = (productModel.likeNumbers!).characters.count
            
            let likeButton = UIButton.init(frame:CGRectMake(254/2,14,25+CGFloat(likeNums_length)*12, 23))
            likeButton.setImage(UIImage(named: "addToFavorite_selected"), forState: .Selected)
            likeButton.setImage(UIImage(named: "addToFavoriteBtn"), forState: .Normal)
            likeButton.setTitle(productModel.likeNumbers!, forState: .Normal)
            likeButton.setTitle("收入心愿单", forState: .Selected)
            likeButton.setTitleColor(TitleGrayCorlor, forState: .Normal)
            likeButton.titleLabel?.font = UIFont.systemFontOfSize(12.0)
            likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
            
            likeButton.addTarget(self, action: "addToFavoriteClick:", forControlEvents: .TouchUpInside)
            
            let isLike = NSUserDefaults.standardUserDefaults().objectForKey(productModel.productID!) as? Bool
            if(isLike == nil || isLike == false)
            {
                likeButton.selected = false
                likeButton.setImage(UIImage(named: "addToFavoriteBtn"), forState: .Highlighted)
                
            }else if(isLike == true)
            {
                likeButton.selected = true
                let center = likeButton.center
                likeButton.frame = CGRectMake(21, 12, 25+12*12, 23)
                likeButton.center = center
                likeButton.setImage(UIImage(named: "addToFavorite_selected"), forState: .Highlighted)
            }
            likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
            showToolView.addSubview(likeButton)
            
                //购买按钮
            let buyBtn = UIButton.init(frame: CGRectMake(SCREEN_WIDTH-5-60, 10, 28+30, 30))
            buyBtn.backgroundColor = CustomBarTintColor
            buyBtn.layer.cornerRadius = 14.0
            buyBtn.setTitle("购买", forState: .Normal)
            buyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            buyBtn.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            buyBtn.addTarget(self, action: "buyThisProduct", forControlEvents: .TouchUpInside)
            showToolView.addSubview(buyBtn)
            
            
            
            //将cell高度放在模型中 实现cell高度动态自适应
            if(productModel.cellHieght == nil)
            {
                productModel.cellHieght = CGRectGetMaxY(showToolView.frame)
            }
        }
    
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI()
    {
        countLabel = UILabel.init(frame: CGRectMake(10, 54/2-22/2, 20+2, 20+2))
        countLabel.textAlignment = NSTextAlignment.Center
        
        countLabel.textColor = UIColor.whiteColor()
        countLabel.backgroundColor = CustomBarTintColor
        countLabel.font = UIFont.systemFontOfSize(10.0)
        countLabel.layer.cornerRadius = 11.0
        countLabel.layer.borderColor = UIColor.clearColor().CGColor
        countLabel.layer.borderWidth = 4.0
        countLabel.layer.masksToBounds = true
        
        contentView.addSubview(countLabel)
    
        
        priceLabel = UILabel.init(frame: CGRectZero)
        priceLabel.textColor = CustomBarTintColor
        priceLabel.font = UIFont.systemFontOfSize(15.0)
        priceLabel.textAlignment = NSTextAlignment.Right
        contentView.addSubview(priceLabel)
        
        
        likeNumLabel = UILabel.init(frame: CGRectZero)
        likeNumLabel.font = UIFont.systemFontOfSize(12.0)
        likeNumLabel.textAlignment = NSTextAlignment.Left
        likeNumLabel.textColor = GrayLineColor
        
        showToolView = UIView.init(frame: CGRectZero)
        contentView.addSubview(showToolView)
    }
    
    
    //点击图片 查看商品详情
    func lookProductDetail(tapGesture:UITapGestureRecognizer)
    {
        delegate?.lookproductDetail((tapGesture.view?.tag)!)
    }
    
    //点击评论
    func clickComment(sender:UIButton)
    {
        if(sender.tag == AllowComment)
        {
            delegate?.clickCenter(ListDetailCellClickType.AllowComment_type,indexPath: currentIndexPath)
        }else
        {
            print("不允许评论")
            delegate?.clickCenter(ListDetailCellClickType.NotAllowComment_type,indexPath: currentIndexPath)
        }
    }
    
    //点击收藏
    func addToFavoriteClick(sender:UIButton)
    {
        if(sender.selected == true)
        {
            delegate?.clickCenter(ListDetailCellClickType.MoveToOtherFavoriteList_type, indexPath: currentIndexPath)
        }else
        {
            //设置 key = productID value = true
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: productModel.productID!)
            
            sender.selected = true
            let center = sender.center
            sender.frame = CGRectMake(21, 12, 25+12*12, 23)
            sender.center = center

            let centerXY = sender.center
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                sender.center = centerXY
                sender.transform = CGAffineTransformMakeScale(1.4, 1.4)
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    sender.alpha = 0.0
                })
                }, completion: { (finished:Bool) -> Void in
                    if(finished)
                    {
                        sender.transform = CGAffineTransformIdentity
                        sender.alpha = 1.0
                    }
            })
            
            delegate?.clickCenter(ListDetailCellClickType.LikeIt_type, indexPath:currentIndexPath)
        }
    }
    
    //点击 购买
    func buyThisProduct()
    {
        delegate?.clickCenter(ListDetailCellClickType.BuyThisProduct_type, indexPath: currentIndexPath)
    }
    
    
    
    
    
    
    //cell  构造
    private static let cellID = "cellIdentifier"
    //return a cell
    class  func cell(tableview:UITableView,model:ListDetailProduct?,indexPath:NSIndexPath) -> ListDetailCell {
        var cell = tableview.dequeueReusableCellWithIdentifier(cellID) as? ListDetailCell
        if(cell == nil)
        {
            cell = ListDetailCell.init(style: .Default, reuseIdentifier: nil)
        }
        
        //CMLabel 是自定义label 此处不能复用  为了避免cell、显示混乱，先移除label再添加
        for label in (cell?.contentView.subviews)!
        {
            if(label.isKindOfClass(CMLabel))
            {
                label.removeFromSuperview()
            }
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell?.productModel = model!
        cell?.currentIndexPath = indexPath
        
        
        //在此处重新设定cell的.frame
//        var newFrame = CGRectMake(0, 0, SCREEN_WIDTH, <#T##height: CGFloat##CGFloat#>)
        
        
        
        return cell!
    }
    
    
}
