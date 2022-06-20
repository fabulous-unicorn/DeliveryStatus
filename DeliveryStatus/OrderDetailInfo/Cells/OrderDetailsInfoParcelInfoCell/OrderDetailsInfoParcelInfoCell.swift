//
//  OrderDetailsInfoParcelInfoCell.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 16.06.2022.
//

import UIKit

class OrderDetailsInfoParcelInfoCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    var parcelInfoModel: OrderDetailInfoViewModel.ParcelInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configure(with parcelInfoModel: OrderDetailInfoViewModel.ParcelInfo) {
        self.parcelInfoModel = parcelInfoModel
        
        // Content
        
        self.titleLabel.text = parcelInfoModel.title
        self.descriptionLabel.text = parcelInfoModel.description
        
        self.iconView.isHidden = true
        
        if parcelInfoModel.additionalInfo != nil {
            self.iconView.image = UIImage(named: "orderDetailInfo.alertCircle")
            self.iconView.isHidden = false
        }
        
        if
            case let .default(nestedItems) = parcelInfoModel.type,
            !nestedItems.isEmpty
        {
            self.iconView.image = UIImage(named: "orderDetail.arrowDown")
            self.iconView.isHidden = false
        }

        // Styles
        
        self.descriptionLabel.font = .systemFont(
            ofSize: self.descriptionLabel.font.pointSize,
            weight: parcelInfoModel.type == .nested ? .regular : .semibold
        )
    }
    
    // TODO: Alesya Volosach | Где-то должна быть анимация поворота стрелки
    
}
