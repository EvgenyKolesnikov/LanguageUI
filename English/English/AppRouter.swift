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
    
    func navigateToAuthVC() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authVC = storyboard.instantiateViewController(withIdentifier: "AuthVC")
            
            window?.rootViewController = authVC
            window?.makeKeyAndVisible()
        }
    
}
