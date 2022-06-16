//
//  DeliveryStatusCard.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 07.06.2022.
//

import Foundation
import UIKit

/**
View: Карточка для группы-статуса
 
Визуально включает в себя либо одну, либо 2 плашки с информацией о принятие/отдаче заказа
 */
class DeliveryStatusCardView: UIStackView {
    @IBOutlet private var contentView: UIStackView!
    
    @IBOutlet private weak var mainInfoContainer: UIStackView!
    
    @IBOutlet private weak var deliveryTypeContainer: UIView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var deliveryTypeTitleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    @IBOutlet private weak var addressContainer: UIStackView!
    @IBOutlet private weak var openMapLabel: UILabel!
    private var transparentOpenMapButton: UIButton?
    @IBOutlet private weak var pickUpInfoLabel: UILabel!
    @IBOutlet private weak var changeButton: UIButton!
    @IBOutlet private weak var planneDeliveryInfoLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    @IBOutlet private weak var keepInfoContainer: UIView!
    @IBOutlet private weak var keepInfoLabel: UILabel!
    @IBOutlet private weak var keepInfoButton: UIButton!
    
    private var cardModel: DeliveryStatusViewModel.Card?
    
    enum Constant {
        // TODO: Alesya Volosach | было бы круто вынести куда-то к ui-lib эту константу, она распространяется на все виджеты и практически все плашки
        static let surfaceCornerRadius: CGFloat = 12
    }
    
    // MARK: - Init
    
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
        self.axis = .vertical
        
        // Reset titles
        keepInfoButton.setTitle("", for: .normal)
        
        // BackgroundView for mainContainer
        if #available(iOS 14, *) {
            mainInfoContainer.cornerRadius = Constant.surfaceCornerRadius
            mainInfoContainer.borderColor = UIColor(named: "Surface Border")
            mainInfoContainer.borderWidth = 1
        } else {
            let mainInfoBackgroundView = UIView()
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
            mainInfoBackgroundView.borderColor = UIColor(named: "Surface Border")
            mainInfoBackgroundView.borderWidth = 1
        }
        
        keepInfoContainer.cornerRadius = Constant.surfaceCornerRadius
        keepInfoContainer.borderColor = UIColor(named: "Surface Border")
        keepInfoContainer.borderWidth = 1
        
        // Button
        changeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        changeButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Actions Outlets

    @objc func tappedOpenMap(_ sender: Any) {
        print("| Log | Open map")
        // Открытие отсюда
    }
    
    @IBAction func tappedChange(_ sender: Any) {
        print("| Log | Tap change")
        // Output
    }
    
    @IBAction func tappedKeepInfo(_ sender: Any) {
        print("| Log | Open keep Info: Url: \(cardModel?.keepInfoLink)")
        // Открытие отсюда
    }
    
    // MARK: - Configure
    
    func configure(withModel cardModel: DeliveryStatusViewModel.Card) {
        self.cardModel = cardModel
        
        iconView.image = cardModel.icon
        deliveryTypeTitleLabel.text = cardModel.title
        addressLabel.text = cardModel.address
        
        if cardModel.officeId != nil {
            openMapLabel.isHidden = false
            configureTransparentOpenMapButton()
        } else {
            openMapLabel.isHidden = true
        }
        
        pickUpInfoLabel.isHidden = cardModel.pickUpInfo == nil
        pickUpInfoLabel.text = cardModel.pickUpInfo
        
        changeButton.isHidden = !cardModel.displayChangeButton
        
        planneDeliveryInfoLabel.isHidden = cardModel.planedDeliveryInfo == nil
        planneDeliveryInfoLabel.text = cardModel.planedDeliveryInfo
        
        messageLabel.isHidden = cardModel.message == nil
        messageLabel.text = cardModel.message
        
        keepInfoContainer.isHidden = cardModel.keepDateInfo == nil
        keepInfoLabel.text = cardModel.keepDateInfo
        
        hideUnknown(cardModel)
    }
    
    /// Для обратной совместимости
    private func hideUnknown(_ cardModel: DeliveryStatusViewModel.Card) {
        guard cardModel.deliveryType == .unknown else { return }
            
        self.deliveryTypeContainer.isHidden = true
        self.changeButton.isHidden = true
        self.openMapLabel.isHidden = true
        self.transparentOpenMapButton?.isHidden = true
    }
    
    private func configureTransparentOpenMapButton() {
        let transparentOpenMapButton = UIButton()
        transparentOpenMapButton.backgroundColor = .clear
        transparentOpenMapButton.setTitle("", for: .normal)
        
        // Constraints
        transparentOpenMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        addressContainer.insertSubview(transparentOpenMapButton, at: 0)
        
        NSLayoutConstraint.activate([
            transparentOpenMapButton.leadingAnchor.constraint(equalTo: addressContainer.leadingAnchor),
            transparentOpenMapButton.trailingAnchor.constraint(equalTo: addressContainer.trailingAnchor),
            transparentOpenMapButton.topAnchor.constraint(equalTo: addressLabel.topAnchor),
            transparentOpenMapButton.bottomAnchor.constraint(equalTo: openMapLabel.bottomAnchor)
        ])
        
        // Action
        transparentOpenMapButton.addTarget(self, action: #selector(tappedOpenMap), for: .touchDown)
        
        // Save
        self.transparentOpenMapButton = transparentOpenMapButton
    }
}
