//
//  TickerCell.swift
//  BitPoloniex
//
//  Created by Saleh on 1/25/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import UIKit

class TickerCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var secondInfoLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var ticker: Ticker?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = colorView.frame.size.width / 2
    }

    func setTickerItem(item: Ticker, enteredPrice: Double?) {
        ticker = item
        let hasVal : Bool = priceLabel.text != nil
        
        if hasVal && ticker?.pairId == item.pairId {
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                self.colorView.backgroundColor = UIColor.yellow
            }) { (completed) in
                
            }
        }
        
        idLabel.text = "\(ticker?.name ?? "")"
        if let label = self.secondInfoLabel {
            label.text = "\(ticker?.highestBid ?? 0.0)"
        }
        
        if let price = ticker?.lastTradePrice {
            priceLabel.text = "\(price)"
            
                UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseIn, animations: {
                    if let enteredPrice = enteredPrice, enteredPrice != 0.0 {
                        if price > enteredPrice {
                            self.colorView.backgroundColor = UIColor.green
                        } else if price < enteredPrice {
                            self.colorView.backgroundColor = UIColor.red
                        } else {
                            self.colorView.backgroundColor = UIColor.darkGray
                        }
                    } else {
                        self.colorView.backgroundColor = UIColor.darkGray
                    }
                }) { (completed) in
                    
                }
        } else {
            priceLabel.text = "--"
            if let label = self.secondInfoLabel {
                label.text = "--"
            }
            colorView.backgroundColor = UIColor.darkGray
            colorView.layer.removeAllAnimations()
        }
        
    }

}

