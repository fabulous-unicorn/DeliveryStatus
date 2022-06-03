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

// TODO: Alesya Volosach | нет стилей/ нет типов
class DeliveryStatusTitleView: UIView {
    enum Constant {
        static let `default`: CGFloat = 0
        static let rotate = -CGFloat.pi * 99 / 100
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var iconContainerView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowView: UIImageView!
    
    var isRotate = false
    
    var model: DeliveryStatusTitleViewModel?
    var delegate: DeliveryStatusTitleDelegate?
    
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
    
    @IBAction func tappedTitle(_ sender: Any) {
        showArrowAnimation()
        delegate?.tappedTitle()
    }
    
    func configure(
        _ model: DeliveryStatusTitleViewModel,
        _ delegate: DeliveryStatusTitleDelegate
    ) {
        self.model = model
        self.delegate = delegate
        
        self.titleLabel.text = model.title
        self.iconView.image = model.group.icon
        
        setStyles(model)
    }
    
    private func setStyles(_ model: DeliveryStatusTitleViewModel) {
        switch model.evolutionStage {
        case .past:
            self.iconView.tintColor = model.group.tintColor
            self.iconContainerView.backgroundColor = model.group.backgroundColor
            self.titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        case .present:
            self.iconView.tintColor = model.group.tintColor
            self.iconContainerView.backgroundColor = model.group.backgroundColor
            self.titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        case .future:
            self.iconView.tintColor = model.group.inactiveTintColor
            self.iconContainerView.backgroundColor = model.group.inactiveBackgroundColor
            self.titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            self.titleLabel.alpha = 0.6
        }
        
        self.arrowView.isHidden = !model.isAvailableExpanded
    }
    
    func showArrowAnimation() {
        UIView.animate(withDuration: GlobalConstant.statusChangeStateAnimationDuration) {
            self.arrowView.transform = CGAffineTransform(
                rotationAngle: self.isRotate ? Constant.default :  Constant.rotate)
        }
        self.isRotate.toggle()
    }
    
}




// TODO: Alesya Volosach | Почитать про uitests

/// Заголовок статуса доставки
///
/// Типы:
///
/// **past** -
/// **present** -
/// **future** -
