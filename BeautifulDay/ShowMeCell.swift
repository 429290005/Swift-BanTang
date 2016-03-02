//
//  ShowMeCell.swift
//  BeautifulDay
//
//  Created by jiachen on 16/2/25.
//  Copyright © 2016年 jiachen. All rights reserved.
//

import UIKit

class ShowMeCell: UICollectionViewCell {

    private var imgView = UIImageView()
    //默认第一张图片是
     var image = UIImage(named: "btn_library_camera") {
        didSet{
            
            if image == nil {
                image = UIImage(named: "btn_library_camera")
            }else {
                //图片作 放大处理
                imgView.image = ImageOperationCenter.ScaleImage(image!, goalWidth: 103)
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: build UI
    func buildUI() {
        //cell 设置为 圆角
        layer.cornerRadius = 3.0
        clipsToBounds = true
        
        
        imgView = UIImageView.init(frame: CGRectMake(0, 0, frame.width, frame.height))
        imgView.clipsToBounds = true
        imgView.contentMode = .Center
        imgView.image = image
        contentView.addSubview(imgView)
        
        
    }
    
    static let cellID = "ShowMeCollectionViewCell"
    class func cell(collectionView: UICollectionView, indexPath: NSIndexPath,displayImage: UIImage?) -> ShowMeCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! ShowMeCell
        if displayImage != nil {
            cell.image = displayImage
        }
        
        return cell
    }
}
