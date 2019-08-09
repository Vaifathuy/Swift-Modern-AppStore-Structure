//
//  AppFullScreenVC.swift
//  AppStoreLikeAnimation
//
//  Created by Vaifat Huy on 8/5/19.
//  Copyright © 2019 Vaifat. All rights reserved.
//

import UIKit

class AppFullScreenVC: UITableViewController {
    fileprivate let appFullScreenCellID = "AppFullScreenCell"
    fileprivate let appFullScreenDesCellID = "AppFullScreenDesCell"
    var closeButtonCompletion: ()->()? = {}
    
    fileprivate var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setImage(#imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 0.95, alpha: 1)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.addShadow(color: .black, offSet: .init(width: 0, height: 0), radius: 1.5, opacity: 1)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCloseButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupControls(){
        view.layer.cornerRadius = 16.0
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        tableView.register(AppFullScreenHeaderCell.self, forCellReuseIdentifier: appFullScreenCellID)
        tableView.register(AppFullScreenDescriptionCell.self, forCellReuseIdentifier: appFullScreenDesCellID)
    }
    
    fileprivate func setupCloseButton(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window {
            window.addSubview(closeButton)
            closeButton.anchor(top: window.topAnchor, leading: nil, bottom: nil, trailing: window.trailingAnchor, padding: .init(top: 48, left: 0, bottom: 0, right: 22), size: .init(width: 36, height: 36))
            closeButton.layer.cornerRadius = 36/2
            closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        }
    }
    
    @objc func handleCloseButton(){
        closeButton.removeFromSuperview()
        closeButtonCompletion()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return AppFullScreenHeaderCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: appFullScreenDesCellID) as! AppFullScreenDescriptionCell
            cell.configureCell(title: "App Store Clone", subtitle: "Step-by-step walk through with Hanry", des: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dignissim at ante ac consectetur. Vivamus euismod rutrum tortor. Cras tempus augue ac erat fringilla ullamcorper. Aenean mattis tristique mauris, ut faucibus nibh feugiat at. Aliquam ipsum ex, ullamcorper vel consequat condimentum, tincidunt quis sem. Vivamus vel dui ac mi varius interdum et et sem. Mauris lobortis massa sit amet quam posuere, vitae mollis nulla iaculis. Aenean vulputate a ligula in finibus. Etiam id risus magna")
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }else {
            return UITableView.automaticDimension
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if offSetY < 0 {
            tableView.bounces = false
        }else {
            tableView.bounces = true
        }
    }
}
