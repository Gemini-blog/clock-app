//
//  AlarmAddLabelVC.swift
//  clockApp
//
//  Created by Gemini on 2019/09/09.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

protocol AlarmAddLabelDelegate {
    func alarmAddLabel(labelText:AlarmAddLabelVC,text:String)
}

class AlarmAddLabelVC: UIViewController,UITextFieldDelegate {
    
    var text:String!

    @IBOutlet weak var textField: UITextField!
    var delegate:AlarmAddLabelDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // テキストを全消去するボタンを表示
        textField.clearButtonMode = .always
        // 改行ボタンの種類を設定
        textField.returnKeyType = .done
        // UITextFieldを追加
        textField.delegate = self
        //キーボードを表示する
        textField.becomeFirstResponder()
        
        textField.text = text
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //textFieldの中身が空でない時
        if textField.text != "", let text = textField.text{
            delegate.alarmAddLabel(labelText: self, text:text)
        }
    }
    
    // 完了ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textFieldの中身が空でない時
        if textField.text != "", let text = textField.text{
            delegate.alarmAddLabel(labelText: self, text:text)
            self.navigationController?.popViewController(animated: true)
        }
        return true
    }
}
