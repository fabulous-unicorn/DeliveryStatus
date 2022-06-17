//
//  OrderDetailsInfoServiceCell.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 16.06.2022.
//

import UIKit

class OrderDetailsInfoServiceCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var service: OrderDetailsInfoViewModel.AdditionalService?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configure(
        with service: OrderDetailsInfoViewModel.AdditionalService
    ) {
        self.service = service
        
        self.titleLabel.text = service.title
        // TODO: Alesya Volosach | Добавить преобразование description
        var description = ""
        service.description.enumerated().forEach { index, info in
            description += (index == 0 ? "" : "\n" ) + info
        }
        self.descriptionLabel.text = description
        self.descriptionLabel.isHidden = description.isEmpty
    }
}
