//
//  ViewController.swift
//  Coffee Tracker
//
//  Created by Antonio Pedron on 2023-09-12.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request HealthKit authorization when the view loads
        requestHealthKitAuthorization()
    }

    @IBAction func trackDripCoffee(_ sender: UIButton) {
        saveCaffeineSample(75, brewType: "Drip - 250ml")
        displayConfirmationAlert()
    }

    @IBAction func trackEspresso(_ sender: UIButton) {
        saveCaffeineSample(140, brewType: "Espresso Double - 40ml")
        displayConfirmationAlert()
    }

    @IBAction func trackAeroPress(_ sender: UIButton) {
        saveCaffeineSample(110, brewType: "AeroPress - 220ml")
        displayConfirmationAlert()
    }
    
    @IBAction func trackNespressoPod(_ sender: UIButton) {
        saveCaffeineSample(80, brewType: "Nespresso Pod - 60ml")
        displayConfirmationAlert()
    }

    func requestHealthKitAuthorization() {
        let caffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!
        
        healthStore.requestAuthorization(toShare: [caffeineType], read: [caffeineType]) { (success, error) in
            if success {
                print("HealthKit authorization granted for reading and writing.")
            } else {
                if let error = error {
                    print("HealthKit authorization denied with error: \(error.localizedDescription)")
                }
            }
        }
    }

    func saveCaffeineSample(_ caffeineAmount: Double, brewType: String) {
        let caffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)
        let caffeineAmount = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: caffeineAmount)
        let caffeineSample = HKQuantitySample(type: caffeineType!, quantity: caffeineAmount, start: Date(), end: Date(), metadata: ["Type of brew" : brewType])

        healthStore.save(caffeineSample) { (success, error) in
            if success {
                print("Caffeine intake saved to HealthKit")
                // Update UI to reflect the saved data
            } else if let error = error {
                print("Error saving caffeine intake: \(error.localizedDescription)")
            }
        }
    }
    
    func displayConfirmationAlert() {
        let alert = UIAlertController(title: "Logged", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
