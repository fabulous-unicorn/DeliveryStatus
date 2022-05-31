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

class DeliveryStatusTitleView: UIView {
    enum StatusType {
        case past, future, present
    }
    
    enum Constant {
        static let `default`: CGFloat = 0
        static let rotate = -CGFloat.pi * 99 / 100
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var arrowView: UIImageView!
    
//    var arrowAnimator: UIViewPropertyAnimator!
    var isRotate = false
    
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
    
    func configure(_ delegate: DeliveryStatusTitleDelegate) {
        self.delegate = delegate
    }
    
    func showArrowAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.arrowView.transform = CGAffineTransform(
                rotationAngle: self.isRotate ? Constant.default :  Constant.rotate)
        }
        self.isRotate.toggle()
    }
    
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
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
