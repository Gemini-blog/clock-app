//
//  WorldClockVC.swift
//  clockApp
//
//  Created by Gemini on 2019/08/31.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

class WorldClockVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var selectTimezones = [String]()
    var userDefaults = UserDefaults.standard
    var timer = Timer()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTimeZones()
        tableView.register(UINib(nibName: "WorldClockCell", bundle: nil), forCellReuseIdentifier: "WorldClockCell")
        self.navigationItem.setLeftBarButton(self.editButtonItem, animated: true)
    }
        
    
    func loadTimeZones(){
        if let getTimeZones = userDefaults.object(forKey: "TimeZones") as? [String]{
            selectTimezones = getTimeZones
        }
    }
    
    func saveTimeZones(){
        userDefaults.set(selectTimezones, forKey: "TimeZones")
        userDefaults.synchronize()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceCellItem = selectTimezones[sourceIndexPath.row]
        guard let indexPath = selectTimezones.firstIndex(of: sourceCellItem) else { return }
        selectTimezones.remove(at: indexPath)
        selectTimezones.insert(sourceCellItem, at: destinationIndexPath.row)
        saveTimeZones()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectTimezones.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockCell") as! WorldClockCell
        cell.setCity(name: selectTimezones[indexPath.row]) 
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectTimezones.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTimeZones()
        }
    }
    
    func timeZone(city:String) -> String{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        for identifier in timeZoneIdentifiers {
            if identifier.contains(city){
                formatter.timeZone = TimeZone(identifier: identifier)
            }
            }
        return formatter.string(from: Date())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nvc = segue.destination as? UINavigationController else {return}
        guard let vc = nvc.topViewController as? WorldClockSelectVC else {return}
        vc.delegate = self
    }
}

extension WorldClockVC:WorldClockSelectVCDelegte{
    func worldClockSelect(cancel: WorldClockSelectVC) {
        self.setEditing(false, animated: false)
    }
    
    func worldClockSelect(selectedWorldClock: WorldClockSelectVC, selected: String) {
        if !selectTimezones.contains(selected){
            selectTimezones.append(selected)
        }
        tableView.reloadData()
        saveTimeZones()
    }
}
