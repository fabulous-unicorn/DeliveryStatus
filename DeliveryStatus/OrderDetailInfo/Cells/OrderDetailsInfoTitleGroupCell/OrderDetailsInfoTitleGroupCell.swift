//
//  OrderDetailsInfoTitleGroup.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailsInfoTitleGroupCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
