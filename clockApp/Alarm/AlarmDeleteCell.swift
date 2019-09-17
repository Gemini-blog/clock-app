//
//  AlarmDeleteCell.swift
//  clockApp
//
//  Created by Gemini on 2019/09/09.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit
protocol AlarmDeleteCellDelegate {
    func alarmDeleteCell(delete:UITableViewCell)
}


class AlarmDeleteCell: UITableViewCell {
    var delegate:AlarmDeleteCellDelegate!
    @IBAction func deleteButton(_ sender: Any) {
        delegate.alarmDeleteCell(delete: self)
    }
}
