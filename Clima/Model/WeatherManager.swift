//
//  WeatherManager.swift
//  Clima
//
//  Created by Harry Eazy on 18/12/2020.


import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=95ac0c8e94fb61309a1371f577e9446c&units=metric"
    
    
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    
    func performRequest(with urlString: String){
        
        // 1. create a URL
        if let url = URL(string: urlString) {
            
            // 2. create URL session
            // creates a URL session object
            let session = URLSession(configuration: .default)
            
            // 3. giv session a task
            // use closure
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // check for error
                if error != nil {
                    // pass error to delegate
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                // check data
                if let safeData = data {
                    // add self for function calls inside a closure
                    // check weather is non optional
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
                
            }
            
            
            // 4. start the task
            // Newly-initialized tasks begin in a suspended state, so you need to call this method resume() to start the task.
            task.resume()
            
            
        }
        
        
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        // initialise JSON decoder
        let decoder = JSONDecoder()
        
        // use decoder - takes two inputs - data to decode and the decodable type
        // to specify the weather data type and not weather data object we need to add .self to weather data
        // decoder.decode can throw exception so we need to wrap in do and try block
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            // get variables from decoded data
            let temperature = decodedData.main.temp
            let conditionID = decodedData.weather[0].id
            let cityName = decodedData.name
            // initialise WeatherModel
            let weather = WeatherModel(conditionID: conditionID, cityName: cityName, temperature: temperature)
            // return the weather data type
            return weather
            
            
        } catch {
            // pass error to delegate
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
    
    
}
