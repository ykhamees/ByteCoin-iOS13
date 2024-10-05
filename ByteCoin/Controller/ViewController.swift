//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        // Set ViewController as the delegate of CoinManager
        coinManager.delegate = self
    }
    
    // UIPickerView DataSource and Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        
        // Trigger the API request for the selected currency
        coinManager.getCoinPrice(for: selectedCurrency)
        
        // Update the currency label immediately
        currencyLabel.text = selectedCurrency
    }
    
    // CoinManagerDelegate Methods
    func didUpdatePrice(_ coinManager: CoinManager, price: Double, currency: String) {
        // This method is called when the price is successfully fetched
        
        DispatchQueue.main.async {
            // Update UI on the main thread
            self.bitcoinLabel.text = String(format: "%.2f", price)
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        // Handle errors here
        print(error)
    }
}

