//
//  WorldClockCell.swift
//  clockApp
//
//  Created by Gemini on 2019/09/01.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

class WorldClockCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hrsLabel: UILabel!
    var timer = Timer()
    var cityName:String!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryView = timeLabel
    }
    
    func setCity(name:String){
        cityLabel.text = name
       timeLabel.text = timeZone(city: name)
        hrsLabel.text = "Today,+0HRS"
        cityName = name
        timer = Timer.scheduledTimer(
            
            timeInterval: 1.0,                              // 時間間隔
            
            target: self,                       // タイマーの実際の処理の場所
            
            selector: #selector(WorldClockCell.tickTimer(_:)),   // メソッド タイマーの実際の処理
            
            userInfo: nil,
            
            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func tickTimer(_ timer: Timer) {
        timeLabel.text = timeZone(city: cityName)
    }
    
    func timeZone(city:String) -> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        for identifier in timeZoneIdentifiers {
            if identifier.contains(city){
                formatter.timeZone = TimeZone(identifier: identifier)
            }
        }
        let timeDiff = formatter.timeZone.secondsFromGMT()
        hrsLabel.text = timeDiff.timeString()
        return formatter.string(from: Date())
    }
}

extension Int {
    func timeString() -> String {
        let adjustSecondsForJapan : TimeInterval = 9 * 60 * 60
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day,.hour, .minute]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(self) - adjustSecondsForJapan) ?? "0"
        let df = DateFormatter()
        df.dateStyle = .short
        df.doesRelativeDateFormatting = true
        
        let day = df.string(from: Date(timeIntervalSinceNow: TimeInterval(self) - adjustSecondsForJapan))
        if formattedString == "0" {
            return day + ", +0HRS"
        } else {
            if formattedString.hasPrefix("-") {
                return day + ", \(formattedString)HRS"
            } else {
                return day + "+\(formattedString)HRS"
            }
        }
    }
    
}

