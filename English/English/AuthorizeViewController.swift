//
//  AuthorizeViewController.swift
//  English
//
//  Created by Женя К on 12.07.2025.
//

import UIKit
import Security

class AuthorizeViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
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
        guard let email = emailField?.text, !email.isEmpty,
              let password = passwordField?.text, !password.isEmpty else {
            showAlert(message: "Введите email и пароль")
            return
        }
        // Формируем URL с query параметрами
        var components = URLComponents(string: "\(API.baseURL)/api/Authorize/Login")!
        components.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        let url = components.url!

        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 3

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    AppRouter.shared.navigateToVc(vc: .NotConnectionVc)
                    return
                }
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                
                if httpResponse.statusCode == 401 {
                    if let data = data, let serverMessage = String(data: data, encoding: .utf8), !serverMessage.isEmpty {
                        self.showAlert(message: "Неверный email или пароль")
                    }
                }
                // Парсим jwt токен из ответа
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let token = json["token"] as? String else {
                    self.showAlert(message: "Не удалось получить токен")
                    return
                }
                
                AuthManager.shared.saveTokenToKeychain(token: token)
                AppRouter.shared.navigateToMainMenuVC()
            }
        }
        task.resume()
    }
    
}
