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
        guard titleModel?.isExpandingAvailable == true else { return }
        
        showArrowAnimation()
        delegate?.tappedTitle()
    }
    
    // MARK: - Configure
    
    func configure(
        withModel titleModel: DeliveryStatusViewModel.Title,
        delegate: DeliveryStatusTitleDelegate
    ) {
        self.titleModel = titleModel
        self.delegate = delegate
        
        titleLabel.text = titleModel.title
        iconView.image = titleModel.group.icon
        
        setStyles(titleModel)
    }
    
    // MARK: - Other
    
    private func setStyles(_ titleModel: DeliveryStatusViewModel.Title) {
        switch titleModel.evolutionStage {
        case .past:
            iconView.tintColor = titleModel.group.tintColor
            iconContainerView.backgroundColor = titleModel.group.backgroundColor
            titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
            titleLabel.alpha = 1
        case .present:
            iconView.tintColor = titleModel.group.tintColor
            iconContainerView.backgroundColor = titleModel.group.backgroundColor
            titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            titleLabel.alpha = 1
        case .future:
            iconView.tintColor = titleModel.group.inactiveTintColor
            iconContainerView.backgroundColor = titleModel.group.inactiveBackgroundColor
            titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
            titleLabel.alpha = 0.6
        }
        
        arrowView.isHidden = !titleModel.isExpandingAvailable
    }
    
    func showArrowAnimation() {
        UIView.animate(withDuration: GlobalConstant.statusChangeStateAnimationDuration) {
            self.arrowView.transform = CGAffineTransform(
                rotationAngle: self.isRotate ? TurnArrowConstant.default :  TurnArrowConstant.rotate)
        }
        isRotate.toggle()
    }
}
