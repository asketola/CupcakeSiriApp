//
//  OrderViewController.swift
//  CupcakeSiriApp
//
//  Created by Annemarie Ketola on 2/18/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import UIKit
import Intents

class OrderViewController: UIViewController {
    
    var cake: Product!
    var toppings = Set<Product>()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = imageView.image
        imageView.image = nil
        imageView.image = image
        
        let newOrder = Order(cake: cake, toppings: toppings)
        showDetails(newOrder)
        send(newOrder)
        donate(newOrder)
        
        title = "All Set!"
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    // updates user interface
    func showDetails ( _ order: Order) {
        details.text = order.name
        cost.text = "$\(order.price)"
    }
    
    
    func send(_ order: Order) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(order)
            print(data)
        } catch {
            print("Failed to create order.")
        }
    }
    
    @objc func done() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func donate(_ order: Order) {
        let activity = NSUserActivity(activityType: "com.UpEarlyApps.CupcakeSiriApp.order")
        
        // create title
        let orderName = order.name
        
        if ["A", "E", "I", "O", "U"].contains(orderName.first) {
            activity.title = "Order an \(orderName)."
        } else {
            activity.title = "Order a \(orderName)."
        }
        
        // allow Siri to index this and use it for voice-matched queries
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        
        let encoder = JSONEncoder()
        if let orderData = try? encoder.encode(order) {
            activity.userInfo = ["order" : orderData]
        }
        
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier(order.name)
        
        //suggest a way for the user to trigger this shortcut
        activity.suggestedInvocationPhrase = "I need a cupcake!"
        
        self.userActivity = activity
        let simplenumber = 1
    }


}
