//
//  ViewController.swift
//  TutsplusWeather
//
//  Created by Markus Mühlberger on 31/01/2017.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionView : ConditionView!
    @IBOutlet weak var windDirectionView: WindDirectionView!
    
    @IBOutlet weak var cityTopConstraint: NSLayoutConstraint!

    fileprivate let locationManager = CLLocationManager()
    
    var debugSwitch = false
    var previousLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        cityTopConstraint.constant = -80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        debugAnimations()
        appearAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appearAnimation() {
        let flyIn = CASpringAnimation(keyPath: "position.y")
        flyIn.mass = 50.0
        flyIn.damping = 100.0
        flyIn.stiffness = 250.0
        flyIn.fromValue = view.bounds.size.height
        flyIn.toValue = temperatureLabel.layer.position.y
        flyIn.duration = 8.5
        
        temperatureLabel.layer.add(flyIn, forKey: nil)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.0
        animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationGroup.beginTime = CACurrentMediaTime() + 2
        animationGroup.fillMode = kCAFillModeBackwards
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1.0
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 2.5
        scaleDown.toValue = 1.0
        
        animationGroup.animations = [fadeIn, scaleDown]
        
        conditionView.layer.add(animationGroup, forKey: nil)
    }

    func debugAnimations() {
        debugSwitch = !debugSwitch
        
        cityTopConstraint.constant = 8
        
        UIView.animate(withDuration: 0.5, delay: 1, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let overlay = duplicateImageView(imageView: backgroundImageView, newImageName: debugSwitch ? "bg_other" : "bg_snowy")
        overlay.alpha = 0.0
        overlay.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        backgroundImageView.superview!.insertSubview(overlay, aboveSubview: backgroundImageView)
        
        UIView.animate(withDuration: 0.5, animations: { 
            overlay.alpha = 1.0
            overlay.transform = .identity
        }) { (_) in
            self.backgroundImageView.image = overlay.image
            overlay.removeFromSuperview()
        }
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { 
//            self.debugAnimations()
//        }
    }
    
    func duplicateImageView(imageView: UIImageView, newImageName: String) -> UIImageView {
        let duplicate = UIImageView(image: UIImage(named: newImageName))
        duplicate.frame = imageView.frame
        duplicate.contentMode = imageView.contentMode
        duplicate.center = imageView.center
        return duplicate
    }
}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let distance = previousLocation?.distance(from: location)
            
            if previousLocation == nil || distance! > 0.0 {
                let API = WeatherAPI.shared
                API.getWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion: { (data, error) in
                    if let data = data {
                        let json = data as! [String : Any]
                        let main = json["main"] as! [String : Any]
                        let wind = json["wind"] as! [String : Any]
                        let weather = json["weather"] as! [[String : Any]]
                        
                        self.cityLabel.text = "\(json["name"]!)"
                        self.temperatureLabel.text = "\(main["temp"]! as! Int)°"
                        self.windDirectionView.windDirection = wind["deg"] as! CGFloat
                        
                        switch (weather[0]["id"] as! Int) {
                        case 200...299:
                            self.conditionView.condition = .storm(detail: (weather[0]["description"] as! String))
                        case 300...399:
                            self.conditionView.condition = .drizzle(detail: (weather[0]["description"] as! String))
                        case 500...599:
                            self.conditionView.condition = .rain(detail: (weather[0]["description"] as! String))
                        case 600...699:
                            self.conditionView.condition = .snow(detail: (weather[0]["description"] as! String))
                        case 801...809:
                            self.conditionView.condition = .clouds(detail: (weather[0]["description"] as! String))
                        default:
                            self.conditionView.condition = .other(detail: (weather[0]["description"] as! String))
                        }
                    }
                })
                
                self.previousLocation = location
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
