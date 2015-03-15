//
//  Department.swift
//  01-SQLite入门
//
//  Created by 陈勇 on 15/3/15.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

import Foundation

class Department {
    var id: Int
    var no: String
    var name: String

    init(record: [AnyObject]) {
        id = record[0] as! Int
        no = record[1] as! String
        name = record[2] as! String
    }

    class func loadDepartmentList() -> [Department]? {
        // 提示：不要写 SELECT *
        let sql = "SELECT id, DepartmentNo, Name FROM T_Department;"

        // 二维数组，最外层，是记录条数，内层数`组，是“按照 SQL 查询字段的顺序”，拼接的 AnyObject
        var list = SQLiteHelper.sharedInstance.query(sql)!

        // 实例化部门数组
        var result = [Department]()

        for record in list {
            result.append(Department(record: record as! [AnyObject]))
        }

        return result
    }

}
