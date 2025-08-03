//
//  UserDictionaryModels.swift
//  English
//
//  Created by Женя К on 16.07.2025.
//

import Foundation

// Модель для ответа сервера
struct UserDictionaryResponse: Codable {
    let words: [String: String]
}

// Сервис для работы с пользовательским словарем
class UserDictionaryService {
    static let shared = UserDictionaryService()
    
    private init() {}
    
    func fetchUserDictionary() async throws -> [String: String] {
        guard let url = URL(string: "\(API.baseURL)/api/Profile/UserDictionary") else {
            print("❌ Некорректный URL: \(API.baseURL)/api/Profile/UserDictionary")
            throw URLError(.badURL)
        }
        
        let token = AuthManager.shared.getTokenFromKeychain() ?? ""
        if token.isEmpty {
            print("❌ Токен не найден в Keychain")
            throw URLError(.userAuthenticationRequired)
        }
        
        print("🔗 Отправляем запрос на: \(url)")
        print("🔑 Токен: \(String(token.prefix(20)))...")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Некорректный HTTP ответ")
                throw URLError(.badServerResponse)
            }
            
            print("📡 HTTP Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                let responseString = String(data: data, encoding: .utf8) ?? "Неизвестная ошибка"
                print("❌ Ошибка сервера: \(responseString)")
                throw URLError(.badServerResponse)
            }
            
            // Отладочная информация
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Полученный JSON: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            
            // Парсим как массив и берем первый элемент
            let responseArray = try decoder.decode([UserDictionaryResponse].self, from: data)
            let words = responseArray.first?.words ?? [:]
            
            print("✅ Успешно загружено слов: \(words.count)")
            return words
            
        } catch let decodingError as DecodingError {
            print("❌ Ошибка декодирования JSON: \(decodingError)")
            throw decodingError
        } catch {
            print("❌ Сетевая ошибка: \(error)")
            throw error
        }
    }
} 