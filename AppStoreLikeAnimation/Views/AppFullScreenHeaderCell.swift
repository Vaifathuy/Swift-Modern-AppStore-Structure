//
//  AppFullScreenHeaderCell.swift
//  AppStoreLikeAnimation
//
//  Created by Vaifat Huy on 8/5/19.
//  Copyright © 2019 Vaifat. All rights reserved.
//

import UIKit

class AppFullScreenHeaderCell: UITableViewCell {
    
    fileprivate let todayCell: TodayCell = {
        let cell = TodayCell()
        cell.backgroundView?.clipsToBounds = true
        return cell
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupControls(){
        clipsToBounds = true
        selectionStyle = .none
        addSubview(todayCell)
        todayCell.fillSuperview()
    }
}
