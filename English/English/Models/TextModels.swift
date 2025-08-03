//
//  TextModels.swift
//  English
//
//  Created by Женя К on 16.07.2025.
//

import Foundation

// Модель для слова в словаре
struct DictionaryWord: Codable {
    let id: Int
    let word: String
    let translation: String?
}

// Модель для текста
struct TextModel: Codable {
    let id: Int
    let content: String
    let wordsCount: Int
    let wordsProcessed: Int
    let dictionary: [DictionaryWord]
}

// Сервис для работы с текстами
class TextService {
    static let shared = TextService()
    
    private init() {}
    
    func fetchTexts() async throws -> [TextModel] {
        guard let url = URL(string: "\(API.baseURL)/api/Admin/Text") else {
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
        return try decoder.decode([TextModel].self, from: data)
    }
    
    // Преобразуем API данные в формат, совместимый с текущим UI
    func convertToLegacyFormat(_ texts: [TextModel]) -> (texts: [String], translations: [String: String]) {
        var legacyTexts: [String] = []
        var legacyTranslations: [String: String] = [:]
        
        for text in texts {
            legacyTexts.append(text.content)
            
            // Добавляем переводы из словаря
            for word in text.dictionary {
                if let translation = word.translation {
                    legacyTranslations[word.word] = translation
                }
            }
        }
        
        return (legacyTexts, legacyTranslations)
    }
} 