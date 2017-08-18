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
    
    override static func primaryKey() -> String? {
        return "name"
    }
}


let currentSchemaVersion: UInt64 = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion,
                                         migrationBlock: { (migration, oldSchemaVersion) in
                                            
                                            print("oldSchemaVersion: \(oldSchemaVersion)")
                                            
         
        })
        
        print("before, version: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        
        Realm.Configuration.defaultConfiguration = config
        
        print("after, version: \(Realm.Configuration.defaultConfiguration.schemaVersion)")
        
        AppDelegate.useVersion0()
        
        return true
    }
    
    static func useVersion0() {
        let tom = Person()
        tom.name = "tom"
        tom.age = 54
        
        let bruno = Person()
        bruno.name = "bruno"
        bruno.age = 31
        
        let taylor = Person()
        taylor.name = "taylor"
        taylor.age = 27
        
        let realm = try! Realm()
        try! realm.write {
            realm.add([taylor, bruno, tom], update: true)
        }
    }
}

