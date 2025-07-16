//
//  NotConnectionViewController.swift
//  English
//
//  Created by Женя К on 15.07.2025.
//

import UIKit

class NotConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func notConnectionButton(_ sender: Any) {
        Task { @MainActor in
            let token = AuthManager.shared.getTokenFromKeychain() ?? ""  
            let validateCode = await AuthManager.shared.validateToken(token: token)
            
            
            switch validateCode {
            case 200:
                AppRouter.shared.navigateToMainMenuVC()

            case 401:
                // Токен невалидный - удаляем его и переходим на экран авторизации
                AuthManager.shared.removeTokenFromKeychain()
                AppRouter.shared.navigateToVc(vc: .AuthVc)
            default:
                break;
            }
        }
    }
   

}
