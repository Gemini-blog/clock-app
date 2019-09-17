//
//  TimerLabelCell.swift
//  clockApp
//
//  Created by Gemini on 2019/08/27.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

protocol TimerLabelCellDelegate {
    func timerLabelCell(timerEnd:TimerLabelCell)
    func timerLabelCell(stopTimer:TimerLabelCell,remainingTime:Double)
}

class TimerLabelCell: UITableViewCell {

    @IBOutlet weak var timerLabel: UILabel!
    var timer = Timer()
    var time:Double = 0 {
        didSet {
            //タイマーをtimerLabelにセット
            timerLabel.text = timeString(time: time)
        }
    }
    var delegate:TimerLabelCellDelegate!
 
    //タイマースタート
    func startTimer(){
        //タイマーが動いているか
        if timer.isValid {
            timer.invalidate()
        }
        // タイマー生成、開始 １秒後の実行
        timer = Timer.scheduledTimer(
            
            timeInterval: 1.0,                              // 時間間隔
            
            target: self,                       // タイマーの実際の処理の場所
            
            selector: #selector(TimerLabelCell.tickTimer(_:)),   // メソッド タイマーの実際の処理
            
            userInfo: nil,
            
            repeats: true)
    }
    
    //タイマー停止
    func stopTimer(){
        timer.invalidate()
        delegate.timerLabelCell(stopTimer: self, remainingTime: time)
    }
    
    // タイマー処理
    
    @objc func tickTimer(_ timer: Timer) {
        
        time -= 1
        timerLabel.text = timeString(time: time)
        //timeが-1になった時
        if time == -1 {
            // タイマーの停止
            timer.invalidate()
            delegate.timerLabelCell(timerEnd: self)
        }
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600  //時
        let minutes = Int(time) / 60 % 60  //分
        let seconds = Int(time) % 60 //秒
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
