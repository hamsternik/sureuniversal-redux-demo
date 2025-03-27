//
//  User.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import Foundation

public struct User: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let address: Address
    public let phone: String
    public let website: String
    public let company: Company
}

public struct Company: Codable, Hashable {
    public let name: String
    public let catchPhrase: String
    public let bs: String
}

public struct Address: Codable, Hashable {
    public struct Geo: Codable, Hashable {
        public let latitude: Double
        public let longitude: Double
        
        public init (latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Address.Geo.CodingKeys> = try decoder
                .container(keyedBy: Address.Geo.CodingKeys.self)
            let latitude = try container.decode(String.self, forKey: Address.Geo.CodingKeys.latitude)
            let longitude = try container.decode(String.self, forKey: Address.Geo.CodingKeys.longitude)
            self.latitude = try Double(latitude, format: .number.precision(.fractionLength(4)))
            self.longitude = try Double(longitude, format: .number.precision(.fractionLength(4)))
        }
    }
    
    public let street: String
    public let suite: String
    public let city: String
    public let zipcode: String
    public let geo: Geo
}

// MARK: Data

extension User {
    static let first: User = .init(
        id: 1,
        name: "Leanne Graham #1",
        username: "Bret",
        email: "",
        address: .init(street: "", suite: "", city: "", zipcode: "", geo: .init(latitude: 0, longitude: 0)),
        phone: "",
        website: "",
        company: .init(name: "", catchPhrase: "", bs: "")
    )
    
    static let second: User = .init(
        id: 2,
        name: "Ervin Howell #2",
        username: "Antonette",
        email: "",
        address: .init(street: "", suite: "", city: "", zipcode: "", geo: .init(latitude: 0, longitude: 0)),
        phone: "",
        website: "",
        company: .init(name: "", catchPhrase: "", bs: "")
    )
}
