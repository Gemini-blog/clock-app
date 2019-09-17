//
//  TimerVC.swift
//  clockApp
//
//  Created by Gemini on 2019/08/27.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit
import UserNotifications
class TimerVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var timerOn:Bool = false
    var timerStart:Bool = false
    var time:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(cellName: "TimerLabelCell")
        registerCell(cellName: "TimerSetCell")
        registerCell(cellName: "SoundSetCell")
        registerCell(cellName: "TimerButtonCell")
        
    }
    
    func registerCell(cellName:String){
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
         return 220
        case 1:
            return 44
        case 2:
            return  160
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if timerStart {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimerLabelCell") as! TimerLabelCell
                cell.delegate = self
                if timerOn {
                    cell.time = time
                    cell.startTimer()
                }else{
                    cell.stopTimer()
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TimerSetCell") as! TimerSetCell
                cell.delegate = self
                cell.getTimer()

                return cell
            }
         
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SoundSetCell") as! SoundSetCell

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimerButtonCell") as! TimerButtonCell
            cell.delegate = self
            if !timerStart {
                cell.start()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension TimerVC:TimerLabelCellDelegate {
    func timerLabelCell(stopTimer: TimerLabelCell, remainingTime: Double) {
        time = remainingTime
    }
    
    func timerLabelCell(timerEnd alarmSet: TimerLabelCell) {
        timerStart = false
        timerOn = false
        tableView.reloadData()
    }
}

extension TimerVC:TimerSetCellDelegate {
    func timerSetCell(setTime: TimerSetCell, time: Double) {
        self.time = time
    }
}

extension TimerVC:TimerButtonCellDelegate {
    func timerButtonCell(startStopTime: TimerButtonCell) {
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["Timer"])
        if time != 0 {
        timerStart = true
        if timerOn {
            timerOn = false
            startStopTime.resume()
        }else{
            timerOn = true
            startStopTime.pause()
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            content.title = "Timer Done"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
            let identifier = "Timer"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request){ (error : Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        }else{
            timerStart = false
            startStopTime.start()
        }
        
        tableView.reloadData()
    }
    
    func timerButtonCell(cancelTime: TimerButtonCell) {
        timerStart = false
        timerOn = false
        cancelTime.start()
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["Timer"])
        tableView.reloadData()
    }
}
