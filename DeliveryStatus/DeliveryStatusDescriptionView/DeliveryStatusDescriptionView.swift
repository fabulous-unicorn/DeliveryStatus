//
//  DeliveryStatusDescriptionView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import Foundation
import UIKit

class DeliveryStatusDescriptionView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    @IBOutlet private weak var backgroundView: UIView!
    
    var isPrimary: Bool = true
    
    enum ViewType {
        case simple(title: String)
        case subhead(title: String)
        case full(
            title: String,
            date: String,
            status: UIColor
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DeliveryStatusDescriptionView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func configure(_ title: String,_ date: String) {
        self.titleLabel.text = title
        self.dateLabel.text = date
    }
    
    func setType(_ type: ViewType, isPrimary: Bool) {
        
        self.isPrimary = isPrimary
        self.titleLabel.textColor = self.isPrimary ? .black : .lightGray
            
            switch type {
            case let .simple(title):
                UIView.transition(
                    with: self.titleLabel,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.titleLabel.text = title
                        self.titleLabel.font = .systemFont(ofSize: 12)
                    },
                    completion: nil
                )
               
                self.statusView.alpha = 0
                self.dateLabel.alpha = 0
            case let .subhead(title):
                UIView.transition(
                    with: self.titleLabel,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.titleLabel.text = title
                        self.titleLabel.font = .systemFont(ofSize: 13)
                    },
                    completion: nil
                )
                
                self.statusView.alpha = 0
                self.dateLabel.alpha = 0
            case let .full(title, date, status):
                
                UIView.transition(
                    with: self.titleLabel,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.titleLabel.text = title
                        self.titleLabel.font = .systemFont(ofSize: 12)
                    },
                    completion: nil
                )
                
                UIView.transition(
                    with: self.titleLabel,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: {
                        self.dateLabel.text = title
                        self.dateLabel.font = .systemFont(ofSize: 12)
                    },
                    completion: nil
                )
                // ХЗ
                if self.dateLabel.alpha == 0 {
                    self.dateLabel.text = ""
                    UIView.transition(
                        with: self.dateLabel,
                        duration: 2,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.dateLabel.text = date
                            self.dateLabel.alpha = 1
                        },
                        completion: nil
                    )
                } else {
                    UIView.transition(
                        with: self.dateLabel,
                        duration: 2,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.dateLabel.text = date
                        },
                        completion: nil
                    )
                }
                
                self.statusView.backgroundColor = status
                self.statusView.alpha = 1
        }
    }
}
