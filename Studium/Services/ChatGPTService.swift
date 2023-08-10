//
//  ChatGPTService.swift
//  Studium
//
//  Created by Vikram Singh on 7/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import ChatGPTSwift

class ChatGPTService {
    static let shared = ChatGPTService()
    
    private init() { }
        
    let api = ChatGPTAPI(apiKey: SecretsService.getOpenAIAPIKey() ?? "")
    
    func generateResources(forAssignment assignment: Assignment, keywords: [String]) {
        let message = "I need to complete a school assignment represented with these key phrases: [\(keywords.joined(separator: ","))]. Provide me with three links to resources in a list with the following format: <%>Title<$>URL<%>Title<$>URL<%>Title<$>URL<%>. Provide no extra words and strictly follow the format."
        let assignmentKey = assignment._id.stringValue
        Task {
            do {
                Log.d("Sending ChatGPT message: \(message)")
                DatabaseService.shared.realmWrite {
                    assignment.thaw()?.resourcesAreLoading = true
                }
                
                let response = try await api.sendMessage(text: message, temperature: 0)
                let safeAssignment = DatabaseService.shared.getStudiumEvent(withPrimaryKey: assignmentKey, type: Assignment.self)!

                let linkConfigs = self.parseLinks(fromMessage: response)
                DatabaseService.shared.realmWrite {
                    safeAssignment.resourceLinks = linkConfigs
                    safeAssignment.resourcesAreLoading = false
                }
                Log.d("ChatGPT Response: \(response)")
            } catch {
                //TODO: Error handle
                print(error.localizedDescription)
                DatabaseService.shared.realmWrite {
                    assignment.resourcesAreLoading = false
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
                //            if let range1 = component.range(of: "<STA>"),
                //               let range2 = component.range(of: "<END>") {
                //                let title = String(component[range1.upperBound..<range2.lowerBound])
                //                let url = String(component[range2.upperBound...])
                links.append(LinkConfig(label: label, link: link))
            }
//            }
        }
        
        return links
    }
}
