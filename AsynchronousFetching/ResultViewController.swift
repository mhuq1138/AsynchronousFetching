//
//  ResultViewController.swift
//  AsynchronousFetching
//
//  Created by Mazharul Huq on 2/27/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UITableViewController {
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    lazy var coreDataStack =  CoreDataStack(modelName: "PersonList")
    
    var persons:[Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.getAsynchronousFetch()
    }
    
    func getAsynchronousFetch(){
        //1
        let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
        //2
        let asyncFetchRequest = NSAsynchronousFetchRequest<Person>(fetchRequest: fetchRequest) { [unowned self] (result: NSAsynchronousFetchResult)
            in
            
            guard let persons = result.finalResult else {
                return
            }
            self.persons = persons
            print(persons.count)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
        }
        //3
        do {
            try coreDataStack.managedContext.execute(asyncFetchRequest)
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    @IBAction func changeTapped(_ sender: Any) {
        self.headerView.backgroundColor = UIColor.red
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let person = persons[indexPath.row]
        cell.textLabel!.text = person.name
        cell.detailTextLabel!.text = "age: \(person.age)"
        return cell
    }
}
