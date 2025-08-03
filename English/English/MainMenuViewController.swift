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
       // navigateToAuthScreen()
        AppRouter.shared.navigateToVc(vc: .AuthVc)
    }
    
    @IBAction func dictionaryButton(_ sender: Any) {
        let dictionaryVC = UserDictionaryViewController()
        navigationController?.pushViewController(dictionaryVC, animated: true)
    }
    
    private func removeTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jwtToken"
        ]
        SecItemDelete(query as CFDictionary)
    }
}
