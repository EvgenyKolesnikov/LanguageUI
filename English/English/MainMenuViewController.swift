//
//  MainMenuViewController.swift
//  English
//
//  Created by Женя К on 15.07.2025.
//

import UIKit
import Security

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutButton(_ sender: Any) {
        // Удаляем токен из Keychain
        removeTokenFromKeychain()
        
        // Переходим на экран авторизации
        navigateToAuthScreen()
    }
    
    private func removeTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jwtToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    private func navigateToAuthScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyboard.instantiateViewController(withIdentifier: "AuthVC")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
                            window.rootViewController = authVC
                         },
                         completion: nil)
    }
    

}
