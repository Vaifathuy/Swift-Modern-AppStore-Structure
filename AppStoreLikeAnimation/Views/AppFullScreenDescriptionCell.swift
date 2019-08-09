//
//  AppFullScreenDescriptionCell.swift
//  AppStoreLikeAnimation
//
//  Created by Vaifat Huy on 8/5/19.
//  Copyright © 2019 Vaifat. All rights reserved.
//

import UIKit

class AppFullScreenDescriptionCell: UITableViewCell {
    fileprivate var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate var des: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .justified
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupControls(){
        selectionStyle = .none
        let vStackView = UIStackView(arrangedSubviews: [title, des])
        vStackView.axis = .vertical
        vStackView.spacing = 8
        addSubview(vStackView)
        vStackView.fillSuperview(padding: .init(top: 12, left: 18, bottom: 12, right: 18))
    }
    
    func configureCell(title: String, subtitle: String, des: String){
        let attributtedText = NSMutableAttributedString(string: title, attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 26, weight: .semibold)])
        attributtedText.append(NSAttributedString(string: " - \(subtitle)", attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
        self.title.attributedText = attributtedText
        self.des.text = des
    }
}
