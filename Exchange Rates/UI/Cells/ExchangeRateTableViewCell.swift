//
//  ExchangeRateTableViewCell.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var buyLabel: UILabel!
    @IBOutlet private weak var sellLabel: UILabel!
    @IBOutlet private weak var deltaBuy: UILabel!
    @IBOutlet private weak var deltaSale: UILabel!
    
    var item: Rate? {
        didSet {
           configure()
        }
    }
    
    private func configure() {
        nameLabel?.text = item?.name
        buyLabel?.text = item?.buy
        sellLabel?.text = item?.sale
        
        if let deltaBuyString = item?.deltaBuy {
            let deltaBuyFloat = Float(deltaBuyString) ?? 0.0
            deltaBuy?.textColor = deltaBuyFloat > 0 ? .systemGreen : (deltaBuyFloat < 0 ? .systemRed : .systemGray)
            deltaBuy?.text = deltaBuyString
        }
        
        if let deltaSaleString = item?.deltaSale {
            let deltaSaleFloat = Float(deltaSaleString) ?? 0.0
            deltaSale?.textColor = deltaSaleFloat > 0 ? .systemGreen : (deltaSaleFloat < 0 ? .systemRed : .systemGray)
            deltaSale?.text = deltaSaleString
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel?.text = nil
        buyLabel?.text = nil
        sellLabel?.text = nil
        deltaBuy?.text = nil
        deltaSale?.text = nil
    }
}
