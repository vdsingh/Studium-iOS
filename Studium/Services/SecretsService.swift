//
//  SecretsService.swift
//  Studium
//
//  Created by Vikram Singh on 7/27/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// TODO: Docstrings
struct SecretsService {
    private struct Constants {
        static let openAIKey = "OpenAIAPIKey"
    }
    
    static func getOpenAIAPIKey() -> String? {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else {
            Log.e("Tried to retrieve Bundle.main.infoDictionary in getOpenAIAPIKey, but failed", logToCrashlytics: true)
            return nil
        }
        guard let openAIAPIKey: String = infoDictionary[Constants.openAIKey] as? String else {
            Log.e("Tried to retrieve OpenAI API Key in getOpenAIAPIKey, but failed", logToCrashlytics: true)
            return nil
        }
        
        return openAIAPIKey
    }
}
