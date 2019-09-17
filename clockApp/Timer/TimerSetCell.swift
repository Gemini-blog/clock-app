//
//  TimerSetCell.swift
//  clockApp
//
//  Created by Gemini on 2019/08/27.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

protocol TimerSetCellDelegate {
    func timerSetCell(setTime: TimerSetCell, time: Double)
}

class TimerSetCell: UITableViewCell,UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    var delegate:TimerSetCellDelegate!
    var time:Double = 0
    var hour:Double = 0
    var minutes:Double = 0
    var seconds:Double = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        if time != 0 {
            delegate.timerSetCell(setTime: self, time: time)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.reloadAllComponentLabels()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1,2:
            return 60
            
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = Double(row * 3600)
        case 1:
            minutes = Double(row * 60)
        case 2:
            seconds = Double(row)
        default:
            break;
        }
        time = hour + minutes + seconds
        delegate.timerSetCell(setTime: self, time: time)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%i:%02i:%02i", hours, minutes, seconds)
    }
    
    func getTimer(){
        delegate.timerSetCell(setTime: self, time: time)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row.description
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/4
    }
    private let labelText = ["hours", "min", "sec"]
    private var labels :[UILabel] = []
    public func reloadAllComponentLabels() {
        
        let fontSize = UIFont.systemFontSize
        
        let labelTop = self.bounds.origin.y + self.bounds.height / 2 - fontSize
        let labelHeight = self.pickerView.rowSize(forComponent: 0).height
        var labelOffset = self.bounds.origin.x // Componentの右端
        
        for i in 0...(self.numberOfComponents(in: pickerView)) - 1 {
            
            if self.labels.count == i {
                let label = UILabel()
                label.text = labelText[i]
                label.backgroundColor = UIColor.clear
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.sizeToFit()
                
                self.addSubview(label)
                self.labels.append(label)
            }
            
            let labelWidth = self.labels[i].frame.width
            labelOffset += pickerView.rowSize(forComponent: i).width
            self.labels[i].frame = CGRect(x: labelOffset - labelWidth + pickerView.rowSize(forComponent: i).width/2, y: labelTop, width: labelWidth, height: labelHeight)
            
        }
    }
}
