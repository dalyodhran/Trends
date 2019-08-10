//
//  Run.swift
//  Treads
//
//  Created by Odhrán Daly on 10/08/2019.
//  Copyright © 2019 Odhrán Daly. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    dynamic public private(set) var id = ""
    dynamic public private(set) var pace = 0
    dynamic public private(set) var date = NSData()
    dynamic public private(set) var distance = 0.0
    dynamic public private(set) var duration = 0
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSData()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
}
