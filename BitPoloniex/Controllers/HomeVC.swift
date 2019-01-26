//
//  HomeVC.swift
//  BitPoloniex
//
//  Created by Saleh on 1/25/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import UIKit
import RxSwift

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    
    
    let service = BitPoloniexService.shared
    
    var tickerArray : [Ticker]?
    
    var enteredPrice : Double?
    
    var simpleMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    UIApplication.shared.keyWindow?.rootViewController = self
        
        
        if let user : User = AppUserDefaults.getUser() {
            self.userLabel.text = "Welcome \(user.fullName ?? "")"
        }
        
        tickerArray = []
        statusLabel.text = "Connecting.."
        
        service.asObservable().subscribe { tickerItem in
            if let item = tickerItem.element, let data : [Ticker] = self.tickerArray {
                var results : [Ticker] = data.filter({ $0.pairId == item.pairId })
                if results.count == 0 {
                    print("Not found \(item.pairId ?? 0)");
                } else {
                    if let index = data.firstIndex(where: { (it) -> Bool in
                        it.pairId == results[0].pairId
                    }) {
                        self.tickerArray?[index].lastTradePrice = item.lastTradePrice
                        self.tickerArray?[index].highestBid = item.highestBid
                        self.tickerArray?[index].lowestRisk = item.lowestRisk
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                        }
                        
                    }
                }
            }
        }
        
        service.didConnect = {
            print("connected");
            self.statusLabel.text = "Subscribing.."
            self.service.getPairsData(completionHandler: { (error, arr) in
                if error == nil {
                    self.tickerArray = arr
                    self.tableView.reloadData()
                    self.service.startTicker()
                    self.statusLabel.text = "Connected."
                } else {
                    print("Error: \(error?.localizedDescription ?? "")")
                }
            })
        }
        
        service.didDisconnect = { error in
            print("Disconnected: \(error?.localizedDescription ?? "")")
            self.statusLabel.text = "Disconnected."
        }
        
        service.didReceiveData = { data in
            print("Got Data: \(data?.description ?? "")")
        }
        
        service.didReceiveMessage = { text in
            print("Got Message: \(text ?? "")")
        }
        
    }
    
    func updatePrice() {
        self.enteredPrice = Double(priceTextField.text ?? "")
        self.tableView.reloadData()
        self.priceTextField.resignFirstResponder()
    }

    @IBAction func updatePrice(_ sender: Any) {
       self.updatePrice()
    }
    
    @IBAction func viewModeChanged(_ sender: Any) {
        self.simpleMode = (sender as! UISegmentedControl).selectedSegmentIndex == 1
        self.tableView.reloadData()
       
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tickerArray?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellToShow : String = self.simpleMode ? "tickerSimpleCell" : "tickerCell"
        
        let cell : TickerCell = tableView.dequeueReusableCell(withIdentifier: cellToShow, for: indexPath) as! TickerCell
        
        cell.setTickerItem(item: (self.tickerArray?[indexPath.row])!, enteredPrice: self.enteredPrice)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.simpleMode ? 44.0 : 76.0
    }

}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updatePrice()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updatePrice()
    }
    
}
