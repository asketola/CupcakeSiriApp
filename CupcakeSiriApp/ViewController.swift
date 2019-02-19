//
//  ViewController.swift
//  CupcakeSiriApp
//
//  Created by Annemarie Ketola on 2/18/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var cakes = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cupcake Country"
        
        // find cupcakes.json in our bundle
        guard let url = Bundle.main.url(forResource: "cupcakes", withExtension: "json") else {
            fatalError("Can't find cupcakes.json in app Bundle")
        }
        // load it into a Data instance and decode it to a Product array
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            cakes = (try? decoder.decode([Product].self, from: data)) ?? [Product]()
            
            //sort the cupcakes alphabetically
            cakes.sort {
                return $0.name < $1.name
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cakes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cake = cakes[indexPath.row]
        cell.textLabel?.text = "\(cake.name) - $\(cake.price)"
        cell.detailTextLabel?.text = cake.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let toppingsViewController = storyboard?.instantiateViewController(withIdentifier: "ToppingsViewController") as? ToppingsViewController else {
            fatalError("Unable to load ToppingsViewController from storyboard.")
        }
        toppingsViewController.cake = cakes[indexPath.row]
        navigationController?.pushViewController(toppingsViewController, animated: true)
    }
}

