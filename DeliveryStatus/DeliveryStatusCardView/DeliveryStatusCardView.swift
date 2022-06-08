//
//  DeliveryStatusCard.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 07.06.2022.
//

import Foundation
import UIKit

/// Карточка для группы статусов
class DeliveryStatusCardView: UIStackView {
    @IBOutlet var contentView: UIStackView!
    
    @IBOutlet weak var mainInfoContainer: UIStackView!
    // Only version before iOS 14
    private var mainInfoBackgroundView = UIView()
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var modeTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    // TODO: Alesya Volosach | Пересмотреть отображать кнопку или сделать невидимую кнопку захватывающую в область нажатия адрес
    @IBOutlet weak var openMapButton: UIButton!
    @IBOutlet weak var pickUpInfoLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var planneDeliveryInfoLabel: UILabel!
    @IBOutlet weak var message: UILabel!

    @IBOutlet weak var keepDateContainer: UIView!
    @IBOutlet weak var keepDateLabel: UILabel!
    @IBOutlet weak var keepInfoButton: UIButton!
    
    enum Constant {
        static let surfaceCornerRadius: CGFloat = 12
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DeliveryStatusCardView", owner: self, options: nil)
        self.addArrangedSubview(contentView)
        
        // Reset titles
        keepInfoButton.setTitle("", for: .normal)
        
        // BackgroundView for mainContainer
        if #available(iOS 14, *) {
            mainInfoContainer.cornerRadius = Constant.surfaceCornerRadius
            mainInfoContainer.borderColor = UIColor(named: "borderSurface")
            mainInfoContainer.borderWidth = 1
        } else {
            mainInfoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            mainInfoContainer.insertSubview(mainInfoBackgroundView, at: 0)
            NSLayoutConstraint.activate([
                mainInfoBackgroundView.leadingAnchor.constraint(equalTo: mainInfoContainer.leadingAnchor),
                mainInfoBackgroundView.trailingAnchor.constraint(equalTo: mainInfoContainer.trailingAnchor),
                mainInfoBackgroundView.topAnchor.constraint(equalTo: mainInfoContainer.topAnchor),
                mainInfoBackgroundView.bottomAnchor.constraint(equalTo: mainInfoContainer.bottomAnchor)
            ])
            
            mainInfoBackgroundView.backgroundColor = .white
            mainInfoBackgroundView.cornerRadius = Constant.surfaceCornerRadius
            mainInfoBackgroundView.borderColor = UIColor(named: "borderSurface")
            mainInfoBackgroundView.borderWidth = 1
        }
        
        keepDateContainer.cornerRadius = Constant.surfaceCornerRadius
        keepDateContainer.borderColor = UIColor(named: "borderSurface")
        keepDateContainer.borderWidth = 1
        
        // Buttons insets
        if #available(iOS 15, *) {
            openMapButton.configuration?.contentInsets = .init(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
            changeButton.configuration?.contentInsets = .init(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
        } else {
            openMapButton.imageEdgeInsets = .init(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            )
            changeButton.imageEdgeInsets = .init(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            )
        }
        
    }
    

    @IBAction func tappedOpenMap(_ sender: Any) {
    }
    
    @IBAction func tappedChange(_ sender: Any) {
    }
    
    @IBAction func tappedKeepInfo(_ sender: Any) {
    }
}
