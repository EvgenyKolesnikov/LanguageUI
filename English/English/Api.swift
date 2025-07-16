//
//  Api.swift
//  English
//
//  Created by Женя К on 14.07.2025.
//

import Foundation

enum API {
    static let baseURL = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String ?? "https://default.api"
}

