//
//  TodayCell.swift
//  AppStoreLikeAnimation
//
//  Created by Vaifat Huy on 8/5/19.
//  Copyright © 2019 Vaifat. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    
    fileprivate var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "todayCellImage1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16.0
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = transform
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCell(){
        backgroundColor = .white
        layer.cornerRadius = 16.0
        addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 250, height: 250))
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
        backgroundView?.layer.cornerRadius = 16.0
        insertSubview(backgroundView!, at: 0)
        backgroundView?.addShadow(color: .black, offSet: .init(width: 0, height: 10), radius: 10, opacity: 0.2)
    }
}
