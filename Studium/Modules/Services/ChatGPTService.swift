//
//  ChatGPTService.swift
//  Studium
//
//  Created by Vikram Singh on 7/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import ChatGPTSwift

/// Service client to interact with Chat GPT endpoints
class ChatGPTService {
    static let shared = ChatGPTService()
    
    private init() { }
        
    lazy var api: ChatGPTAPI? = {
        guard let apiKey = SecretsService.getOpenAIAPIKey() else {
            Log.e("Unable to retrieve ChatGPT API Key")
            return nil
        }
        
        return ChatGPTAPI(apiKey: apiKey)
    }()
    
    //TODO: Docstrings
    func generateResources(forAssignment assignment: Assignment, keywords: [String]) {
        let message = "I need to complete a school assignment represented with these key phrases: [\(keywords.joined(separator: ","))]. Provide me with three links to resources in a list with the following format: <%>Title<$>URL<%>Title<$>URL<%>Title<$>URL<%>. Strictly follow the format."
        let assignmentKey = assignment._id
        Task {
            do {
                Log.d("Sending ChatGPT message: \(message)")
                DatabaseService.shared.realmWrite { _ in
                    assignment.thaw()?.resourcesAreLoading = true
                }
                
                guard let api = self.api else {
                    PopUpService.presentChatGPTUnavailableError()
                    return
                }
                
                let response = try await api.sendMessage(text: message, temperature: 0)
                guard let safeAssignment = DatabaseService.shared.getStudiumEvent(withID: assignmentKey, type: Assignment.self) else {
                    PopUpService.presentGenericError()
                    return
                }

                let linkConfigs = self.parseLinks(fromMessage: response)
                DatabaseService.shared.realmWrite { _ in
                    safeAssignment.resourceLinks = linkConfigs
                    safeAssignment.resourcesAreLoading = false
                }
                
                Log.d("ChatGPT Response: \(response)")
            } catch {
                // TODO: Error handle
                Log.e(error)
                PopUpService.presentChatGPTUnavailableError()
                DatabaseService.shared.realmWrite { _ in
                    assignment.thaw()?.resourcesAreLoading = false
                }
            }
        }
    }
    
    func parseLinks(fromMessage message: String) -> [LinkConfig] {
        let separator = "<%>"
        let components = message.components(separatedBy: separator)
        var links: [LinkConfig] = []
        
        for component in components {
            let linkComponents = component.components(separatedBy: "<$>")
            if let label = linkComponents.first,
               let link = linkComponents.last,
               !label.isEmpty
            {
                links.append(LinkConfig(label: label, link: link))
            }
        }
        
        return links
    }
}

extension PopUpService {
    static func presentChatGPTUnavailableError() {
        self.presentError(title: "Error accessing AI", description: "Please try again later")
    }
}
