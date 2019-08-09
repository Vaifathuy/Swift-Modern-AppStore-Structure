//
//  Extension.swift
//  AppStoreLikeAnimation
//
//  Created by Vaifat Huy on 8/5/19.
//  Copyright © 2019 Vaifat. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont, textColor: UIColor = .black, numberOfLines: Int = 1, lineBreakMode: NSLineBreakMode = .byTruncatingTail, alignment: NSTextAlignment = .left){
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
        self.textAlignment = alignment
    }
}

extension UITextField {
    convenience init(placeHolder: String, isSecuredText: Bool? = false, textColor: UIColor? = .black, returnKey: UIReturnKeyType? = .done, borderStyle: UITextField.BorderStyle){
        self.init(frame: .zero)
        self.isSecureTextEntry = isSecuredText ?? false
        self.placeholder = placeHolder
        self.borderStyle = borderStyle
        self.textColor = textColor!
        self.returnKeyType = returnKey!
    }
}

extension UserDefaults {
    public enum UserDefaultKeys : String{
        case AuthInfo = "AuthInfo"
        case IsLoggedIn = "IsLoggedIn"
    }
}

extension String {
    func convertToAttributedString(color: UIColor, size: CGFloat, weight: UIFont.Weight) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            .foregroundColor: color,
            .font: UIFont.systemFont(ofSize: size, weight: weight)
            ])
        return attributedString
    }
}

extension UIView {
    func addShadow(color: UIColor, offSet: CGSize, radius: CGFloat, opacity: Float){
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIViewController {
    enum SafeAreaInsetPosition {
        case Top
        case Bottom
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
    
    func getSafeAreaInset(pos: SafeAreaInsetPosition) -> CGFloat{
        var safeAreaInsets: CGFloat!
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if pos == .Top {
                safeAreaInsets = window?.safeAreaInsets.top
            }else {
                safeAreaInsets = window?.safeAreaInsets.bottom
            }
        }else {
            if pos == .Top {
                safeAreaInsets = topLayoutGuide.length
            }else {
                safeAreaInsets = bottomLayoutGuide.length
            }
        }
        return safeAreaInsets
    }
}
extension URL {
    /// A helper method for faster URLRequest creation
    /// - parameter method: an httpMethod of the request, default = "GET"
    /// - parameter body: an httpBody of the request, default = nil
    /// - parameter headerValues: values to add to headers in case of adding more additional HTTPHeaderField, default = nil
    func createRequest(forRequestMethod method: String? = "GET", withBody body: Data? = Data(), headerValues: [String: Any]? = nil) -> URLRequest? {
        var requestURL: URLRequest?
        requestURL = URLRequest(url: self)
        requestURL?.httpMethod = method
        requestURL?.httpBody = body
        if headerValues != nil {
            guard let values = headerValues else {return requestURL}
            values.forEach({ (arg) in
                let (key, value) = arg
                requestURL?.setValue(key, forHTTPHeaderField: value as! String)
            })
        }
        return requestURL
    }
}

extension UIResponder {
    /// A helper method for setting up Keyboard Notification Observers from a controller
    /// - parameter targets: An array of selectors whose elements are being arranged respectively, [KeyboardWillShow's, KeyboardWillHide's, KeyboardWillChangeFrame's ]; default is empty
    func setupKeyboardObservers(targets: [Selector]){
        NotificationCenter.default.addObserver(self, selector: targets[0], name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: targets[1], name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: targets[2], name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// A helper method for removing Keyboard Notification Observers from a controller
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /// a helper method for provoking specified Keyboard Notification
    func provokeKeyboardNotification(name: Notification.Name){
        NotificationCenter.default.post(name: name, object: nil)
    }
}

extension UIViewController {
    func presentAlertControllerWithOKButton( message: String, title: String? = "Note"){
        let alertVC = UIAlertController(title: "Note", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func presentAlertControllerWithOKButton(message: String, title: String? = "Note", okActionTitle: String? = "OK", denyActionTitle: String? = nil, completion: @escaping(_ isSuccess: Bool)->()){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .destructive, handler: { _ in
            completion(true)
        })
        let cancelAction = UIAlertAction(title: denyActionTitle ?? "", style: .default) { _ in
            completion(false)
        }
        if denyActionTitle != nil {
            alertVC.addAction(cancelAction)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
