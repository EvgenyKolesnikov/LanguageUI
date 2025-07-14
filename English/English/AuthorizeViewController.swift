//
//  AuthorizeViewController.swift
//  English
//
//  Created by Женя К on 12.07.2025.
//

import UIKit

class AuthorizeViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func registerButton(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Все поля должны быть заполнены")
            return
        }
        guard password == confirmPassword else {
            showAlert(message: "Пароли не совпадают")
            return
        }
        
        let url = (URL(string: "\(API.baseURL)/api/Authorize/Register") ?? nil)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5
        let body: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
               
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showAlert(message: "Нет ответа от сервера")
                    return
                }
                // Если неуспешный статус — показываем тело ответа как есть
                if !(200...299).contains(httpResponse.statusCode) {
                    if let data = data, let serverMessage = String(data: data, encoding: .utf8), !serverMessage.isEmpty {
                        self.showAlert(message: serverMessage)
                    } else {
                        self.showAlert(message: "Ошибка сервера: \(httpResponse.statusCode)")
                    }
                    return
                }
                // Если успешный статус — показываем успех
                self.showAlert(message: "Регистрация успешна!")
            }
        }
        task.resume()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
