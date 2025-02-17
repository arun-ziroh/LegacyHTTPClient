//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

struct PeopleListResponse: Codable, Sendable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Person]
    
    static func getMock() -> PeopleListResponse? {
        guard let url = Bundle.module.url(forResource: "peopleListResponse", withExtension: "json") else { return nil }
        if let data = try? Data(contentsOf: url) {
            let model = try? JSONDecoder().decode(Self.self, from: data)
            return model
        }
        return nil
    }
}

struct Person: Codable, Sendable {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, height, mass, gender, films, species, vehicles, starships, created, edited, url, homeworld
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
    }
}
