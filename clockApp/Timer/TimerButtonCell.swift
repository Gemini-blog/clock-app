//
//  TimerButtonCell.swift
//  clockApp
//
//  Created by Gemini on 2019/08/27.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

protocol TimerButtonCellDelegate {
    func timerButtonCell(startStopTime : TimerButtonCell)
    func timerButtonCell(cancelTime : TimerButtonCell)
}

class TimerButtonCell: UITableViewCell {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var delegate:TimerButtonCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cancelButton.isEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func startstop(_ sender: Any) {
        delegate.timerButtonCell(startStopTime: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate.timerButtonCell(cancelTime: self)
        cancelButton.isEnabled = true
    }
    
    func start(){
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = #colorLiteral(red: 0.1799043417, green: 0.6762347817, blue: 0.2553646266, alpha: 1)
    }
    func pause(){
        startButton.setTitle("Pause", for: .normal)
        startButton.backgroundColor = .orange

    }
    func resume(){
        startButton.setTitle("Resume", for: .normal)
        startButton.backgroundColor = #colorLiteral(red: 0.1799043417, green: 0.6762347817, blue: 0.2553646266, alpha: 1)

    }
}
