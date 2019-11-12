//
//  PasswordTextField.swift
//  pokedexapp
//
//  Created by Paulik on 11/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class PasswordTextField: AuthTextField {
    
    var passwordEye: UIButton =  {
        let img = UIButton()
        img.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        img.setImage(UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        img.setImageColor(color: .lightGray)
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSecureTextEntry = true
    }
    
    func setupEls(view: UIView) {
        
        view.addSubview(passwordEye)
        
        NSLayoutConstraint.activate([
            passwordEye.topAnchor.constraint(equalTo: self.topAnchor),
            passwordEye.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            passwordEye.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            passwordEye.widthAnchor.constraint(equalToConstant: passwordEye.frame.width),
            passwordEye.heightAnchor.constraint(equalToConstant: passwordEye.frame.height),
        ])
        
        passwordEye.addTarget(self, action: #selector(passwordEyeTouchDown), for: .touchDown)
        passwordEye.addTarget(self, action: #selector(passwordEyeTouchUpInside), for: .touchUpInside)
        passwordEye.addTarget(self, action: #selector(passwordEyeTouchUpOutside), for: .touchUpOutside)
        
    }
    
    func updateLayout() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func passwordEyeTouchDown() {
        if (self.isSecureTextEntry) {
            self.changeIconColor(color: .gray)
        } else {
            self.changeIconColor(color: Colors.DARK_BLUE)
        }
    }
    
    @objc func passwordEyeTouchUpInside() {
        if (self.isSecureTextEntry) {
            self.isSecureTextEntry = false
            self.changeIconColor(color: Colors.WATER)
        } else {
            self.isSecureTextEntry = true
            self.changeIconColor(color: .lightGray)
        }
    }
    
    @objc func passwordEyeTouchUpOutside() {
        if (self.isSecureTextEntry) {
            self.changeIconColor(color: .lightGray)
        } else {
            self.changeIconColor(color: Colors.WATER)
        }
    }
    
}

extension PasswordTextField {
    
    func changeIconColor(color: UIColor) {
        passwordEye.setImageColor(color: color)
    }
    
}

extension UIButton {
    
    func setImageColor(color: UIColor) {
        imageView?.tintColor = color
    }
    
}

