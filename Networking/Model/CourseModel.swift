//
//  Course.swift
//  Networking
//
//  Created by mac on 02.09.2023.
//

import Foundation

struct CourseModel: Codable {

    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
