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
    
    var user: User? {
        guard let user = app.currentUser else {
            print("$Error: Current User is nil")
            return nil
        }
        
        return user
    }
    
    //TODO: Make private
    var realm: Realm {
        if let user = self.user {
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
    
    public func getStudiumObjects <T: Object> (expecting type: T.Type) -> [T] {
        return [T](self.realm.objects(type))
    }
    
    public func getAssignments(forCourse course: Course) -> [Assignment]{
        return [Assignment](course.assignments)
    }
}
