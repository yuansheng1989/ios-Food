//
//  DataModelClasses.swift
//  Purpose - Classes and structs that describe the shape of entities
//

import Foundation

// MARK: - Constructs for importing data

// Write a struct or class to describe the shape of each imported or externally-sourced entity
struct NdbSearchPackage: Decodable {
    let list: NdbSearchList
}

struct NdbSearchList: Decodable {
    let q: String
    let sr: String
    let start: Int
    let end: Int
    let total: Int
    let group: String
    let sort: String
    let item: [NdbSearchListItem]
}

struct NdbSearchListItem: Decodable {
    let offset: Int
    let group: String
    let name: String
    let ndbno: String
    let ds: String
    let manu: String
}

// Example shape for a "Country" entity
struct Country: Decodable {
    let name: String
    let capital: String
    let region: String
}

// MARK: - Constructs for data within the app

struct ExampleAdd {
    let name: String
    let quantity: Int
}

// Write a struct or class (below) to describe the shape of each entity
