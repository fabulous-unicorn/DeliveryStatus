//
//  DeliveryStatusTitleView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import Foundation
import UIKit

protocol DeliveryStatusTitleDelegate {
    func tappedTitle()
}

/**
View: Заголовок группы-статуса для заказа
    
Все стили уникальные для групп предустановленны и берутся из ``DeliveryStatusViewModel/Group-swift.enum`` и
 ``DeliveryStatusViewModel/Title-swift.struct``
 
Визуально включает в себя:
- Иконка
- Заголовок
- Поворачивающаяся стрелка
 */
class DeliveryStatusTitleView: UIView {
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var iconContainerView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowView: UIImageView!
    
    enum TurnArrowConstant {
        static let `default`: CGFloat = 0
        static let rotate = -CGFloat.pi * 99 / 100
    }
    
    private var isRotate = false
    
    private var titleModel: DeliveryStatusViewModel.Title?
    private var delegate: DeliveryStatusTitleDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DeliveryStatusTitleView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    // MARK: - Actions Outlets
    
    @IBAction func tappedTitle(_ sender: Any) {
        guard titleModel?.isAvailableExpanded == true else { return }
        
        showArrowAnimation()
        delegate?.tappedTitle()
    }
    
    // MARK: - Configure
    
    func configure(
        _ model: DeliveryStatusViewModel.Title,
        _ delegate: DeliveryStatusTitleDelegate
    ) {
        self.titleModel = model
        self.delegate = delegate
        
        titleLabel.text = model.title
        iconView.image = model.group.icon
        
        setStyles(model)
    }
    
    // MARK: - Other
    
    // TODO: Alesya Volosach | Может вывести где-то правило, где передается в методы view модель, а где напрямую тянем из свойств
    private func setStyles(_ model: DeliveryStatusViewModel.Title) {
        switch model.evolutionStage {
        case .past:
            iconView.tintColor = model.group.tintColor
            iconContainerView.backgroundColor = model.group.backgroundColor
            titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
            titleLabel.alpha = 1
        case .present:
            iconView.tintColor = model.group.tintColor
            iconContainerView.backgroundColor = model.group.backgroundColor
            titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            titleLabel.alpha = 1
        case .future:
            iconView.tintColor = model.group.inactiveTintColor
            iconContainerView.backgroundColor = model.group.inactiveBackgroundColor
            titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
            titleLabel.alpha = 0.6
        }
        
        arrowView.isHidden = !model.isAvailableExpanded
    }
    
    func showArrowAnimation() {
        UIView.animate(withDuration: GlobalConstant.statusChangeStateAnimationDuration) {
            self.arrowView.transform = CGAffineTransform(
                rotationAngle: self.isRotate ? TurnArrowConstant.default :  TurnArrowConstant.rotate)
        }
        isRotate.toggle()
    }
}
