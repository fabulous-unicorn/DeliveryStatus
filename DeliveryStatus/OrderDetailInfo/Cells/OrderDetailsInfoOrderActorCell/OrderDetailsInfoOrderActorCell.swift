//
//  OrderDetailsInfoFromToWhereCell.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailsInfoOrderActorCell: UITableViewCell {
    @IBOutlet weak var leftIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightIconView: UIImageView!
    
    var infoModel: OrderDetailsInfoViewModel.OrderActor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(
        with infoModel: OrderDetailsInfoViewModel.OrderActor
    ) {
        self.infoModel = infoModel
        
        self.leftIconView.image = infoModel.icon
        self.titleLabel.text = infoModel.title
        
        switch infoModel.behavior {
        case .copy:
            self.accessoryType = .none
            self.rightIconView.image = UIImage(named: "orderDetailInfo.copy")
            self.rightIconView.isHidden = false
        case .contact:
            self.rightIconView.isHidden = true
            self.accessoryType = .disclosureIndicator
        }
    }
    
}
