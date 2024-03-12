//
//  UIView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-24.
//

import Foundation
import SnapKit
import UIKit

// TODO: refactor extensions to protocols

extension UIView {
    func getAllSubviews() -> [UIView] {
        subviews + subviews.flatMap { $0.getAllSubviews() }
    }
    
    func getAllSubviewNames() -> [String] {
        getAllSubviews().map({ $0.getClassName() })
    }

    func containsView(of typeString: String) -> Bool {
        getAllSubviews().contains(where: { $0.getClassName() == typeString })
    }
    
    func getFirstSubview(of typeString: String) -> UIView? {
        getAllSubviews().first(where: { $0.getClassName() == typeString })
    }
    
    func getClassName() -> String {
        String(describing: type(of: self))
    }
}

extension UIView {
    func addGradient(_ colors: [UIColor],
                     locations: [NSNumber] = [0, 1],
                     startPoint: CGPoint = CGPoint(x: 0, y: 0),
                     endPoint: CGPoint = CGPoint(x: 0, y: 1),
                     frame: CGRect? = nil) -> CAGradientLayer {
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()

        // Set the colors and locations for the gradient layer
        gradientLayer.colors = colors.map{ $0.cgColor }
        gradientLayer.locations = locations

        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        // Set the frame to the layer
        if let frame = frame {
            gradientLayer.frame = frame
        } else {
            gradientLayer.frame = self.frame
        }

        // Add the gradient layer as a sublayer to the background view
        layer.insertSublayer(gradientLayer, at: 0)

        return gradientLayer
   }
    
    
}
