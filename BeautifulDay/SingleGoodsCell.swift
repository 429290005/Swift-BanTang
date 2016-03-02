//
//  SingleGoodsCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/1.
//  Copyright © 2016年 jiachen. All rights reserved.
//  点击搜索列表中的 collectionCell 显示搜索结果

import UIKit

class SingleGoodsCell: UITableViewCell {
    /// 商品图片
    private var productImgView = UIImageView()
    /// 商品名称
    private var productNameLabel = UILabel()
    /// 价格
    private var priceLabel = UILabel()
    /// 喜欢人数
    private var likeNUmLabel = UILabel()
    /// 作者
    private var authorLabel = UILabel()
    /// 作者头像
    private var authorImgView = UIImageView()
    /// 商品描述
    private var descriptionLabel = UILabel()
    /// 分割线
    private var separatorLine = DrawLine()
    
    private var currentIndexPath = NSIndexPath()
    
    private var model:SearchSingleGoodsModel?{
        didSet{
            productImgView.sd_setImageWithURL(NSURL(string: (model?.imageUrl!)!), placeholderImage: UIImage(named: "placeHolder"))
            
            productNameLabel.text = model?.productName!
            productNameLabel.sizeToFit()
            productNameLabel.frame = CGRectMake(140, 8, productNameLabel.frame.width, productNameLabel.frame.height)
         
            priceLabel.text = "￥\((model?.price!)!)"
            priceLabel.sizeToFit()
            priceLabel.frame = CGRectMake(140, 32, priceLabel.frame.width, 36.0)
            
            likeNUmLabel.text = "\( (model?.likeNumbers!)! )人推荐耶"
            likeNUmLabel.sizeToFit()
            likeNUmLabel.frame = CGRectMake(SCREEN_WIDTH - likeNUmLabel.frame.width - 14, 30+4, likeNUmLabel.frame.width + 14, likeNUmLabel.frame.height + 6)
            
            //添加分割线
                        
            authorImgView.sd_setImageWithURL(NSURL(string: (model?.author?.headerImageUrl)!), placeholderImage: UIImage(named: "placeHolder"))
            authorLabel.text = model?.author?.nickName!
            authorLabel.sizeToFit()
            authorLabel.frame = CGRectMake(CGRectGetMaxX(authorImgView.frame) + 6, authorImgView.frame.origin.y + 4, authorLabel.frame.width, authorLabel.frame.height)
            
            descriptionLabel.text = (model?.detailText)!
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SingleGoodsCellIdentifier")
    }

    
    convenience init(indexpath:NSIndexPath)
    {
        self.init()
        if(indexpath.row % 2 == 0)
        {
            buildCellUI()
        }else{
            buildseparatorUI()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Build UI
    
    func buildCellUI()
    {
        productImgView = UIImageView.init(frame: CGRectMake(5, 5, 125, 125))
        contentView.addSubview(productImgView)
        
        productNameLabel = UILabel()
        productNameLabel.textColor = MainTitleColor
        productNameLabel.textAlignment = .Center
        productNameLabel.font = UIFont.systemFontOfSize(14.0)
        contentView.addSubview(productNameLabel)
        
        priceLabel = UILabel()
        priceLabel.textColor = UIColor(hexString: "FF9200")
        priceLabel.textAlignment = .Left
        priceLabel.font = UIFont.systemFontOfSize(13.0)
        contentView.addSubview(priceLabel)
        
        likeNUmLabel = UILabel()
        likeNUmLabel.textColor = UIColor.whiteColor()
        likeNUmLabel.layer.cornerRadius = 5.0
        likeNUmLabel.layer.masksToBounds = true
        likeNUmLabel.textAlignment = .Center
        likeNUmLabel.font = UIFont.systemFontOfSize(12.0)
        likeNUmLabel.backgroundColor = TagBackOrangeColor
        contentView.addSubview(likeNUmLabel)
        
        authorImgView = UIImageView(frame: CGRectMake(140, 65, 22, 22))
        authorImgView.layer.cornerRadius = 11.0
        contentView.addSubview(authorImgView)
        
        authorLabel = UILabel()
        authorLabel.textColor = HalfBlackTitleColor
        authorLabel.font = UIFont.systemFontOfSize(14.0)
        contentView.addSubview(authorLabel)
        
        separatorLine = DrawLine.createLine(DrawType.DottedLine, lineRect: CGRectMake(70, 58, SCREEN_WIDTH - 140 - 10, 0.5))
        contentView.addSubview(separatorLine)
        
        //商品详细描述
        descriptionLabel = UILabel.init(frame: CGRectMake(140, 93, SCREEN_WIDTH - 140 - 10, 45))
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.textColor = SubTitleColor
        descriptionLabel.font = UIFont.init(name: LightFont, size: 14.0)
        contentView.addSubview(descriptionLabel)
    }
    //用 cell 当做分割线
    func buildseparatorUI()
    {
        contentView.backgroundColor = CellSeparatotBackColor
    }
    
    static private let cellID = "SingleGoodsCellIdentifier"
    class func singleGoodsCell(indexpath:NSIndexPath,tableview:UITableView,model:SearchSingleGoodsModel) -> SingleGoodsCell{
    
        var cell = tableview.dequeueReusableCellWithIdentifier(cellID) as? SingleGoodsCell
        if cell == nil
        {
            cell = SingleGoodsCell.init(indexpath: indexpath)
        }
        cell?.selectionStyle = .None
        cell?.model = model
        
        return cell!
    }
}
