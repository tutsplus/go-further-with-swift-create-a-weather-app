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
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityTopConstraint: NSLayoutConstraint!

    fileprivate let locationManager = CLLocationManager()
    
    var debugSwitch = false
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { 
            self.debugAnimations()
        }
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
        // TODO: Do something with the location manager
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }
}
