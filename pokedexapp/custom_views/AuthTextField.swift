//
//  LoginTextField.swift
//  pokedexapp
//
//  Created by Paulik on 24/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class AuthTextField: UITextField {
    
    let insets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = Colors.DEFAULT_TEXT_COLOR
        font = UIFont.systemFont(ofSize: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
}

extension UITextField {
    
    func underlined() {
        let bottomLine = CALayer()
        self.borderStyle = .none
        bottomLine.borderColor = UIColor.black.cgColor
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: self.frame.height)
        bottomLine.borderWidth = 1
        self.layer.addSublayer(bottomLine)
    }
    
    func hide_underline() {
        let bottomLine = CALayer()
        self.borderStyle = .none
        bottomLine.borderColor = UIColor.white.cgColor
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.borderWidth = 1
        self.layer.addSublayer(bottomLine)
    }
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 0, y: 0, width: 30, height: 30))
       iconView.image = image
        iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.image?.withTintColor(.red)
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
       rightView = iconContainerView
       rightViewMode = .always
    }
    
}
