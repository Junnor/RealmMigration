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
    
//    dynamic var fullname = ""   // v2
    
    dynamic var firstName = ""     // v3
    dynamic var lastName = ""      // v3
    
    override static func primaryKey() -> String? {
        return "firstName"
    }
}


let currentSchemaVersion: UInt64 = 3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion,
                                         migrationBlock: { (migration, oldSchemaVersion) in
                                            
                                            print("oldSchemaVersion: \(oldSchemaVersion)")
                                            
                                            if oldSchemaVersion < 3 {
                                                self.migrateFrom2To3(with: migration)
                                            }
                                            
                                            
        })
        
        
        Realm.Configuration.defaultConfiguration = config
        

        useVersion2To3()
        
        return true
    }
    
    func migrateFrom2To3(with migration: Migration) {
        print("migrateFrom2To3")
        migration.enumerateObjects(ofType: Person.className()) { (oldObject, newObject) in
            guard let fullname = oldObject?["fullname"] as? String else {
                fatalError("fullName is not a string")
            }
            
            newObject?["firstName"] = fullname
            newObject?["lastName"] = ""
        }
    }

    
    
    func useVersion2To3() {
        let tom = Person()
        tom.firstName = "tom"
        tom.lastName = "Zhu"
        tom.age = 54
        tom.email = "222@apple.com"
        
        let bruno = Person()
        bruno.firstName = "bruno"
        bruno.lastName = "Zhu"
        bruno.age = 31
        bruno.email = "111@apple.com"
        
        let taylor = Person()
        taylor.firstName = "taylor"
        taylor.lastName = "Zhu"
        taylor.age = 27
        taylor.email = "333@apple.com"
        
        let realm = try! Realm()
        try! realm.write {
            realm.add([taylor, bruno, tom], update: true)
        }
    }
}

