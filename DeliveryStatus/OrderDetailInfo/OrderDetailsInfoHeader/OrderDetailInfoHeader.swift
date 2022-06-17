//
//  OrderDetailsInfoHeader.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 17.06.2022.
//

import UIKit

class OrderDetailInfoHeader: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
