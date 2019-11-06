//
//  SignupViewController.swift
//  pokedexapp
//
//  Created by Paulik on 31/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit

class SignupViewController: AuthViewController {
    
    var topVerticalAnchor: NSLayoutConstraint?
    var buttonTopAnchor: NSLayoutConstraint?
    var buttonBottomAnchor: NSLayoutConstraint?
    
    var viewModel = SignupViewModel()
    
    var signUp: AuthLabel = {
        let signUp = AuthLabel()
        signUp.text = "Sign Up"
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.sizeToFit()
        signUp.clipsToBounds = true
        return signUp
    }()
    
    var name: AuthTextField = {
        let name = AuthTextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.sizeToFit()
        name.clipsToBounds = true
        return name
    }()
    
    var password: AuthTextField = {
        let password = AuthTextField()
        password.placeholder = "Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.sizeToFit()
        password.clipsToBounds = true
        return password
    }()
    
    var repeatPassword: AuthTextField = {
        let repeatPassword = AuthTextField()
        repeatPassword.placeholder = "Confirm password"
        repeatPassword.translatesAutoresizingMaskIntoConstraints = false
        repeatPassword.sizeToFit()
        repeatPassword.clipsToBounds = true
        return repeatPassword
    }()
    
    var button: AuthButton = {
        let button = AuthButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 64))
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        setupUi()
        setupListeners()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonDown()
    }
    
    override func setupListeners() {
        viewModel.signupVC = self
        super.setupListeners()
    }
    
    private func setupUi() {
        view.backgroundColor = Colors.DEFAULT_BACKGROUND
        view.addSubview(signUp)
        view.addSubview(name)
        view.addSubview(password)
        view.addSubview(repeatPassword)
        view.addSubview(button)
        
        activateConstraints()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        updateViews()
        
        button.addTarget(self, action: #selector(submitClicked), for: .touchUpInside)
        
    }
    
    @objc private func submitClicked(sender: AnyObject?) {
        if (sender === button) {
            if (handleFields()) {
                viewModel.handleSubmitClick(name: name.text!, password: password.text!)
            }
        }
    }
    
    private func handleFields() -> Bool {
        if (password.text == repeatPassword.text && (name.hasText || password.hasText || !(name.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || (password.text?.trimmingCharacters(in: .whitespaces).isEmpty)!)) {
            return true
        }
        return false
    }
    
    private func updateViews() {
        let colors = [Colors.LEFT_GRADIENT_SIGNUP.cgColor, Colors.RIGHT_GRADIENT_SIGNUP.cgColor]
        button.backgroundGradient(colors: colors)
        updateFields()
    }
    
    private func updateFields() {
        name.underlined()
        password.underlined()
        repeatPassword.underlined()
        name.setPadding()
        password.setPadding()
        repeatPassword.setPadding()
    }
    
    private func activateConstraints() {
        let reserveTop = view.bounds.height / 16
        let topAnchor = view.bounds.height / 6
        let width = view.bounds.width / 5
        
        topVerticalAnchor = signUp.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
        topVerticalAnchor?.constant = topAnchor
        buttonTopAnchor = button.topAnchor.constraint(lessThanOrEqualTo: repeatPassword.bottomAnchor)
        buttonBottomAnchor = button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -reserveTop)
        
        NSLayoutConstraint.activate([
            topVerticalAnchor!,
            signUp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width + 8),
            signUp.widthAnchor.constraint(equalToConstant: signUp.frame.width),

            name.topAnchor.constraint(lessThanOrEqualTo: signUp.bottomAnchor, constant: reserveTop),
            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -width),
            name.heightAnchor.constraint(equalToConstant: name.frame.height),

            password.topAnchor.constraint(lessThanOrEqualTo: name.bottomAnchor, constant: 24),
            password.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            password.heightAnchor.constraint(equalToConstant: password.frame.height),
            
            repeatPassword.topAnchor.constraint(lessThanOrEqualTo: password.bottomAnchor, constant: 24),
            repeatPassword.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            repeatPassword.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            repeatPassword.heightAnchor.constraint(equalToConstant: repeatPassword.frame.height),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            buttonBottomAnchor!,
            button.heightAnchor.constraint(equalToConstant: button.frame.height)
        ])
    }
    
    override func buttonUp(height: CGFloat) {
        view.frame.origin.y += 0.01
        buttonBottomAnchor?.isActive = false
        topVerticalAnchor?.constant -= height/3
        buttonTopAnchor?.constant = 24
        buttonTopAnchor?.isActive = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func buttonDown() {
        let topAnchor = view.bounds.height / 6
        let reserveTop = view.bounds.height / 16
        buttonTopAnchor?.isActive = false
        topVerticalAnchor?.constant = topAnchor
        buttonBottomAnchor?.constant = -reserveTop
        buttonBottomAnchor?.isActive = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}

extension SignupViewController: SignupNotifier {
    
    func successSignup() {
        let homeVC = MainListViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
}
