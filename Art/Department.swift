//
//  Department.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import Foundation

struct Department: Identifiable, Codable, Hashable {
    let id = UUID().uuidString
    var departmentId: Int
    var displayName: String
    
    enum CodingKeys: CodingKey {
        case departmentId, displayName
    }
}
