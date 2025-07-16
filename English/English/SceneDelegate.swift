//
//  SceneDelegate.swift
//  English
//
//  Created by Женя К on 12.07.2025.
//

import UIKit
import Security

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Проверяем токен при запуске
        checkTokenAndNavigate()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func checkTokenAndNavigate() {
        guard let token = AuthManager.shared.getTokenFromKeychain() else {
            // Токена нет - переходим на экран авторизации
            navigateToAuthScreen()
            return
        }
        
        // Проверяем валидность токена
        let url = URL(string: "\(API.baseURL)/api/Authorize/CheckToken")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
    //    AppRouter.shared.navigateToVc(vc: "")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Нет ответа от сервера - переходим на NotConnectionVC
                    // AppRouter.shared.navigateToNotConnectionVC()
                    AppRouter.shared.navigateToVc(vc: .NotConnectionVc)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    // Нет ответа от сервера - переходим на NotConnectionVC
                  //  self?.navigateToNotConnectionVC()
                    AppRouter.shared.navigateToVc(vc: .NotConnectionVc)
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    // Токен валидный - переходим на главный экран
                    // self?.navigateToMainVC()
                    AppRouter.shared.navigateToMainMenuVC()
                case 401:
                    // Токен невалидный - удаляем его и переходим на экран авторизации
                    self?.removeTokenFromKeychain()
                   // self?.navigateToAuthScreen()
                    AppRouter.shared.navigateToVc(vc: .AuthVc)
                default:
                    // Другие ошибки - переходим на NotConnectionVC
                  //  self?.navigateToNotConnectionVC()
                    AppRouter.shared.navigateToVc(vc: .NotConnectionVc)
                }
            }
        }
        task.resume()
    }
    
    private func navigateToMainVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
        let navController = UINavigationController(rootViewController: mainVC)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    private func navigateToNotConnectionVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notConnectionVC = storyboard.instantiateViewController(withIdentifier: "NotConnectionVC")
        
        window?.rootViewController = notConnectionVC
        window?.makeKeyAndVisible()
    }
    
    private func navigateToAuthScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyboard.instantiateViewController(withIdentifier: "AuthVC")
        
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Keychain helpers
    private func getTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jwtToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    private func removeTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jwtToken"
        ]
        SecItemDelete(query as CFDictionary)
    }


}

