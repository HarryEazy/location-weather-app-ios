//
//  WeatherData.swift
//  Clima
//
//  Created by Harry Eazy on 18/12/2020.


import Foundation
// structs to parse JSON data
// names need to be exact matches to JSON data
// decodable protocol
// A type that can decode itself from an external representation.
// codable is a type alias for decodable and encodable
struct WeatherData: Codable {
    let name: String
    // get temp from main
    let main: Main
    // weather holds an array of items
    // need to wrap in square brackets
    let weather: [Weather]
    
}

// as temp is in main we need a seperate struct for main as this is an JS object
// one var that is called temp 
struct Main: Codable {
    let temp: Double
}

// get id of weather to select appropiate image to display on app
struct Weather: Codable {
    let id: Int
}
