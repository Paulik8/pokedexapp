//
//  LoginViewController.swift
//  pokedexapp
//
//  Created by Paulik on 22/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var isChanged = false
    
    var login: UILabel = {
        let login = UILabel()
//        login.font = UIFont(name: "KohinoorBangla-Regular", size: 36)
        login.font = UIFont(name: "Chalkduster", size: 36)
        login.textColor = Colors.DEFAULT_TEXT_COLOR
        login.text = "Log In"
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    var name: LoginTextField = {
        let name = LoginTextField()
        name.textColor = Colors.DEFAULT_TEXT_COLOR
        name.font = UIFont.systemFont(ofSize: 20)
        name.placeholder = "Name"
        name.sizeToFit()
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var password: LoginTextField = {
        let password = LoginTextField()
        password.textColor = Colors.DEFAULT_TEXT_COLOR
        password.font = UIFont.systemFont(ofSize: 20)
        password.placeholder = "Password"
        password.sizeToFit()
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    @objc private func buttonClicked(sender: AnyObject?) {
        if (sender === button) {
            Auth.auth().createUser(withEmail: name.text!, password: password.text!) { (user, err) in
                if (user != nil && err != nil) {
                    print ("User created")
                }
            }
        }
    }
    
    private func setupUi() {
        
        view.addSubview(login)
        view.addSubview(name)
        view.addSubview(password)
        view.addSubview(button)
        view.backgroundColor = Colors.DEFAULT_BACKGROUND
        
        let width = view.safeAreaLayoutGuide.layoutFrame.width / 5
        let topAnchor = view.safeAreaLayoutGuide.layoutFrame.height / 6
        let reserveTop = view.safeAreaLayoutGuide.layoutFrame.height / 16
        
        NSLayoutConstraint.activate([
            
            login.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width + 8),
            login.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchor),

            name.topAnchor.constraint(equalTo: login.bottomAnchor, constant: reserveTop),
            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -width),
            name.heightAnchor.constraint(equalToConstant: name.frame.height),

            password.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 24),
            password.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            password.heightAnchor.constraint(equalToConstant: password.frame.height),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -reserveTop),
            button.heightAnchor.constraint(equalToConstant: button.frame.height)
        ])
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        if (!isChanged) {
            name.underlined()
            name.setPadding()
            password.underlined()
            password.setPadding()
        }
        isChanged = true
    }
    


}

extension UITextField {
    
    func underlined() {
        let bottomLine = CALayer()
        self.borderStyle = .none
        bottomLine.borderColor = UIColor.black.cgColor
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: self.frame.size.height)
        bottomLine.borderWidth = 1
        self.layer.addSublayer(bottomLine)
        self.clipsToBounds = true
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
    
}
