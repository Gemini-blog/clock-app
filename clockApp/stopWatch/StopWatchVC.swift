//
//  StopWatchVC.swift
//  clockApp
//
//  Created by Gemini on 2019/08/31.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

class StopWatchVC: UIViewController , UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    var seconds:Double = 0
    var lap:Double = 0
    var timer = Timer()
    var lapTimers: [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "StopWatchTimeCell", bundle: nil), forCellReuseIdentifier: "StopWatchTimeCell")

        timerLabel.adjustsFontSizeToFitWidth = true
        lapResetButton.isEnabled = false
    }
    
    @IBAction func startStop(_ sender: Any) {
        
        let cell = tableView.visibleCells as! [StopWatchTimeCell]
        if timer.isValid {
            timer.invalidate()
            startButton()
            lapResetButton.setTitle("Reset", for: .normal)

            cell[0].timerStop()
        }else{
            timer = Timer.scheduledTimer(
                
                timeInterval: 0.01,                              // 時間間隔
                
                target: self,                       // タイマーの実際の処理の場所
                
                selector: #selector(StopWatchVC.tickTimer(_:)),   // メソッド タイマーの実際の処理
                
                userInfo: nil,
                
                repeats: true)
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
            cell[0].labelisHidden = false
            cell[0].timerStart()
            stopButton()
            lapResetButton.setTitle("Lap", for: .normal)
        }
        lapResetButton.isEnabled = true
    }
    
    @IBAction func lapReset(_ sender: Any) {
        let cell = tableView.visibleCells as! [StopWatchTimeCell]
        if timer.isValid {
        lapTimers.append(seconds - lap)
        lap = seconds
        cell[0].seconds = 0
        }else{
            seconds = 0
            startButton()
            timerLabel.text = timeString(time: seconds)
            lapTimers.removeAll()
            lapResetButton.setTitle("Lap", for: .normal)
            lapResetButton.isEnabled = false
            cell[0].seconds = 0
            cell[0].labelisHidden = true
        }
        tableView.reloadData()

    }
    
    func startButton(){
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(#colorLiteral(red: 0.7055676579, green: 1, blue: 0.6596676707, alpha: 1), for: .normal)
        startStopButton.backgroundColor = #colorLiteral(red: 0.1799043417, green: 0.6762347817, blue: 0.2553646266, alpha: 1)
    }
    
    func stopButton(){
        startStopButton.setTitle("Stop", for: .normal)
        startStopButton.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
        startStopButton.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return lapTimers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopWatchTimeCell") as! StopWatchTimeCell
    
        cell.lapLabel.text = String(format: "Lap %d", lapTimers.count - indexPath.row + 1)
        if indexPath.row > 0 {
            let  max = lapTimers.max()
            let min = lapTimers.min()
        cell.timerLabel.text = timeString(time: lapTimers[lapTimers.count - indexPath.row ])
        
            if lapTimers[lapTimers.count - indexPath.row ] == max {
                cell.timerLabel.textColor = .green
                cell.lapLabel.textColor = .green

            }else if lapTimers[lapTimers.count - indexPath.row ] == min {
                cell.timerLabel.textColor = .red
                cell.lapLabel.textColor = .red

            }else {
                cell.timerLabel.textColor = .black
                cell.lapLabel.textColor = .black


            }
            cell.labelisHidden = false

        }
        return cell
    }
}
