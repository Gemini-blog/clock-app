//
//  StopWatchTimeCell.swift
//  clockApp
//
//  Created by Gemini on 2019/08/31.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

class StopWatchTimeCell: UITableViewCell {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapLabel: UILabel!
    var timer:Timer = Timer()
    var seconds:Double = 0
    
    var labelisHidden:Bool = true {
        didSet{
            timerLabel.isHidden = labelisHidden
            lapLabel.isHidden = labelisHidden
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        timerLabel.isHidden = true
        lapLabel.isHidden = true
    }
    
    
    func timerStart(){
         timer = Timer.scheduledTimer(

            timeInterval: 0.01,                              // 時間間隔

            target: self,                       // タイマーの実際の処理の場所

            selector: #selector(StopWatchVC.tickTimer(_:)),   // メソッド タイマーの実際の処理

            userInfo: nil,

            repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)

    }
    
    func timerStop(){
        timer.invalidate()
    }

    @objc func tickTimer(_ timer: Timer) {
        
         seconds += 1
        
        timerLabel.text = timeString(time: seconds)
    }
    
    func timeString(time:TimeInterval) -> String {
        
        let hours = Int(time) / 100 / 3600
        let minutes = Int(time) / 100 / 60 % 60
        let seconds = Int(time) / 100 % 60
        let milliseconds = Int(time) % 100
        
        return hours == 0 ? String(format:"%02d:%02d:%02d", minutes, seconds,milliseconds) : String(format:"%02d:%02d:%02d:%02d",hours, minutes, seconds,milliseconds)
    }
    
}
