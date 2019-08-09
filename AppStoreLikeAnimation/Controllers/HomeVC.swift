//
//  HomeVC.swift
//  AppStoreLikeAnimation
//
//  Created by Vaifat Huy on 8/5/19.
//  Copyright © 2019 Vaifat. All rights reserved.
//

import UIKit

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    fileprivate let todayCellID = "HomeCollectionViewCell"
    fileprivate var startingFrame: CGRect?
    fileprivate var appFullScreenVC: AppFullScreenVC!
    fileprivate var anchoredConstraints: AnchoredConstraints?
    
    fileprivate lazy var blurredEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.alpha = 0
        return view
    }()
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupControls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupControls(){
        view.addSubview(blurredEffectView)
        blurredEffectView.fillSuperview()
        collectionView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: todayCellID)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 32
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todayCellID, for: indexPath) as! TodayCell
        return cell
    }
    
    fileprivate func setupAppFullscreen(){
        let appFullScreen = AppFullScreenVC()
        addChild(appFullScreen)
        self.appFullScreenVC = appFullScreen
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureToDismissFullscreenVC(_:)))
        panGesture.delegate = self
        appFullScreen.view.addGestureRecognizer(panGesture)
        appFullScreen.closeButtonCompletion = {
            self.animateRemoveAppFullScreenVC()
        }
    }
    
    @objc fileprivate func handlePanGestureToDismissFullscreenVC(_ gesture: UIPanGestureRecognizer){
        let maxScaleDownSize: CGFloat = 0.80
        guard let appView = appFullScreenVC.view else {return}
        let translationY = gesture.translation(in: appView).y
        let scaleFactor = 1 - translationY / 1000
        print(scaleFactor)
        if gesture.state == .changed {
            if appFullScreenVC.tableView.bounces == false {
                if scaleFactor < 1 {
                    let maxScale = max(maxScaleDownSize, scaleFactor)
                    if scaleFactor < maxScale {
                        appFullScreenVC.handleCloseButton()
                    }else {
                        appView.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                    }
                }
            }
        }else if gesture.state == .ended {
            if appFullScreenVC.tableView.bounces == false {
                if scaleFactor < 1 && scaleFactor < maxScaleDownSize {
                    appFullScreenVC.handleCloseButton()
                }else if scaleFactor < 1 && scaleFactor > maxScaleDownSize {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        appView.transform = .identity
                    }, completion: nil)
                }
            }
        }
    }
    
    fileprivate func setupCellStartingFrame(_ indexPath: IndexPath){
        //get absolute coordinate of the cell
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else {return}
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullScreenStartingPosition(_ indexPath: IndexPath){
        setupCellStartingFrame(indexPath)
        guard let appFullScreenView = self.appFullScreenVC.view else {return}
        view.addSubview(appFullScreenView)
        guard let startingFrame = startingFrame else {return}
        anchoredConstraints = appFullScreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        view.layoutIfNeeded()
    }
    
    fileprivate func animateOpenFullScreenController() {
        collectionView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            guard let anchoredConstraints = self.anchoredConstraints else {return}
            anchoredConstraints.top?.constant = 0
            anchoredConstraints.leading?.constant = 0
            anchoredConstraints.width?.constant = self.view.frame.width
            anchoredConstraints.height?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            self.blurredEffectView.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func animateRemoveAppFullScreenVC(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            guard let startingFrame = self.startingFrame else {return}
            guard let anchoredConstraints = self.anchoredConstraints else {return}
            anchoredConstraints.top?.constant = startingFrame.origin.y
            anchoredConstraints.leading?.constant = startingFrame.origin.x
            anchoredConstraints.width?.constant = startingFrame.width
            anchoredConstraints.height?.constant = startingFrame.height
            self.view.layoutIfNeeded()
            self.appFullScreenVC.view.transform = .identity
            self.appFullScreenVC.tableView.contentOffset = .zero
            self.blurredEffectView.alpha = 0
        }) { _ in
            self.collectionView.isUserInteractionEnabled = true
            self.appFullScreenVC.view.removeFromSuperview()
            self.appFullScreenVC.removeFromParent()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // #1 - setup app fullscreen
        setupAppFullscreen()
        // #2 - setup starting pos of the app fullscreen
        setupAppFullScreenStartingPosition(indexPath)
        // #3 - Animate full screen controller
        animateOpenFullScreenController()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 28, left: 0, bottom: 28, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - 56, height: 450)
    }
}

extension HomeVC: UIGestureRecognizerDelegate {
    // MARK: - To allow multiple gestures in a view to work at the same time
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
