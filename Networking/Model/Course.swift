//
//  Course.swift
//  Networking
//
//  Created by mac on 02.09.2023.
//

import Foundation

struct Course: Codable {

    let id: Int
    let name: String
    let link: String
    let imageUrl: String
    let number_of_lessons: Int
    let number_of_tests: Int
}
