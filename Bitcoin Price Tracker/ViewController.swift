//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Tabitha Levine on 2018-10-01.
//  Copyright © 2018 Tabitha Levine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDefaultPrices()
        getPrice()
    }
    func getDefaultPrices() {
        let canPrice = UserDefaults.standard.double(forKey: "CAN")
        if canPrice != 0.0 {
            self.canLabel.text = self.doubleToMoneyString(price: canPrice, currencyCode: "CAN") + "~"
        }
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD") + "~"
        }
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0 {
            self.eurLabel.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR") + "~"
        }
    }
    
    func getPrice() {
        if let url = URL(string:"https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=CAN,USD,EUR") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                                
                                if let canPrice = jsonDictionary["CAN"] {
                                    self.canLabel.text = self.doubleToMoneyString(price: canPrice, currencyCode: "CAN")
                                    UserDefaults.standard.set(canPrice, forKey: "CAN")
                                }
                                if let usdPrice = jsonDictionary["USD"] {
                                    self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
                                    UserDefaults.standard.set(usdPrice, forKey: "USD")
                                }
                                if let eurPrice = jsonDictionary["EUR"] {
                                    self.eurLabel.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
                                    UserDefaults.standard.set(eurPrice, forKey: "EUR")
                                }
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                } else {
                    print("Whoops, something went wrong!")
                }
                }.resume()
        }
    }
    
    func doubleToMoneyString(price:Double,currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString = formatter.string(from: NSNumber(value: price))
        if priceString == nil {
            return "ERROR"
        } else {
            return priceString!
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
    }
    
}
