//
//  DeliveryStatusDescriptionView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import Foundation
import UIKit

class DeliveryStatusPointView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    var model: DeliveryStatusStepViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DeliveryStatusPointView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setType(_ model: DeliveryStatusStepViewModel) {
        self.model = model
        
        
        switch model.type {
        case .simple:
            UIView.transition(
                with: self.titleLabel,
                duration: GlobalConstant.statusChangeStateAnimationDuration,
                options: .transitionCrossDissolve,
                animations: {
                    self.titleLabel.text = model.title
                    self.titleLabel.font = .systemFont(ofSize: 12)
                    self.titleLabel.textColor = .black
                },
                completion: nil
            )
               
                self.statusView.alpha = 0
                self.dateLabel.alpha = 0
                self.topSpace.constant = 0
                
        case .subhead:
                UIView.transition(
                    with: self.titleLabel,
                    duration: GlobalConstant.statusChangeStateAnimationDuration,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.titleLabel.text = model.title
                        self.titleLabel.font = .systemFont(ofSize: 13)
                        self.titleLabel.textColor = .black
                    },
                    completion: nil
                )
                
                self.statusView.alpha = 0
                self.dateLabel.alpha = 0
                self.topSpace.constant = 4
                
            case let .point(date, isPrimary):
            //isShort: Bool self.titleLabel.textColor = .lightGray
                
                UIView.transition(
                    with: self.titleLabel,
                    duration: GlobalConstant.statusChangeStateAnimationDuration,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.titleLabel.text = model.title
                        self.titleLabel.font = .systemFont(ofSize: 12)
                        self.titleLabel.textColor = isPrimary ? .black : .lightGray
                    },
                    completion: nil
                )
                
                self.dateLabel.text = date
                self.dateLabel.alpha = 1
                
                self.statusView.backgroundColor = model.group.tintColor
                self.statusView.alpha = 1
                
                self.topSpace.constant = 0
        }
    }
}
