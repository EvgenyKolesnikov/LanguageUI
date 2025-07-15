import UIKit

class AppRouter {
    static let shared = AppRouter()
    private weak var window: UIWindow?
    
    func setWindow(_ window: UIWindow?) {
        self.window = window
    }
    
    func navigateToVc(vc: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: vc)
        
        window?.rootViewController = VC
        window?.makeKeyAndVisible()

        return VC
    }
    
    func navigateToMainMenuVC() {
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
    
    func navigateToAuthVC() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authVC = storyboard.instantiateViewController(withIdentifier: "AuthVC")
            
            window?.rootViewController = authVC
            window?.makeKeyAndVisible()
        
        
        }
    
}
