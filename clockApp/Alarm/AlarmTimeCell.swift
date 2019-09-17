//
//  AlarmTimeCell.swift
//  clockApp
//
//  Created by Gemini on 2019/09/01.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

protocol AlarmTimeCellDelegate {
    func alarmTimeCell(switchTappe:UITableViewCell,isOn:Bool)
}
class AlarmTimeCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sw: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = sw
    }
}
