//
//  ToppingsViewController.swift
//  CupcakeSiriApp
//
//  Created by Annemarie Ketola on 2/18/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit

class ToppingsViewController: UITableViewController {

    var cake: Product!
    var selectedToppings = Set<Product>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Toppings"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Place Order", style: .plain, target: self, action: #selector(placeOrder))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu.shared.toppings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let topping = Menu.shared.toppings[indexPath.row]
        cell.textLabel?.text = "\(topping.name) - $\(topping.price)"
        cell.detailTextLabel?.text = topping.description
        
        if selectedToppings.contains(topping) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pull out the cell that was tapped
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError("Unable to find the cell that was tapped.")
        }
        // figure out which  topping this is attached to
        let topping = Menu.shared.toppings[indexPath.row]
        if cell.accessoryType == .checkmark {
            // this was checked, uncheck it
            cell.accessoryType = .none
            selectedToppings.remove(topping)
        } else {
            // this wasn't checked, so check it
            cell.accessoryType = .checkmark
            selectedToppings.insert(topping)
        }
        // remove the highlight for this cell
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @objc func placeOrder(){
        
        guard let orderViewController = storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as? OrderViewController else {
            fatalError("Unable to load OrderViewController from storyboard")
        }
        
        // pass inb the cake as a topping, then show the VC
        orderViewController.cake = cake
        orderViewController.toppings = selectedToppings
        
        navigationController?.pushViewController(orderViewController, animated: true)
    }

}
