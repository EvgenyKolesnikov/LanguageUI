//
//  AuthorizeViewController.swift
//  English
//
//  Created by Женя К on 12.07.2025.
//

import UIKit

class AuthorizeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signInButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
        let navController = UINavigationController(rootViewController: mainVC) // <- Важно!

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
                            window.rootViewController = navController // Используем navController вместо mainVC
                         },
                         completion: nil)
    }
    
}
