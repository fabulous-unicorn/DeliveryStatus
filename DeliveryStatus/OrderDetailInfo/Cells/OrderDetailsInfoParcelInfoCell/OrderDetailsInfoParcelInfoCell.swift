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
    private var isRotate = false
    
    enum TurnArrowConstant {
        static let `default`: CGFloat = 0
        static let rotate = -CGFloat.pi * 99 / 100
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
    
    func showIconAnimation() {
        guard
            case let .default(nestedItems) = parcelInfoModel?.type,
            !nestedItems.isEmpty
        else { return }
        
        UIView.animate(withDuration: GlobalConstant.statusChangeStateAnimationDuration) {
            self.iconView.transform = CGAffineTransform(
                rotationAngle: self.isRotate ? TurnArrowConstant.default :  TurnArrowConstant.rotate)
        }
        isRotate.toggle()
    }
    
}
