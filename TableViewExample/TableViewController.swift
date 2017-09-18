//
//  TableViewController.swift
//  TableViewExample
//
//  Created by Cemen Istomin on 18.09.17.
//  Copyright © 2017 I Love View Inc. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, DataChangesDelegate {
    
    let dataSource = DataSource(items: 1000)
    let inverse = CGAffineTransform(scaleX: 1.0, y: -1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let nib = UINib(nibName: "NumberCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NumberCell")
        tableView.transform = inverse
        
        dataSource.delegate = self
        dataSource.expose(0 ..< 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.exposedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath) as! NumberCell
        let data = dataSource.exposedItems[indexPath.row]
        
        cell.transform = inverse
        cell.numberLabel.text = String(data.number)
        cell.contentView.backgroundColor = data.color
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = dataSource.exposedItems[indexPath.row]
        return data.height
    }
    
    // pagination
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > 75 {
            dataSource.expose(dataSource.exposedRange.shift(by: 25))
        }
        if indexPath.row < 25 && dataSource.exposedRange.lowerBound > 0 {
            dataSource.expose(dataSource.exposedRange.shift(by: -25))
        }
    }
    
    // MARK: - Data source tracking
    
    func items(added indexes: CountableRange<Int>) {
        NSLog("added \(indexes.lowerBound) ..< \(indexes.upperBound)")
        self.tableView.insertRows(at: indexPaths(indexes), with: .none)
    }
    
    func items(removed indexes: CountableRange<Int>) {
        NSLog("removed \(indexes.lowerBound) ..< \(indexes.upperBound)")
        self.tableView.deleteRows(at: indexPaths(indexes), with: .none)
    }
    
}

