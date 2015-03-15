//
//  SQLiteHelper.swift
//  01-SQLite入门
//
//  Created by 陈勇 on 15/3/14.
//  Copyright (c) 2015年 zhssit. All rights reserved.
//

import Foundation

///  SQLite数据库处理帮助类
///
///  此类中封装了关于SQLite数据库处理的业务函数
class SQLiteHelper
{
    private static let instance = SQLiteHelper()
    /// 全局的数据访问接口
    class var sharedInstance: SQLiteHelper {
        return instance
    }

    var db: COpaquePointer = nil

    ///  打开数据库
    ///
    ///  :param: dbName 数据库名称
    ///
    ///  :returns: 返回 是否打开成功
    func openDatabase(dbName: String) -> Bool
    {
        let path = dbName.documentPath()
        println(path)
        return sqlite3_open(path, &db) == SQLITE_OK
    }

    ///  创建 T_Department 和 T_Employee 表
    ///
    ///  :returns: 返回 是否创建成功
    func createTable() -> Bool
    {
        let sql = "CREATE TABLE \n" +
            "IF NOT EXISTS T_Department (\n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,\n" +
            "DepartmentNo CHAR(10) NOT NULL DEFAULT '',\n" +
            "Name CHAR(50) NOT NULL DEFAULT '' \n" +
            "); \n" +
            "CREATE TABLE IF NOT EXISTS T_Employee ( \n" +
            "'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \n" +
            "'name' TEXT NOT NULL, \n" +
            "'age' INTEGER NOT NULL, \n" +
            "'department_id' INTEGER, \n" +
            "CONSTRAINT 'FK_DEP_ID' FOREIGN KEY ('department_id') REFERENCES 'T_Department' ('id') \n" +
        ");"
        return executeSql(sql)
    }

    ///  执行INSERT、UPDATE、DELETE SQL语句
    ///
    ///  :param: sql SQL语句
    ///
    ///  :returns: 返回 是否执行成功
    func executeSql(sql: String) -> Bool
    {
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }

    ///  执行SELECT SQL语句，返回结果集
    ///
    ///  :param: sql SQL语句
    ///
    ///  :returns: 返回 结果集
    func query(sql: String) -> [AnyObject]?
    {
        var dataSet: [AnyObject]?
        var stmt: COpaquePointer = nil

        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK
        {
//            println(stmt)
            dataSet = [AnyObject]()
            while sqlite3_step(stmt) == SQLITE_ROW
            {
                dataSet!.append(singleData(stmt)!)
            }
            println(dataSet!)
        }
        else
        {
            println("未知错误！")
        }
        // 释放语句，防止内存泄露！
        sqlite3_finalize(stmt)
        return dataSet
    }

    func singleData(stmt: COpaquePointer) -> [AnyObject]?
    {
        var result = [AnyObject]()
        // 返回该表的列数
        let count = sqlite3_column_count(stmt)
//        println("count=\(count)")

//        #define SQLITE_INTEGER  1
//        #define SQLITE_FLOAT    2
//        #define SQLITE_BLOB     4
//        #define SQLITE_NULL     5
//        #ifdef SQLITE_TEXT
//        # undef SQLITE_TEXT
//        #else
//        # define SQLITE_TEXT     3
//        #endif
//        #define SQLITE3_TEXT     3
        for index in 0..<count
        {
            let type = sqlite3_column_type(stmt, index)
            // 根据字段的类型，提取对应列的值
            switch type {
            case SQLITE_INTEGER:
                result.append(Int(sqlite3_column_int64(stmt, index)))
            case SQLITE_FLOAT:
                result.append(sqlite3_column_double(stmt, index))
            case SQLITE_NULL:
                result.append(NSNull())
            case SQLITE_TEXT:
                let rrrrr: UnsafePointer<UInt8> = sqlite3_column_text(stmt, index)
                let chars = UnsafePointer<CChar>(sqlite3_column_text(stmt, index))
                let str = String(CString: chars, encoding: NSUTF8StringEncoding)!
                result.append(str)
            case let type:
                println("不支持的类型 \(type)")
            }
        }
//        println(result)
        return result
    }


}