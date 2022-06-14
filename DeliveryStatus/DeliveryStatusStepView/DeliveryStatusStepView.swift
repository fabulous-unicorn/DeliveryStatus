//
//  DeliveryStatusDescriptionView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import Foundation
import UIKit

class DeliveryStatusStepView: UIView {
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var topSpace: NSLayoutConstraint!
    
    private var stepModel: DeliveryStatusViewModel.Step?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DeliveryStatusStepView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    // MARK: - Configure
    
    func configure(withModel stepModel: DeliveryStatusViewModel.Step) {
        self.stepModel = stepModel
        
        switch stepModel.type {
        case .simple:
            configureSimple(stepModel)
        case .subhead:
            configureSubhead(stepModel)
        case let .point(date, isPrimary):
            configurePoint(stepModel, date, isPrimary)
        }
    }
    
    private func configureSimple(_ stepModel: DeliveryStatusViewModel.Step) {
        UIView.transition(
            with: self.titleLabel,
            duration: GlobalConstant.statusChangeStateAnimationDuration,
            options: .transitionCrossDissolve,
            animations: {
                self.titleLabel.text = stepModel.title
                self.titleLabel.font = .systemFont(ofSize: 12)
                self.titleLabel.textColor = stepModel.evolutionStage == .future ? .gray : .black
            },
            completion: nil
        )
           
            self.statusView.alpha = 0
            self.dateLabel.alpha = 0
            self.topSpace.constant = 0
    }
    
    private func configureSubhead(_ stepModel: DeliveryStatusViewModel.Step) {
        UIView.transition(
            with: self.titleLabel,
            duration: GlobalConstant.statusChangeStateAnimationDuration,
            options: .transitionCrossDissolve,
            animations: {
                self.titleLabel.text = stepModel.title
                self.titleLabel.font = .systemFont(ofSize: 13)
                self.titleLabel.textColor = .black
            },
            completion: nil
        )
        
        self.statusView.alpha = 0
        self.dateLabel.alpha = 0
        self.topSpace.constant = 4
    }
    
    private func configurePoint(
        _ stepModel: DeliveryStatusViewModel.Step,
        _ date: String,
        _ isPrimary: Bool
    ) {
        UIView.transition(
            with: self.titleLabel,
            duration: GlobalConstant.statusChangeStateAnimationDuration,
            options: .transitionCrossDissolve,
            animations: {
                self.titleLabel.text = stepModel.title
                self.titleLabel.font = .systemFont(ofSize: 12)
                self.titleLabel.textColor = isPrimary ? .black : .gray
            },
            completion: nil
        )
        
        self.dateLabel.text = date
        self.dateLabel.alpha = 1
        
        self.statusView.backgroundColor = stepModel.group.tintColor
        self.statusView.alpha = 1
        
        self.topSpace.constant = 0
    }
}
