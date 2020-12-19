//
//  WeatherModel.swift
//  Clima
//
//  Created by Harry Eazy on 18/12/2020.


import Foundation


struct WeatherModel {
    
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    // computed variable using method getConditionName
    var conditionName: String {
        return getConditionName(weatherId: conditionID)
    }
    var temparatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    
    // method to get the relevant picture associated with the weather ID from the API
    func getConditionName(weatherId: Int) -> String {
        
        switch weatherId {
        
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.fog"
        default:
            return "cloud"
        }
        
    
    
    
}



    
}
