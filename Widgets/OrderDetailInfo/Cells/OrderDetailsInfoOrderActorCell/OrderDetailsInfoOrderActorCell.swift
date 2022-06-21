//
//  OrderDetailsInfoFromToWhereCell.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailsInfoOrderActorCell: UICollectionViewCell {
    @IBOutlet weak var leftIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightIconView: UIImageView!
    
    var infoModel: OrderDetailInfoViewModel.OrderActor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(
        with infoModel: OrderDetailInfoViewModel.OrderActor
    ) {
        self.infoModel = infoModel
        
        self.leftIconView.image = infoModel.icon
        self.titleLabel.text = infoModel.title
        
        switch infoModel.behavior {
        case .copy:
            self.rightIconView.image = UIImage(named: "orderDetailInfo.copy")
        case .contact:
            self.rightIconView.image = UIImage(named: "orderDetailInfo.arrowRight")
        }
    }
    
}
