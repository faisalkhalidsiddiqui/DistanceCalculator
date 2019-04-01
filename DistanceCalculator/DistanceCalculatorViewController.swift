//
//  ViewController.swift
//  DistanceCalculator
//
//  Created by FAISAL KHALID on 4/1/19.
//  Copyright © 2019 Faisal Khalid. All rights reserved.
//

import UIKit
import Foundation

class DistanceCalculatorViewController: UIViewController,UITextFieldDelegate {
 
    
    @IBOutlet weak var latATextField: UITextField!
    @IBOutlet weak var longATextField: UITextField!
    @IBOutlet weak var latBTextField: UITextField!
    @IBOutlet weak var longBTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func onCalculateBtnPressed(_ sender: Any) {
        
        guard let latA = Double(latATextField.text!) else {
            showValidationError(message: "Please enter valid point A latitute")
            return
        }
        guard let longA = Double(longATextField.text!) else {
            showValidationError(message: "Please enter valid point A longitute")
            return
        }
        guard let latB = Double(latBTextField.text!) else {
            showValidationError(message: "Please enter valid point B langitutue")
            return
        }
        guard let longB = Double(longBTextField.text!) else {
            showValidationError(message: "Please enter valid point B longitude")
            return
        }
        
        let pointA:Point = Point(latitude:latA, longitude: longA)
        let pointB:Point = Point(latitude: latB, longitude:  longB)
        let distance = calculateDistanceUsingHaversineInMeters(pointA: pointA, pointB: pointB)
     
      
        DispatchQueue.main.async {
            self.resultLabel.text = "APPROX \(distance) Meters"
        }


    }
    
    func calculateDistanceUsingHaversineInMeters(pointA:Point,pointB:Point) -> Double {
        /*
         Forumula taken from
         https://en.wikipedia.org/wiki/Haversine_formula
         2 * earthRadiusInMeters * asin(sqrt(pow(sin(deltaLat/2.0),2) + cos(latA) * cos(latB) * pow(sin(deltaLong/2.0), 2)))
         */
        
        let earthRadiusInMeters:Double = 6371000; // in meters
        let deltaLat =  degreesToRadians(degrees: pointB.latitude -  pointA.latitude )
        let deltaLong =  degreesToRadians(degrees: pointB.longitude -  pointA.longitude )
        let latA =  degreesToRadians(degrees: pointA.latitude )
        let latB =  degreesToRadians(degrees: pointB.latitude )
        let a =  pow(sin(deltaLat/2.0),2) + cos(latA) * cos(latB) * pow(sin(deltaLong/2.0), 2)
        let distance = 2 * earthRadiusInMeters * asin(sqrt(a))

        return Double(String(format: "%.2f", distance))!
        
    }
    func degreesToRadians(degrees: Double) -> Double {
        let pi = 3.14159
        return degrees * pi / 180.0
    }
    
    
    struct Point {
        var latitude:Double
        var longitude:Double
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890."
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
        
    }
    
    func showValidationError(message:String){
        let alert = UIAlertController(title: "Invalid Point", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func autoFillPoints(_ sender: Any) {
        DispatchQueue.main.async {
            self.latATextField.text = "25.329497"
            self.longATextField.text = "55.5076983"
            self.latBTextField.text = "25.291112"
            self.longBTextField.text = "55.500655"
            self.resultLabel.text = ""

        }
    }
    
    @IBAction func resetPoints(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.latATextField.text = ""
            self.longATextField.text = ""
            self.latBTextField.text = ""
            self.longBTextField.text = ""
            self.resultLabel.text = ""
        }
    }
}

