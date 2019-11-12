//
//  TestViewController.swift
//  pokedexapp
//
//  Created by Paulik on 12/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import RealmSwift

class TestViewController: UIViewController {
    
    var items: Results<ToDoItem>?
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        let realm = try! Realm()
        let item = ToDoItem()
        item.id = "1"
        item.text = "test"
        item.isCompleted = true
        DispatchQueue.main.async {
            try! realm.write {
                realm.add(item)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
//        items = ToDoItem.all()
//        try! realm.write {
//            realm.add(ToDoItem(value: "Buy Milk"))
//            realm.add(ToDoItem(value: "Finish Book"))
//        }
        itemsToken = realm.objects(ToDoItem.self).observe { [weak self] changes in
//          guard let tableView = tableView else { return }

          switch changes {
          case .initial:
            print ("initial")
//            tableView.reloadData()
          case .update(_, let deletions, let insertions, let updates):
            print ("update")
//            tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
          case .error: break
          }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        itemsToken?.invalidate()
    }
    
}
