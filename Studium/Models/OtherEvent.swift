//
//  OtherEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class OtherEvent: Object, StudiumEvent{
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partitionKey: String = ""
    
    //Basic String elements for an OtherEvent object
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    //Basic Date elements for an OtherEvent object
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var startDate: Date = Date()
    
    @objc dynamic var color: String = "ffffff"
    
    //Specifies whether or not the OtherEvent object is marked as complete or not. This determines where it lies in a tableView and whether or not it's crossed out.
    @objc dynamic var complete: Bool = false
    
    var notificationAlertTimes = List<Int>()
    var notificationIdentifiers = List<String>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(startDate: Date, endDate: Date, name: String, location: String, additionalDetails: String, notificationAlertTimes: [Int], partitionKey: String){
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self._partitionKey = partitionKey
        
        self.notificationAlertTimes.removeAll()
        for time in notificationAlertTimes{
            self.notificationAlertTimes.append(time)
        }
    }
    
    func initializeData(startDate: Date, endDate: Date, name: String, location: String, additionalDetails: String){
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
    }
    
    func deleteNotifications(){
        var identifiers: [String] = []
        for id in notificationIdentifiers{
            identifiers.append(id)
        }
        notificationIdentifiers.removeAll()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)

    }
    
    func updateNotifications(with newAlertTimes: [Int]){
        var identifiersForRemoval: [String] = []
        for time in notificationAlertTimes{
            if !newAlertTimes.contains(time){ //remove the old alert time.
                print("\(time) was removed from notifications.")
                let index = notificationAlertTimes.firstIndex(of: time)!
                notificationAlertTimes.remove(at: index)
                identifiersForRemoval.append(notificationIdentifiers[index])
                notificationIdentifiers.remove(at: index)
            }
        }
        print("identifiers to be removed: \(identifiersForRemoval)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersForRemoval)

    }
}
