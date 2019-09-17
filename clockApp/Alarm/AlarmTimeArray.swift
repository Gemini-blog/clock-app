//
//  AlarmTimeArray.swift
//  clockApp
//
//  Created by Gemini on 2019/09/01.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

class AlarmTimeArray: NSObject,NSCoding {
    
    var date:Date
    var uuidString:String
    var label:String
    var sound:Bool
    var snooze:Bool
    var onOff:Bool
    var repeatLabel:String
    var week:[String]
    
    override init() {
        self.date = Date()
        self.uuidString = UUID().uuidString
        self.label = "Alarm"
        self.sound = true
        self.snooze = true
        self.onOff = true
        self.week = []
        self.repeatLabel = "Never"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.uuidString, forKey: "uuidString")
        aCoder.encode(self.label, forKey: "label")
        aCoder.encode(self.sound, forKey: "sound")
        aCoder.encode(self.snooze, forKey: "snooze")
        aCoder.encode(self.onOff, forKey: "onOff")
        aCoder.encode(self.week, forKey: "week")
        aCoder.encode(self.repeatLabel, forKey: "repeatLabel")

    }
    
    required init?(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! Date
        uuidString = aDecoder.decodeObject(forKey: "uuidString") as! String
        label = aDecoder.decodeObject(forKey: "label") as! String
        sound = aDecoder.decodeBool(forKey: "sound")
        snooze = aDecoder.decodeBool(forKey: "snooze")
        onOff = aDecoder.decodeBool(forKey: "onOff")
        week = aDecoder.decodeObject(forKey: "week") as! [String]
        repeatLabel = aDecoder.decodeObject(forKey: "repeatLabel") as! String
    }
}
