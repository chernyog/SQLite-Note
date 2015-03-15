//
//  DepartmentViewController.swift
//  01-SQLite入门
//
//  Created by 陈勇 on 15/3/15.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

import UIKit

class DepartmentViewController: UITableViewController {

    lazy var dataList:[AnyObject]? = {
        return Department.loadDepartmentList()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DepartmentCell", forIndexPath: indexPath) as! UITableViewCell

        let department = dataList![indexPath.row] as! Department
        cell.textLabel?.text = department.name
        return cell
    }
}
