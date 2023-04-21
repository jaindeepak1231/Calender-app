//
//  DBManager.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 18/03/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

struct Event {
    
    var eventID: String!
    var followUp: String!
    var followUpType: String!
    var descriptionDetail: String!
    var tithiDate: String!
    var timing: String!
    var tithi: String!
    var toDate: String!
    var toTime: String!
    var updateStamp: String!
    var isSync: String!
    var liveDBId: String!
    var operationAction: String!
}
struct Tithi {
    
    var tithiID: String!
    var tithi : String!
    var date : String!
    var amonth : String!
    var pmonth : String!
    var vaar : String!
}

struct ToDoList {
    
    var todoID: String!
    var todoDesc : String!
    var todoDate : String!
    var todoStatus : String!
    var todoDbID : String!
    var todoAction : String!
    var todoisSync : String!
}


struct User {
    var userID:String
    var userName : String
    var password : String
    
}
class DBManager: NSObject {
    
    let field_ID = "id"
    let field_follow_up = "Appo_Follow_Up"
    let field_Follow_Up_Type = "Appo_Follow_Up_Type"
    let field_description = "description"
    let field_tithiDate = "tdate"
    let field_timing = "timing"
    let field_tithi = "tithi"
    let field_to_date = "todate"
    let field_to_time = "totime"
    let field_update_stamp = "update_stamp"
    let field_sync = "is_sync"
    let field_live_db_id = "live_db_id"
    let field_operation_action = "opr_action"
    
    
    /*Tithi Table Field */
    
    let tithi_ID = "id"
    let tithi_tithi = "tithi"
    let tithi_date = "tdate"
    let tithi_amonth = "a_month"
    let tithi_pmonth = "p_month"
    let tithi_vaar = "vaar"
    
    
    /*ToDo List Table Field */
    
    let todo_ID = "id"
    let todo_desc = "todo_desc"
    let todo_date = "todo_date"
    let todo_isSyn = "todo_isSyn"
    let todo_status = "todo_status"
    let todo_livedbID = "todo_live_db_id"
    let todo_action = "todo_action"
    
    
    /*Login Table Field */
    let user_ID = "id"
    let user_name = "user_name";
    let user_password = "password"
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "GurujiDB.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    func createUserTable(){
        
        database = FMDatabase(path: pathToDatabase!)
        
        if database != nil {
            
            if database.open() {
                
                let createUserTable = "CREATE TABLE User (\(user_ID) integer primary key autoincrement not null, \(user_name) text not null, \(user_password) text not null)"
                print(createUserTable)
                
                do {
                    try database.executeUpdate(createUserTable, values: nil)
                    //   created = true
                    print(pathToDatabase)
                    if insertUser(){
                        print("inserted")
                    }

                }
                catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                }
                database.close()
            }
            else {
                print("Could not open the database.")
            }
        }
    }
    func loadUser(username : String, password : String) -> [User]! {
        
        var users = [User]()
        
        if openDatabase() {
            let query = "SELECT * FROM User WHERE \(user_name)=? AND \(user_password)=?"
            
            do {
                print(database)
                
                let results = try database.executeQuery(query, values:[username,password] )
                
                while results.next() {
                    
                   let user = User(userID: results.string(forColumn: user_ID), userName: results.string(forColumn: user_name), password: results.string(forColumn: user_password))
                    users.append(user)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return users
    }

    func createTithiTable(){
        
        database = FMDatabase(path: pathToDatabase!)
        
        if database != nil {

                if database.open() {
        
                    let createMoviesTableQuery = "CREATE TABLE Tithi_table (\(tithi_ID) integer primary key autoincrement not null, \(tithi_tithi) text not null, \(tithi_date) text not null, \(tithi_amonth) text, \(tithi_pmonth) text not null, \(tithi_vaar) text not null)"
                    print(createMoviesTableQuery)
        
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                     //   created = true
                        print(pathToDatabase)
                        
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
    }
    
    
    //Create ToDoList Table
    func createTodoListTable(){
        
        database = FMDatabase(path: pathToDatabase!)
        
        if database != nil {
            
            if database.open() {
                
                let createTodoListTableQuery = "CREATE TABLE TodoList_table (\(todo_ID) integer primary key autoincrement not null, \(todo_desc) text not null, \(todo_date) text not null, \(todo_status) text, \(todo_livedbID) text not null, \(todo_action) text not null, \(todo_isSyn) text not null)"
                print(createTodoListTableQuery)
                
                do {
                    try database.executeUpdate(createTodoListTableQuery, values: nil)
                    //   created = true
                    print(pathToDatabase)
                    
                }
                catch {
                    print("Could not create table.")
                    print(error.localizedDescription)
                }
                database.close()
            }
            else {
                print("Could not open the database.")
            }
        }
    }
    
    
    func insertUser() -> Bool {
        var created = false
        if openDatabase() {
            
            let query = "INSERT INTO User (\(user_name), \(user_password)) values ('guruji@krishnapranami.org','pranam108');"
            
            print(query)
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            created =  true
            database.close()
        }
        return created
    }

    func insertTithi(data : Tithi!) {
        if openDatabase() {
            
            let query = "INSERT INTO Tithi_table (\(tithi_tithi), \(tithi_date), \(tithi_amonth), \(tithi_pmonth), \(tithi_vaar)) values ('\(data.tithi!)','\(data.date!)','\(data.amonth!)','\(data.pmonth!)','\(data.vaar!)');"
            
            print(query)
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            database.close()
        }
    }
    
    
    //Insert ToDoList Data
    func insertTodoList(data : ToDoList!) {
        
        if openDatabase() {
            
            let query = "INSERT INTO TodoList_table (\(todo_desc), \(todo_date), \(todo_status), \(todo_livedbID), \(todo_action), \(todo_isSyn)) values ('\(data.todoDesc!)','\(data.todoDate!)','\(data.todoStatus!)','\(data.todoDbID!)','\(data.todoAction!)','\(data.todoisSync)');"
            
            print(query)
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            database.close()
        }
    }

    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    let createMoviesTableQuery = "CREATE TABLE Guruji (\(field_ID) integer primary key autoincrement not null, \(field_follow_up) text not null, \(field_Follow_Up_Type) text not null, \(field_description) text, \(field_tithiDate) text not null, \(field_timing) text not null, \(field_tithi) text not null,\(field_to_date) text not null, \(field_to_time) text not null,\(field_live_db_id) text, \(field_sync) text, \(field_operation_action) text, \(field_update_stamp) DATETIME DEFAULT CURRENT_TIMESTAMP)"
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                        print(pathToDatabase)
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        if database != nil {
            if database.open() {
                return true
            }
        }
        return false
    }
    func insertData(data : Event!) {
        if openDatabase() {
            
            let desc = "\(data.descriptionDetail!)"
            let newDesc = desc.replacingOccurrences(of: "'", with: "\'", options: .literal, range: nil)
            print(newDesc)
            let query = "INSERT INTO Guruji (\(field_follow_up), \(field_Follow_Up_Type), \(field_description), \(field_tithiDate), \(field_timing), \(field_tithi),\(field_to_time),\(field_to_date),\(field_live_db_id),\(field_sync),\(field_operation_action)) VALUES ('\(data.followUp!)','\(data.followUpType!)',\"\(newDesc)\",'\(data.tithiDate!)','\(data.timing!)','\(data.tithi!)','\(data.toTime!)','\(data.toDate!)','\(data.liveDBId!)','\(data.isSync!)','\(data.operationAction!)');"
            
            print(query)
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            database.close()
        }
    }
    func updateEvent(withID ID: Int, data : Event) {
        if openDatabase() {
            let query = "UPDATE Guruji SET \(field_follow_up)=?,\(field_Follow_Up_Type)=?,\(field_description)=?,\(field_tithiDate)=?,\(field_timing)=?,\(field_tithi)=?,\(field_to_date)=?,\(field_to_time)=?,\(field_live_db_id)=?,\(field_sync)=?,\(field_operation_action)=? WHERE \(field_ID)=?"
            
            do {
                try database.executeUpdate(query, values: [data.followUp, data.followUpType,data.descriptionDetail,data.tithiDate,data.timing,data.tithi,data.toDate,data.toTime,data.liveDBId,data.isSync,data.operationAction, ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    func deleteAllEvents(){
        
        
        if openDatabase() {
            let query = "DELETE FROM Guruji"
            
            do {
                try database.executeUpdate(query, values: nil)
        
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }

    func deleteEvents(withID ID: Int) -> Bool {
        var deleted = false
        
        if openDatabase() {
            let query = "UPDATE Guruji SET \(field_operation_action)='d', is_sync=0 WHERE \(field_ID)=?"
            print(query)
            do {
                try database.executeUpdate(query, values: [ID])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    func loadEventsWithParam(queryString : String) -> [Event]! {
        
        var events = [Event]()
        
        if openDatabase() {
            let query = "SELECT * FROM Guruji WHERE \(queryString) AND opr_action != 'd'"
            print(query)
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    
                    let event = Event(eventID: results.string(forColumn: field_ID), followUp: results.string(forColumn: field_follow_up), followUpType: results.string(forColumn: field_Follow_Up_Type), descriptionDetail: results.string(forColumn: field_description), tithiDate: results.string(forColumn: field_tithiDate), timing: results.string(forColumn: field_timing), tithi: results.string(forColumn: field_tithi),toDate: results.string(forColumn: field_to_date),toTime: results.string(forColumn: field_to_time),updateStamp: results.string(forColumn: field_update_stamp),isSync: results.string(forColumn: field_sync),liveDBId: results.string(forColumn: field_live_db_id),operationAction: results.string(forColumn: field_operation_action))
                    
                    if (events.count < 0) {
                        events = [Event]()
                    }
//                    if(event.operationAction != "d") {
                        events.append(event)
//                        print(events)
//                    }
                    
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return events
    }

    func loadEvents() -> [Event]! {
        
        var events = [Event]()
        
        if openDatabase() {
            let query = "SELECT * FROM Guruji WHERE opr_action != 'd'"
            
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    
                    let event = Event(eventID: results.string(forColumn: field_ID), followUp: results.string(forColumn: field_follow_up), followUpType: results.string(forColumn: field_Follow_Up_Type), descriptionDetail: results.string(forColumn: field_description), tithiDate: results.string(forColumn: field_tithiDate), timing: results.string(forColumn: field_timing), tithi: results.string(forColumn: field_tithi),toDate: results.string(forColumn: field_to_date),toTime: results.string(forColumn: field_to_time),updateStamp: results.string(forColumn: field_update_stamp),isSync: results.string(forColumn: field_sync),liveDBId: results.string(forColumn: field_live_db_id),operationAction: results.string(forColumn: field_operation_action))
                    
                    if(event.operationAction != "d") {
                        events.append(event)
//                        print(events)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return events
    }
    func loadEventsSync() -> [Event]! {
        
        var events = [Event]()
        
        if openDatabase() {
            let query = "SELECT * FROM Guruji WHERE is_sync=0"
            print(query)
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    
                    let event = Event(eventID: results.string(forColumn: field_ID), followUp: results.string(forColumn: field_follow_up), followUpType: results.string(forColumn: field_Follow_Up_Type), descriptionDetail: results.string(forColumn: field_description), tithiDate: results.string(forColumn: field_tithiDate), timing: results.string(forColumn: field_timing), tithi: results.string(forColumn: field_tithi),toDate: results.string(forColumn: field_to_date),toTime: results.string(forColumn: field_to_time),updateStamp: results.string(forColumn: field_update_stamp),isSync: results.string(forColumn: field_sync),liveDBId: results.string(forColumn: field_live_db_id),operationAction: results.string(forColumn: field_operation_action))
                    
                   // if(event.operationAction != "d") {
                        events.append(event)
                        //                        print(events)
                    //}
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return events
    }

    func loadEventsByQuery(query : String) -> [Event]! {
        
        var events = [Event]()
        
        if openDatabase() {
//            let query = "SELECT * FROM Guruji"
            
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    
                    let event = Event(eventID: results.string(forColumn: field_ID), followUp: results.string(forColumn: field_follow_up), followUpType: results.string(forColumn: field_Follow_Up_Type), descriptionDetail: results.string(forColumn: field_description), tithiDate: results.string(forColumn: field_tithiDate), timing: results.string(forColumn: field_timing), tithi: results.string(forColumn: field_tithi),toDate: results.string(forColumn: field_to_date),toTime: results.string(forColumn: field_to_time),updateStamp: results.string(forColumn: field_update_stamp),isSync: results.string(forColumn: field_sync),liveDBId: results.string(forColumn: field_live_db_id),operationAction: results.string(forColumn: field_operation_action))
                    
                    if(event.operationAction != "d") {
                        events.append(event)
//                        print(events)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return events
    }

    func loadSelectTithi(withID tithiDate: String) -> [Tithi]! {
        
        var tithiList: [Tithi]!
        
        if openDatabase() {
            let query = "SELECT * FROM Tithi_table WHERE \(tithi_date)=?"
            
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: [tithiDate])
                print(results)
                while results.next() {
                    
                    let tithi = Tithi(tithiID: results.string(forColumn: tithi_ID), tithi: results.string(forColumn: tithi_tithi), date: results.string(forColumn: tithi_date), amonth: results.string(forColumn: tithi_amonth), pmonth: results.string(forColumn: tithi_pmonth), vaar: results.string(forColumn: tithi_vaar))
                    
                    if tithiList == nil {
                        tithiList = [Tithi]()
                    }
                    tithiList.append(tithi)
                    print(tithiList)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return tithiList
    }
    func loadSelectTithiByQuery(query: String) -> [Tithi]! {
        
        var tithiList: [Tithi]!
        
        if openDatabase() {
//            let query = "SELECT * FROM Tithi_table WHERE \(tithi_date)=?"
            
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: nil)
                print(results)
                while results.next() {
                    
                    let tithi = Tithi(tithiID: results.string(forColumn: tithi_ID), tithi: results.string(forColumn: tithi_tithi), date: results.string(forColumn: tithi_date), amonth: results.string(forColumn: tithi_amonth), pmonth: results.string(forColumn: tithi_pmonth), vaar: results.string(forColumn: tithi_vaar))
                    
                    if tithiList == nil {
                        tithiList = [Tithi]()
                    }
                    tithiList.append(tithi)
//                    print(tithiList)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return tithiList
    }
    
    
    
    func loadSelectTodoListByQuery(query: String) -> [ToDoList]! {
        
        var todoList: [ToDoList]!
        
        if openDatabase() {
            //            let query = "SELECT * FROM Tithi_table WHERE \(tithi_date)=?"
            
            do {
                print(database)
                
                let results = try database.executeQuery(query, values: nil)
                print(results)
                while results.next() {
                    
                    let todo = ToDoList(todoID: results.string(forColumn: todo_ID), todoDesc: results.string(forColumn: todo_desc), todoDate: results.string(forColumn: todo_date), todoStatus: results.string(forColumn: todo_status), todoDbID: results.string(forColumn: todo_livedbID), todoAction: results.string(forColumn: todo_action), todoisSync: results.string(forColumn: todo_isSyn))
                    
                    
                    if todoList == nil {
                        todoList = [ToDoList]()
                    }
                    todoList.append(todo)
                    //                    print(tithiList)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return todoList
    }


}
