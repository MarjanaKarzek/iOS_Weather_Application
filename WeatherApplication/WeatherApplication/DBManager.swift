//
//  DBManager.swift
//  WeatherApplication
//
//  Created by Marjana on 07.08.17.
//  Copyright © 2017 Marjana Karzek. All rights reserved.
//

import Foundation
import SQLite

class DBManager{
    static let shared:DBManager = DBManager()
    private let db: Connection?
    
    private let tableUser = Table("users")
    private let id = Expression<Int64>("id")
    private let username = Expression<String>("username")
    private let password = Expression<String>("password")
    private let name = Expression<String?>("name")
    private let homelocation = Expression<String?>("homelocation")
    private let previewAmount = Expression<Int64>("previewAmount")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do{
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            db = nil
            print("Unable to open database")
        }
    }
    
    func createUserTable(){
        if let database = db {
            do{
                try database.run(tableUser.create(ifNotExists: true) { table in
                    table.column(id, primaryKey: true)
                    table.column(username, unique: true)
                    table.column(password)
                    table.column(name)
                    table.column(homelocation)
                    table.column(previewAmount, check: previewAmount>0 && previewAmount<17, defaultValue: 10)
                    
                })
            } catch {
                print("Unable to create user table")
            }
        }else {
            print("Unable to open database")
        }
    }
    
    func insertUser(usernameInput: String, passwordInput: String) -> Int64?{
        do {
            let insert = tableUser.insert(username <- usernameInput, password <- passwordInput)
            if let database = db {
                let id = try database.run(insert)
                return id
            } else {
                print("Unable to open database")
            }
        } catch {
        }
        return nil
    }
    
    func showPasswordFor(usernameInput: String) -> String?{
        do {
            let query = tableUser.select(password)
                    .filter(username == usernameInput)
            if let database = db {
                for user in try database.prepare(query){
                    return user[password]
                }
            } else {
                print("Unable to open database")
            }
        } catch {
        }
        return nil
    }
    
    func showUserBy(idInput: Int64) -> User?{
        do {
            let query = tableUser.select(tableUser[*])
                .filter(id == idInput)
            if let database = db {
                for user in try database.prepare(query){
                    return User(id: user[id],
                                username: user[username],
                                password: user[password],
                                name: user[name] ?? "",
                                homelocation: user[homelocation] ?? "",
                                previewAmount: user[previewAmount])
                }
            } else {
                print("Unable to open database")
            }
        } catch {
        }
        return nil
    }
    
    func showUserIDFor(usernameInput: String) -> Int64 {
        do {
            let query = tableUser.select(id)
                .filter(username == usernameInput)
            if let database = db {
                for user in try database.prepare(query){
                    return user[id]
                }
            } else {
                print("Unable to open database")
            }
        } catch {
        }
        return 0
    }
    
    func updateUserNameBy(idInput: Int64, nameInput: String){
        do {
            let user = tableUser.filter(id == idInput)
            if let database = db {
                try database.run(user.update(name <- nameInput))
            } else {
                print("Unable to open database")
            }
        } catch {
            print("Update failed")
        }
    }
    
    func updateUserHomelocationBy(idInput: Int64, homelocationInput: String){
        do {
            let user = tableUser.filter(id == idInput)
            if let database = db {
                try database.run(user.update(homelocation <- homelocationInput))
            } else {
                print("Unable to open database")
            }
        } catch {
            print("Update failed")
        }
    }
    
    func updateUserPreviewAmountBy(idInput: Int64, previewAmountInput: Int64){
        do {
            let user = tableUser.filter(id == idInput)
            if let database = db {
                try database.run(user.update(previewAmount <- previewAmountInput))
            } else {
                print("Unable to open database")
            }
        } catch {
            print("Update failed")
        }
    }
    
}
/*
 Swift Type     SQLite Type
 Int64*         INTEGER
 Double         REAL
 String         TEXT
 nil            NULL
 SQLite.Blob†	BLOB
 */

/*
 let id = Expression<Int64>("id")
 let email = Expression<String>("email")
 let balance = Expression<Double>("balance")
 let verified = Expression<Bool>("verified")
 */

/*
 let name = Expression<String?>("name")
 */

/*
 let users = Table("users")
 */

/*
 try db.run(users.create { t in     // CREATE TABLE "users" (
 t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
 t.column(email, unique: true)  //     "email" TEXT UNIQUE NOT NULL,
 t.column(name)                 //     "name" TEXT
 })                                 // )

 try db.run(users.create(ifNotExists: true) { t in /* ... */ })
  */
