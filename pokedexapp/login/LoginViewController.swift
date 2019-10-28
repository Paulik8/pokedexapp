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
    
    let viewModel = LoginViewModel()
    
    var topVerticalAnchor: NSLayoutConstraint?
    var buttonTopAnchor: NSLayoutConstraint?
    var buttonBottomAnchor: NSLayoutConstraint?
    
    var isChanged = false
    
    var login: UILabel = {
        let login = UILabel()
        login.font = UIFont(name: "Chalkduster", size: 36)
        login.textColor = Colors.DEFAULT_TEXT_COLOR
        login.text = "Log In"
        login.sizeToFit()
        login.clipsToBounds = true
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    var name: LoginTextField = {
        let name = LoginTextField()
        name.textColor = Colors.DEFAULT_TEXT_COLOR
        name.font = UIFont.systemFont(ofSize: 20)
        name.placeholder = "Name"
        name.sizeToFit()
        name.clipsToBounds = true
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    var password: LoginTextField = {
        let password = LoginTextField()
        password.textColor = Colors.DEFAULT_TEXT_COLOR
        password.font = UIFont.systemFont(ofSize: 20)
        password.placeholder = "Password"
        password.sizeToFit()
        password.clipsToBounds = true
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 64))
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    var preSignUp: UITextField = {
        let preRecord = UITextField()
        preRecord.isEnabled = false
        preRecord.text = "No account yet?"
        preRecord.translatesAutoresizingMaskIntoConstraints = false
        preRecord.sizeToFit()
        preRecord.clipsToBounds = true
        return preRecord
    }()
    
    var signUp: UILabel = {
        let signup = UILabel()
        signup.isUserInteractionEnabled = true
        signup.textColor = Colors.WATER
        signup.text = "Sign Up"
        signup.sizeToFit()
        signup.clipsToBounds = true
        signup.translatesAutoresizingMaskIntoConstraints = false
        return signup
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        setupListeners()
        hideKeyboardAnywhereClicked()
    }
    
    private func setupListeners() {
        viewModel.loginVC = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async { // CHANGE
            self.updateViews()
            self.recalculateConstraints()
        }
        
    }
    
    private func updateLoginFields() {
        name.underlined()
        name.setPadding()
        password.underlined()
        password.setPadding()
    }
    
    @objc private func buttonClicked(sender: AnyObject?) {
        if (sender === button) {
        guard let nameField = name.text else { return }
        guard let passwordField = password.text else { return }
        viewModel.handleButtonClick(name: nameField, password: passwordField)
        }
    }
    
    @objc private func signupClicked(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                // TODO
           })
           animator.startAnimation()
        }
    }
    
    private func setupUi() {
        view.backgroundColor = Colors.DEFAULT_BACKGROUND
        view.addSubview(login)
        view.addSubview(name)
        view.addSubview(password)
        view.addSubview(preSignUp)
        view.addSubview(signUp)
        view.addSubview(button)
        
        activateConstraints()
        recalculateConstraints()
        updateViews()
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(signupClicked))
        signUp.addGestureRecognizer(tap)
    }
    
    private func updateViews() {
        button.backgroundGradient()
        updateLoginFields()
        
    }
    
    private func activateConstraints() {
        let reserveTop = view.bounds.height / 16
        let width = view.bounds.width / 5
        
        topVerticalAnchor = login.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)
        buttonTopAnchor = button.topAnchor.constraint(lessThanOrEqualTo: signUp.bottomAnchor)
        buttonBottomAnchor = button.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            
            login.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width + 8),
            topVerticalAnchor!,
            login.widthAnchor.constraint(equalToConstant: login.frame.width),

            name.topAnchor.constraint(lessThanOrEqualTo: login.bottomAnchor, constant: reserveTop),
            name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width),
            name.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -width),
            name.heightAnchor.constraint(equalToConstant: name.frame.height),

            password.topAnchor.constraint(lessThanOrEqualTo: name.bottomAnchor, constant: 24),
            password.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            password.heightAnchor.constraint(equalToConstant: password.frame.height),
            
            preSignUp.topAnchor.constraint(lessThanOrEqualTo: password.bottomAnchor, constant: 24),
            preSignUp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: width),
            
            signUp.topAnchor.constraint(lessThanOrEqualTo: preSignUp.topAnchor),
            signUp.leadingAnchor.constraint(equalTo: preSignUp.trailingAnchor, constant: 4),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            buttonBottomAnchor!,
            button.heightAnchor.constraint(equalToConstant: button.frame.height)
        ])
    }
    
    private func recalculateConstraints() {
        let topAnchor = view.bounds.height / 6
        let reserveTop = view.bounds.height / 16
        topVerticalAnchor?.constant = topAnchor
        buttonBottomAnchor?.constant = -reserveTop
        view.setNeedsLayout()
        view.layoutIfNeeded()
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
    
}

extension LoginViewController: LoginNotifier {
    
    func successLogin() {
        let homeVC = MainListViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
}

extension LoginViewController {
    
    func hideKeyboardAnywhereClicked() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if (view.frame.origin.y == 0) {
            let height = keyboardSize.height
            view.frame.origin.y += 0.01
            buttonBottomAnchor?.isActive = false
            topVerticalAnchor?.constant -= height/3
            buttonTopAnchor?.constant = 24
            buttonTopAnchor?.isActive = true
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (view.frame.origin.y != 0) {
            view.frame.origin.y = 0
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
}

extension UIView {
    
    func backgroundGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [Colors.LEFT_GRADIENT.cgColor, Colors.RIGHT_GRADIENT.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        if (layer.sublayers?.count == 1) {
            layer.insertSublayer(gradient, at: 0)
        } else {
            guard let item = layer.sublayers?[0] else { return }
            layer.replaceSublayer(item, with: gradient)
        }
    }
}
