//
//  Product.swift
//  CupcakeSiriApp
//
//  Created by Annemarie Ketola on 2/18/19.
//  Copyright © 2019 Annemarie Ketola. All rights reserved.
//

import Foundation

struct Product: Codable, Hashable {
    var name: String
    var description: String
    var price: Int
}
