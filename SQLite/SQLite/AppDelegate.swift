//
//  AppDelegate.swift
//  SQLite
//
//  Created by 陈勇 on 15/3/15.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        openDB()

        // 测试代码
        var sql = "SELECT dep.id, dep.DepartmentNo, dep.Name FROM T_Department dep"
        //        sql = "SELECT * FROM T_Employee"
        SQLiteHelper.sharedInstance.query(sql)
        // 打开连接
        return true
    }

    func openDB()
    {
        var result = SQLiteHelper.sharedInstance.openDatabase("SCCE.db")
        if result
        {
            println("打开数据库连接成功")
            // 创建数据表
            if SQLiteHelper.sharedInstance.createTable()
            {
                println("创建表成功")

            }
            else
            {
                println("创建表失败！")
            }
        }
        else
        {
            println("打开数据库连接失败！")
        }
        
    }
    
    
}

