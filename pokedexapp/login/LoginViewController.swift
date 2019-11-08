//
//  LoginViewController.swift
//  pokedexapp
//
//  Created by Paulik on 22/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: AuthViewController {
    
    let viewModel = LoginViewModel()
    
    var topVerticalAnchor: NSLayoutConstraint?
    var buttonTopAnchor: NSLayoutConstraint?
    var buttonBottomAnchor: NSLayoutConstraint?
    
    var login: AuthLabel = {
        let login = AuthLabel()
        login.text = "Log In"
        login.translatesAutoresizingMaskIntoConstraints = false
        login.sizeToFit()
        login.clipsToBounds = true
        return login
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
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        password.sizeToFit()
        password.clipsToBounds = true
        return password
    }()
    
    var passwordEye: UIButton =  {
        let img = UIButton()
        img.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        img.setImage(UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        img.setImageColor(color: .lightGray)
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var button: AuthButton = {
        let button = AuthButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 64))
        button.setTitle("Log In", for: .normal)
        button.setTitle("Logging in", for: .disabled)
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
        setupUi()
        setupListeners()
        super.viewDidLoad()
        checkUser()
    }
    
    private func checkUser() {
        viewModel.checkUser()
    }
    
    override func setupListeners() {
        viewModel.loginVC = self
        
        button.addTarget(self, action: #selector(submitTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(submitTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(submitTouchUpOutside), for: .touchUpOutside)
        
        passwordEye.addTarget(self, action: #selector(passwordEyeTouchDown), for: .touchDown)
        passwordEye.addTarget(self, action: #selector(passwordEyeTouchUpInside), for: .touchUpInside)
        passwordEye.addTarget(self, action: #selector(passwordEyeTouchUpOutside), for: .touchUpOutside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(signupClicked))
        signUp.addGestureRecognizer(tap)
        super.setupListeners()
    }
    
    @objc private func passwordEyeTouchDown() {
        if (password.isSecureTextEntry) {
            passwordEye.setImageColor(color: .gray)
        } else {
            passwordEye.setImageColor(color: Colors.DARK_BLUE)
        } 
    }
    
    @objc private func passwordEyeTouchUpInside() {
        if (password.isSecureTextEntry) {
            password.isSecureTextEntry = false
            passwordEye.setImageColor(color: Colors.WATER)
        } else {
            password.isSecureTextEntry = true
            passwordEye.setImageColor(color: .lightGray)
        }
    }
    
    @objc private func passwordEyeTouchUpOutside() {
       if (password.isSecureTextEntry) {
            passwordEye.setImageColor(color: .lightGray)
        } else {
            passwordEye.setImageColor(color: Colors.WATER)
        }
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
    
    @objc private func submitTouchUpInside() {
        button.replaceLayer(colors: [Colors.LEFT_GRADIENT_LOGIN.cgColor, Colors.RIGHT_GRADIENT_LOGIN.cgColor])
        
        if (handleFields()) {
            dismissKeyboard()
            button.disableButton()
            viewModel.handleSubmitClick(name: name.text!, password: password.text!)
        }
    }
    
    @objc private func submitTouchUpOutside() {
        button.replaceLayer(colors: [Colors.LEFT_GRADIENT_LOGIN.cgColor, Colors.RIGHT_GRADIENT_LOGIN.cgColor])
    }
    
    @objc private func submitTouchDown(event: UIControl) {
        if event.state == .highlighted {
            button.replaceLayer(colors: [Colors.LEFT_GRADIENT_LOGIN_PUSH.cgColor, Colors.RIGHT_GRADIENT_LOGIN_PUSH.cgColor])
        }
    }
    
    private func handleFields() -> Bool {
        if (name.hasText || password.hasText || !(name.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || !(password.text?.trimmingCharacters(in: .whitespaces).isEmpty)!) {
            return true
        }
        return false
    }
    
    @objc private func signupClicked(_ gestureRecognizer: UITapGestureRecognizer) {
//        if gestureRecognizer.state == .ended {
            viewModel.handleSignUpClick()
//        }
    }
    
    private func setupUi() {
        view.backgroundColor = Colors.DEFAULT_BACKGROUND
        view.addSubview(login)
        view.addSubview(name)
        view.addSubview(password)
        view.addSubview(preSignUp)
        view.addSubview(signUp)
        view.addSubview(button)
        view.addSubview(passwordEye)
        
        activateConstraints()
        recalculateConstraints()
        updateViews()
    }
    
    private func updateViews() {
        let colors = [Colors.LEFT_GRADIENT_LOGIN.cgColor, Colors.RIGHT_GRADIENT_LOGIN.cgColor]
        button.backgroundGradient(colors: colors)
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
            
            passwordEye.topAnchor.constraint(equalTo: password.topAnchor),
            passwordEye.bottomAnchor.constraint(equalTo: password.bottomAnchor, constant: -4),
            passwordEye.trailingAnchor.constraint(equalTo: password.trailingAnchor, constant: -4),
            passwordEye.widthAnchor.constraint(equalToConstant: passwordEye.frame.width),
            passwordEye.heightAnchor.constraint(equalToConstant: passwordEye.frame.height),
            
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
    
    override func buttonUp(height: CGFloat) {
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

extension LoginViewController: LoginNotifier {
    
    //start LoginNotifier
    
    func successLogin() {
        button.enableButton()
        let homeVC = MainListViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
    func openSignUp() {
        let signUpVC = SignupViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func showError(error str: String) {
        button.enableButton()
        let alert = UIAlertController(title: str, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //end LoginNotifier
}

extension UIView {
    
    func backgroundGradient(colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        if (layer.sublayers?.count == 1) {
            layer.insertSublayer(gradient, at: 0)
        } else {
            guard let item = layer.sublayers?[0] else { return }
            layer.replaceSublayer(item, with: gradient)
        }
    }
    
    func replaceLayer(colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        guard let item = layer.sublayers?[0] else { return }
        layer.replaceSublayer(item, with: gradient)
    }
}

extension UIButton {
    
    func setImageColor(color: UIColor) {
        imageView?.tintColor = color
    }
    
}
