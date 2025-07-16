import UIKit

class AppRouter {
    static let shared = AppRouter()
    private weak var window: UIWindow?
    
    enum ViewControllers: String{
        case AuthVc = "AuthVC"
        case NotConnectionVc = "NotConnectionVC"
    }
    
    func setWindow(_ window: UIWindow?) {
        self.window = window
        navigateToVc(vc: .AuthVc)
    }
    
    func navigateToVc(vc: ViewControllers) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: vc.rawValue)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        UIView.transition(with: window,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
                             window.rootViewController = VC
                          },
                         completion: nil)
    }
    
    func navigateToMainMenuVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainMenuVC")
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
