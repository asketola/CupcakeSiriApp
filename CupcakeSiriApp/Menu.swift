//
//  Menu.swift
//  CupcakeSiriApp
//
//  Created by Annemarie Ketola on 2/20/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation

class Menu {
    var cakes: [Product]
    var toppings: [Product]
    
    static let shared = Menu()
    //creates a Menu.Shared that can be used anywhere in the app and have access to the .cakes and toppings
    
    private init() {
        cakes = Bundle.main.decode(from: "cupcakes.json")
        toppings = Bundle.main.decode(from: "toppings.json")
    }
    
    func findCake(from name: String?) -> Product? {
        return cakes.first { $0.name == name}
    }
    func findTopping(from name: String? ) -> Product? {
        return toppings.first { $0.name.lowercased() == name}
    }
    
}

extension Bundle {
    func decode(from fileName: String) -> [Product] {
        guard let json = url(forResource: fileName, withExtension: nil) else {
            fatalError("Failed to locate \(fileName) in app Bundle")
        }
        
        guard let jsonData = try? Data(contentsOf: json) else {
            fatalError("Failed to load \(fileName) from app bundle.") }
        let decoder = JSONDecoder()
            guard let result = try? decoder.decode([Product].self, from: jsonData) else {
                fatalError("Failed to decode \(fileName) from app Bundle")
            }
            return result.sorted {
                return $0.name < $1.name
            }
    }
}
