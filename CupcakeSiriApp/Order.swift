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
}
