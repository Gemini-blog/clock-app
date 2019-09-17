//
//  WorldClockSelectVC.swift
//  clockApp
//
//  Created by Gemini on 2019/09/01.
//  Copyright © 2019 gemini. All rights reserved.
//

import UIKit

protocol WorldClockSelectVCDelegte {
    func worldClockSelect(selectedWorldClock:WorldClockSelectVC,selected:String)
    func worldClockSelect(cancel:WorldClockSelectVC)
}

class WorldClockSelectVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationBar!
    var delegate:WorldClockSelectVCDelegte!
    
    private var searchController: UISearchController!
    
    var filteredTitles = [[String]]()
    var timeZoneIdentifiers = [String]()
    var allCities: [String] = []
    var sortedFirstLetters: [String] = []
    var sections: [[String]] = [[]]
     var searchString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
        // UISearchControllerをUINavigationItemのsearchControllerプロパティにセットする。
        navigationItem.searchController = searchController
        
        // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
        // falseだとスクロール位置に関係なく常にSearchBarが表示される
        navigationItem.hidesSearchBarWhenScrolling = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers.sorted()
                for identifier in timeZoneIdentifiers {
                    if let cityName = identifier.split(separator: "/").last {
                        allCities.append("\(cityName)")
                    }
                }
        let firstLetters = allCities.map { $0[$0.startIndex].uppercased() }
        let uniqueFirstLetters = Array(Set(firstLetters))
        sortedFirstLetters = uniqueFirstLetters.sorted()
        
        sections = sortedFirstLetters.map({firstLetter in return allCities.filter({ $0[$0.startIndex].uppercased() == firstLetter }).sorted(by: {$0 < $1})
        })
        filteredTitles = sections
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
}

// MARK: - UISearchResultsUpdating

extension WorldClockSelectVC: UISearchResultsUpdating ,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        searchString = searchController.searchBar.text ?? ""
        if searchString.isEmpty {
            filteredTitles = sections
        } else {
            filteredTitles = sections.map({
                filter in return filter.filter({$0.contains(searchString)})
                }
            )
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.worldClockSelect(cancel: self)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource UITableViewDelegate
extension WorldClockSelectVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text =  filteredTitles[indexPath.section][indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchString != "" ? nil : sortedFirstLetters[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredTitles.count
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  searchString != "" ? nil : sortedFirstLetters
    }
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        searchController.dismiss(animated: false)
        delegate.worldClockSelect(selectedWorldClock: self, selected: filteredTitles[indexPath.section][indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
