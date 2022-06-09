//
//  DeliveryStatusCard.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 07.06.2022.
//

import Foundation
import UIKit
// TODO: Alesya Volosach | Доработать установку стилей текста в didSet
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
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var keepInfoContainer: UIView!
    @IBOutlet weak var keepInfoLabel: UILabel!
    @IBOutlet weak var keepInfoButton: UIButton!
    
    private var model: DeliveryStatusViewModel.Card?
    
    enum Constant {
        // TODO: Alesya Volosach | было бы круто вынести кудаа-то к ui-lib эту константу, она распространяется на все виджеты и практически все плашки
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
        // TODO: Alesya Volosach | В проекте поменять логику встраивания subviews
        Bundle.main.loadNibNamed("DeliveryStatusCardView", owner: self, options: nil)
        self.addArrangedSubview(contentView)
        self.axis = .vertical
        
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
        
        keepInfoContainer.cornerRadius = Constant.surfaceCornerRadius
        keepInfoContainer.borderColor = UIColor(named: "borderSurface")
        keepInfoContainer.borderWidth = 1
        
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
        
        // Buttons fonts
        // TODO: Alesya Volosach | На 15 версии сбрасывается
        openMapButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        changeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    

    @IBAction func tappedOpenMap(_ sender: Any) {
        print("| Log | Open map")
    }
    
    @IBAction func tappedChange(_ sender: Any) {
        print("| Log | Tap change")
    }
    
    @IBAction func tappedKeepInfo(_ sender: Any) {
        print("| Log | Open keep Info: Url: \(model?.keepInfoLink)")
    }
    
    func configure(_ model: DeliveryStatusViewModel.Card) {
        self.model = model
        
        iconView.image = model.icon
        modeTitleLabel.text = model.title
        addressLabel.text = model.address
        
        openMapButton.isHidden = model.officeId == nil
        
        pickUpInfoLabel.isHidden = model.pickUpInfo == nil
        pickUpInfoLabel.text = model.pickUpInfo
        
        changeButton.isHidden = !model.displayChangeButton
        
        planneDeliveryInfoLabel.isHidden = model.planedDeliveryInfo == nil
        planneDeliveryInfoLabel.text = model.planedDeliveryInfo
        
        messageLabel.isHidden = model.message == nil
        messageLabel.text = model.message
        
        keepInfoContainer.isHidden = model.keepDateInfo == nil
        keepInfoLabel.text = model.keepDateInfo
    }
}
