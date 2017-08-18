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
//    dynamic var name = ""      // v0
    dynamic var age = 0        // v0
    
    dynamic var email = ""     // v1
    
    dynamic var fullname = ""   // v2
    
    override static func primaryKey() -> String? {
        return "fullname"
    }
}


let currentSchemaVersion: UInt64 = 2

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion,
                                         migrationBlock: { (migration, oldSchemaVersion) in
                                            
                                            print("oldSchemaVersion: \(oldSchemaVersion)")
                                            
                                            if oldSchemaVersion < 2 {
                                                
                                                AppDelegate.migrateFrom1To2(with: migration)
                                            }
                                            
                                            
        })
        
        print("before, version: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        
        Realm.Configuration.defaultConfiguration = config
        
        print("after, version: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        
        AppDelegate.useVersion1To2()
        
        return true
    }
    
    static func migrateFrom1To2(with migration: Migration) {
        print("migrateFrom1To2")
        migration.renameProperty(onType: Person.className(), from: "name", to: "fullname")
    }

    
    static func useVersion1To2() {
        let tom = Person()
        tom.fullname = "tom"
        tom.age = 54
        tom.email = "222@apple.com"
        
        let bruno = Person()
        bruno.fullname = "bruno"
        bruno.age = 31
        bruno.email = "111@apple.com"
        
        let taylor = Person()
        taylor.fullname = "taylor"
        taylor.age = 27
        taylor.email = "333@apple.com"
        
        let realm = try! Realm()
        try! realm.write {
            realm.add([taylor, bruno, tom], update: true)
        }
    }
}

