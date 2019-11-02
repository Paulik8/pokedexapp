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
        password.translatesAutoresizingMaskIntoConstraints = false
        password.sizeToFit()
        password.clipsToBounds = true
        return password
    }()
    
    var button: AuthButton = {
        let button = AuthButton()
        button.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 64))
        button.setTitle("Log In", for: .normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        buttonDown()
    }
    
    private func checkUser() {
        viewModel.checkUser()
    }
    
    override func setupListeners() {
        viewModel.loginVC = self
        super.setupListeners()
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
    
    @objc private func submitClicked(sender: AnyObject?) {
        if (sender === button) {
            if (handleFields()) {
                viewModel.handleSubmitClick(name: name.text!, password: password.text!)
            }
        }
    }
    
    private func handleFields() -> Bool {
        if (name.hasText || password.hasText || !(name.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || (password.text?.trimmingCharacters(in: .whitespaces).isEmpty)!) {
            return true
        }
        return false
    }
    
    @objc private func signupClicked(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
                self.viewModel.handleSignUpClick()
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
        
        button.addTarget(self, action: #selector(submitClicked), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(signupClicked))
        signUp.addGestureRecognizer(tap)
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

extension LoginViewController: LoginNotifier {
    
    //start LoginNotifier
    
    func successLogin() {
        let homeVC = MainListViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
    func openSignUp() {
        let signUpVC = SignupViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signUpVC, animated: true)
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
}
