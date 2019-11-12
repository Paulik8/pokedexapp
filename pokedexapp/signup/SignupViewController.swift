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
    
    var password: PasswordTextField = {
        let password = PasswordTextField()
        password.textContentType = .newPassword
        password.placeholder = "Password"
        password.translatesAutoresizingMaskIntoConstraints = false
        password.sizeToFit()
        password.clipsToBounds = true
        return password
    }()
    
    var repeatPassword: PasswordTextField = {
        let repeatPassword = PasswordTextField()
        repeatPassword.textContentType = .newPassword
        repeatPassword.placeholder = "Confirm password"
        repeatPassword.translatesAutoresizingMaskIntoConstraints = false
        repeatPassword.sizeToFit()
        repeatPassword.clipsToBounds = true
        return repeatPassword
    }()
    
    var button: AuthButton = {
        let button = AuthButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitle("Signing Up", for: .disabled)
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
        
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonTouchUpOutside), for: .touchUpOutside)
        
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
        
        
        
    }
    
    @objc private func buttonTouchDown(event: UIControl) {
        if (event.state == .highlighted) {
            button.replaceLayer(colors: [Colors.LEFT_GRADIENT_SIGNUP_PUSH.cgColor, Colors.RIGHT_GRADIENT_SIGNUP_PUSH.cgColor])
        }
    }
    
    @objc private func buttonTouchUpInside() {
        button.replaceLayer(colors: [Colors.LEFT_GRADIENT_SIGNUP.cgColor, Colors.RIGHT_GRADIENT_SIGNUP.cgColor])
        
        if (handleFields()) {
            dismissKeyboard()
            button.disableButton()
            viewModel.handleSubmitClick(name: name.text!, password: password.text!)
        }
    }
    
    @objc private func buttonTouchUpOutside() {
        button.replaceLayer(colors: [Colors.LEFT_GRADIENT_SIGNUP.cgColor, Colors.RIGHT_GRADIENT_SIGNUP.cgColor])
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
        button.setupIndicator()
        password.setupEls(view: view)
        repeatPassword.setupEls(view: view)
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
        buttonBottomAnchor?.isActive = false
        topVerticalAnchor?.constant -= height/3
        buttonTopAnchor?.constant = 24
        buttonTopAnchor?.isActive = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func buttonUpSmallScreen() {
        buttonBottomAnchor?.isActive = false
        topVerticalAnchor?.constant = 0
        buttonTopAnchor?.constant = 24
        buttonTopAnchor?.isActive = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func buttonUpMediumScreen() {
        buttonBottomAnchor?.isActive = false
        topVerticalAnchor?.constant = 16
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
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.unsubscribe()
    }
    
}

extension SignupViewController: SignupNotifier, PasswordClickListener {
    
    //start SignupNotifier
    
    func successSignup() {
        button.enableButton()
        let homeVC = MainListViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
    func showError(error str: String) {
        let alert = UIAlertController(title: str, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //end SignupNotifier
    
    //start PasswordClickListener
    
    func touchDown() {
        
    }
    
    func touchUpInside() {
        
    }
    
    func touchUpOutside() {
        
    }
    
    //end PasswordClickListener
    
}
