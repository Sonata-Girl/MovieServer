//
//  Hotel.swift
//
//
//  Created by Sonata Girl on 08.04.2024.
//

import Foundation
import Vapor

struct HotelQuery: Content {
    let sort: String
    let search: String?
}
