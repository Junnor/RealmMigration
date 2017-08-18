//
//  ViewController.swift
//  RealmMigration
//
//  Created by nyato on 2017/8/18.
//  Copyright © 2017年 nyato. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.rowHeight = 60
        }
    }
    
    private var realm: Realm!
    private var persons: Results<Person>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try realm = Realm()
            persons = realm.objects(Person.self)
            
            tableView.reloadData()
        } catch let error {
            print("error: \(error)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = persons[indexPath.row]
        
        cell.textLabel?.text = person.name

        var detail = ""
        detail = "age: \(person.age), email: \(person.email)"
        cell.detailTextLabel?.text = detail
        
        return cell
    }
    
}

