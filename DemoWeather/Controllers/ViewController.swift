//
//  ViewController.swift
//  DemoWeather
//
//  Created by Harshil Kotecha on 26/08/20.
//  Copyright © 2020 Harshil Kotecha. All rights reserved.
//

import UIKit
 
import MapKit
class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var lblCityValue: UILabel!
    @IBOutlet weak var lblWeatherValue: UILabel!
    @IBOutlet public var mapView: MKMapView!
    let initialLocation = CLLocation(latitude: 22.3039, longitude: 70.8022)
    public let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial location in Honolulu 
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.currentLocation()
            
        }
        
    }
    @IBAction func onClickCurrentLocation(_ sender: Any) {
        self.currentLocation()
    }
    func getWeatherFromLatLong(lat:Double,long:Double)  {
        var param = [String:Any]()
        param["lat"] = "\(lat)"
        param["lon"] = "\(long)"
        param["appid"] = APIURL.WeatherKey
        
        WebServiceManager.api(APIURL.getWeatherFromLatLong, method: .get, parameters: param, headers: nil, image: nil, completionHandler: { (response,data) in
            
            let jsonDecoder = JSONDecoder()
            let responseModel = try? jsonDecoder.decode(WeatherFromLatLong.self, from: data!)
            self.lblCityValue.text = responseModel?.name ?? ""
            self.lblWeatherValue.text = String(format: "%.0f °C | °F",((responseModel?.main?.temp ?? 0.0)-273.15))
            print(response)
             
        }) { (err) in
            
        }
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        getWeatherFromLatLong(lat: mapView.camera.centerCoordinate.latitude, long: mapView.camera.centerCoordinate.longitude)
    }
    
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
          // Fallback on earlier versions
       }
       locationManager.startUpdatingLocation()
        
        self.getWeatherFromLatLong(lat: locationManager.location?.coordinate.latitude ?? 0.0, long: locationManager.location?.coordinate.longitude ?? 0.0)
    }
    
}
