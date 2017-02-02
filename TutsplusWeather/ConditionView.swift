//
//  ConditionView.swift
//  TutsplusWeather
//
//  Created by Markus Mühlberger on 01/02/2017.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import UIKit

enum WeatherCondition {
    case clouds(detail: String)
    case drizzle(detail: String)
    case rain(detail: String)
    case storm(detail: String)
    case snow(detail: String)
    case other(detail: String)
}

@IBDesignable
class ConditionView : UIControl {
    public var condition : WeatherCondition = .other(detail: "Fair") {
        didSet {
            switch condition {
            case .clouds(detail: let detail):
                self.imageView.image = UIImage(named: "Clouds")
                self.label.text = detail.capitalized
            case .drizzle(detail: let detail):
                self.imageView.image = UIImage(named: "Drizzle")
                self.label.text = detail.capitalized
            case .rain(detail: let detail):
                self.imageView.image = UIImage(named: "Rain")
                self.label.text = detail.capitalized
            case .storm(detail: let detail):
                self.imageView.image = UIImage(named: "Storm")
                self.label.text = detail.capitalized
            case .snow(detail: let detail):
                self.imageView.image = UIImage(named: "Snow")
                self.label.text = detail.capitalized
            case .other(detail: let detail):
                self.imageView.image = UIImage(named: "Clear")
                self.label.text = detail.capitalized
            }
        }
    }
    
    @IBInspectable
    public var spacing : CGFloat = 8 {
        didSet {
            spacingConstraint?.constant = 8
        }
    }
    var spacingConstraint : NSLayoutConstraint?
    
    
    lazy var imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 36, weight: UIFontWeightRegular)
        l.textColor = .white
        l.textAlignment = .center
        l.shadowColor = .black
        l.shadowOffset = CGSize(width: 1, height: 1)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    func initializeView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(label)
        
        spacingConstraint = label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: self.spacing)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            spacingConstraint!,
            label.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    override func prepareForInterfaceBuilder() {
        condition = .drizzle(detail: "Sample Condition")
    }
}
