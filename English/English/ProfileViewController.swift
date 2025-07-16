//
//  ProfileViewController.swift
//  English
//
//  Created by Женя К on 16.07.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var NameField: UILabel!
    @IBOutlet weak var EmailField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileAsync()
    }
    
    private func loadProfileAsync() {
        Task {
            do {
                let profile = try await loadProfile()
                NameField.text = profile.name
                EmailField.text = profile.email
            } catch {
                // Покажите ошибку пользователю или залогируйте
                NameField.text = ""
                EmailField.text = ""
            }
        }
    }
    
    private func loadProfile() async throws -> Profile {
        guard let url = URL(string: "\(API.baseURL)/api/Profile/User") else {
            throw URLError(.badURL)
        }
        let token = AuthManager.shared.getTokenFromKeychain() ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Profile.self, from: data)
    }
    
    struct Profile: Decodable {
        let name: String
        let email: String
    }
}
