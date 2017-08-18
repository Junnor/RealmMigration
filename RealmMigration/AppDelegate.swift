//
//  AppDelegate.swift
//  RealmMigration
//
//  Created by nyato on 2017/8/18.
//  Copyright © 2017年 nyato. All rights reserved.
//

import UIKit
import RealmSwift

class Person: Object {
    dynamic var name = ""      // v0
    dynamic var age = 0        // v0
    
    dynamic var email = ""     // v1
    
    override static func primaryKey() -> String? {
        return "name"
    }
}


let currentSchemaVersion: UInt64 = 1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion,
                                         migrationBlock: { (migration, oldSchemaVersion) in
                                            
                                            print("oldSchemaVersion: \(oldSchemaVersion)")
                                            
                                            if oldSchemaVersion < 1 {
                                                
                                                AppDelegate.migrateFrom0To1(with: migration)
                                            }
                                            
                                            
        })
        
        
        Realm.Configuration.defaultConfiguration = config
        
        
        AppDelegate.useVersion1()
        
        return true
    }
    
    static func migrateFrom0To1(with migration: Migration) {
        
        print("migrateFrom0To1")
        
        migration.enumerateObjects(ofType: Person.className()) { (oldObject, newObject) in
            newObject?["email"] = ""
        }
    }

    static func useVersion1() {
        let tom = Person()
        tom.name = "tom"
        tom.age = 54
        tom.email = "222@apple.com"
        
        let bruno = Person()
        bruno.name = "bruno"
        bruno.age = 31
        bruno.email = "111@apple.com"
        
        let taylor = Person()
        taylor.name = "taylor"
        taylor.age = 27
        taylor.email = "333@apple.com"
        
        let realm = try! Realm()
        try! realm.write {
            realm.add([taylor, bruno, tom], update: true)
        }
    }
    
}

