//
//  DatabaseHandler.swift
//  Studium
//
//  Created by Vikram Singh on 1/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
final class DatabaseService {
    static let shared = DatabaseService()
    
    private init() {}
    
    let app = App(id: Secret.appID)
    
    var user: User {
        guard let user = app.currentUser else {
            fatalError("$Error: Current User is nil")
        }
        
        return user
    }
    
    //TODO: Make this private once all instances using it have been removed
    
    var realm: Realm {
        if let user = app.currentUser {
            do {
                return try Realm(configuration: user.configuration(partitionValue: user.id))
            } catch {
                fatalError("$Error: issue accessing Realm.")
            }
        } else {
            do {
                return try Realm()
            } catch {
                fatalError("$Error: issue accessing Realm.")
            }
        }
    }
    
    
    
    public func getCourses() -> [Course] {
        let courses = self.realm.objects(Course.self)
        return [Course](courses)
    }
}
