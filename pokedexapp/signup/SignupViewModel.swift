//
//  SignupViewModel.swift
//  pokedexapp
//
//  Created by Paulik on 31/10/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignupViewModel {
    
    var addition = "@gmail.com"
    var signupVC: SignupNotifier?
    
    func handleSubmitClick(name: String, password: String) {
        let email = name.trimmingCharacters(in: .whitespaces).lowercased() + addition
        let app = (UIApplication.shared.delegate as? AppDelegate)
        let ref = app?.ref
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if (err != nil) {
                return
            }
            guard let uid = result?.user.uid else { return }
            
            let img: UIImage = #imageLiteral(resourceName: "pika")
            let name = "pikachu.png"
            
            guard let uploadData = img.pngData() else { return }
            
            let storage = app?.storage.reference().child(name)
            storage?.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if (err != nil) {
                    print(err)
                    return
                }
                
                let url = metadata?.path
                ref?.child("users").child(uid).setValue(["name": email, "password": password, "imageUrl": url], withCompletionBlock: { (err, ref) in
                    if (err != nil) {
                        print (err)
                        return
                    }
                    self.signupVC?.successSignup()
                })
                
            })
            
            
        }
        
        
    }

}
