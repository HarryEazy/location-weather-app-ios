//
//  ViewController.swift
//  Clima
//



import UIKit
import CoreLocation

// add UITextFieldDelegate to allow "go" on keyboard

class WeatherViewController: UIViewController {
  

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchFieldText: UITextField!
    
    // initialise weather manager struct
    var weatherManager = WeatherManager()
    // create location manager variable
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // set location managet delegate to self
        // has to be set before request authorisation has been made
        locationManager.delegate = self
        
        // request authorisation for location data from user
        locationManager.requestWhenInUseAuthorization()
        // request location of user
        locationManager.requestLocation()
        
        // this makes the search field communicate with the view controller
        // notifies it about hat is going on in the search field
        searchFieldText.delegate = self
        
        // set weather manager delegate to self
        weatherManager.delegate = self
        
    }

    

    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        // request location of user
        locationManager.requestLocation()
        
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get last element in array for location - last element is normally the most accurate
        if let location = locations.last{
            // stop updating location
            locationManager.stopUpdatingLocation()
            // get latitude & longitude
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

// create extension of view controller to clean up code
// has all the code that deals with the UITextField
extension WeatherViewController: UITextFieldDelegate {
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        // dismisses keyboard when search pressed
        searchFieldText.endEditing(true)
        //searchFieldText.text
    }
    
    // specifies what should happen after user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismisses keyboard when search return key pressed
        searchFieldText.endEditing(true)
        return true
        
    }
    
    // useful function to do some user validation before editing has finished
    // note we use textField here which will use the textField that called the function
    // instead of specifying one text field, this is useful when you have multiple
    // textfields on screen
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // reset search bar to empty when user is done editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // use searchTextfield.text to get the weather for that city
        if let city = searchFieldText.text {
            weatherManager.fetchWeather(cityName: city)
            
        }
        
        // reset search field to empty string
        searchFieldText.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

// create extension of view controller to clean up code
// has all the code that deals with the WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
    // requirement method for protocol WeatherManagerDelegate
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        // Need to dispatch the call first to update UI in main thread
        DispatchQueue.main.async {
            // Set the temperature
            self.temperatureLabel.text = weather.temparatureString
            // set the corresponding image of the weather
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            // set corresponding city name
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    // requirement method for protocol WeatherManagerDelegate
    func didFailWithError(error: Error) {
        print(error)
    }
}
