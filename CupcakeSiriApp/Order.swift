//
//  Order.swift
//  CupcakeSiriApp
//
//  Created by Annemarie Ketola on 2/18/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation

struct Order: Codable, Hashable {
    var cake: Product
    var toppings: Set<Product>
    
    var name: String {
        if toppings.count == 0 {
            return cake.name
        } else {
            let toppingName = toppings.map { $0.name.lowercased() }
            return "\(cake.name), \(toppingName.joined(separator: ", "))."
        }
    }
    var price: Int {
        return toppings.reduce(cake.price) { $0 + $1.price }
    }
    
    var intent: OrderIntent {
        let intent = OrderIntent()
        intent.cakeName = cake.name
        intent.toppings = toppings.map { $0.name.lowercased() }
        intent.suggestedInvocationPhrase = "Give me a \(cake.name) cupcake or give me death!"
        return intent
    }
}

extension Order {
    init?(from data: Data?) {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        guard let savedOrder = try? decoder.decode(Order.self, from: data) else {
            return nil
        }
        cake = savedOrder.cake
        toppings = savedOrder.toppings
        
    }
    
    // failable init - so it won't make the order if both the cake and toppings aren't there
    init?(from intent: OrderIntent) {
        // if we can't find the cake name, exit
        guard let cake = Menu.shared.findCake(from: intent.cakeName)
            else { return nil}
    
    // convert the toppings array to array of topping products, discarding any that don't exist
    guard let toppings = intent.toppings?.compactMap({
        Menu.shared.findTopping(from: $0)
    }) else {
    // we didn't get any toppings for some reason, exit
    return nil
    }
    // both properties were loaded successfully, so create the object
    self.cake = cake
    self.toppings = Set(toppings)
    }
}
