//
//  DeliveryStatusView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 31.05.2022.
//

import Foundation
import UIKit

/**
View: Группа-статуса для заказа
    
Все стили уникальные для групп предустановленны и берутся из ``DeliveryStatusViewModel/Group-swift.enum`` и
 ``DeliveryStatusViewModel/Title-swift.struct``
 
Визуально включает в себя:
- Заголовок статуса ``DeliveryStatusTitleView``, который позволяет раскрывать статус
- Линию прогресса, если это не последний шаг
- В свернутом состоянии:
    - Краткое описание ``DeliveryStatusStepView``
- В развернутом:
    - Описание
    - Либо таблицу с промежуточными шагами, ячейки: ``DeliveryStatusStepView``
    - Либо карточку: ``DeliveryStatusCardView``
 
 */
class DeliveryStatusView: UIStackView {
    private let titleView = DeliveryStatusTitleView()
    private let stepsContainerView = UIStackView()
    private var stepsViews: [DeliveryStatusStepView] = []
    private var cardView: DeliveryStatusCardView?
    
    private var messageContainer: UIView?
    private var messageLabel: UILabel?
    
    private var isExpanded = true
    
    private var statusModel: DeliveryStatusViewModel?
    
    enum Constant {
        static let expanedSpacing: CGFloat = 6
        static let compressSpacing: CGFloat = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.addArrangedSubview(titleView)
        self.addArrangedSubview(stepsContainerView)
        
        self.axis = .vertical
        self.stepsContainerView.axis = .vertical
        self.stepsContainerView.spacing = 8.0
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func configure(withModel statusModel: DeliveryStatusViewModel) {
        self.statusModel = statusModel
        
        self.titleView.configure(withModel: statusModel.title, delegate: self)
        
        if let message = statusModel.message {
            configureMessage(text: message)
        }
                
        if let cardModel = statusModel.card {
            configureCard(status: statusModel, card: cardModel)
        } else {
            statusModel.steps.forEach { step in
                let view = DeliveryStatusStepView()
                view.configure(withModel: step)
                self.stepsViews.append(view)
                self.stepsContainerView.addArrangedSubview(view)
            }
        }
        
        if !statusModel.isLastStatus {
            configureProgressLine(status: statusModel)
        }
        
        configureInitialExpandedState()
    }
    
    private func configureMessage(text: String) {
        let messageContainer = UIView()
        let messageLabel = UILabel()

        messageLabel.text = text
        
        // Styles
        messageLabel.numberOfLines = 0
        messageLabel.font = .italicSystemFont(ofSize: 12)
        messageLabel.textColor = UIColor.hexStringToUIColor(hex: "777777")

        messageContainer.addSubview(messageLabel)
        
        // Constraints
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor)
        ])
        
        // Save
        self.messageContainer = messageContainer
        self.messageLabel = messageLabel
        
        // Common Hierachy
        self.addArrangedSubview(messageContainer)
    }
    
    private func configureCard(
        status statusModel: DeliveryStatusViewModel,
        card cardModel:  DeliveryStatusViewModel.Card
    ) {
        let cardView = DeliveryStatusCardView()
        cardView.configure(withModel:cardModel)
        
        cardView.isLayoutMarginsRelativeArrangement = true
        cardView.layoutMargins = .init(top: 8, left: 26, bottom: 0, right: 0)
        
        self.addArrangedSubview(cardView)
        
        // Save
        self.cardView = cardView
        
        // Short Info (Table)
        if let shortInfoModel = statusModel.stepForShortView {
            let shortInfoViews = DeliveryStatusStepView()
            shortInfoViews.configure(withModel: shortInfoModel)
            
            self.stepsViews.append(shortInfoViews)
            self.stepsContainerView.addArrangedSubview(shortInfoViews)
        }
    }
    
    private func configureProgressLine(
        status statusModel: DeliveryStatusViewModel
    ) {
        let backgroundLine = UIView()
        let accentLine = UIView()
        
        // Set progress
        accentLine.backgroundColor = statusModel.title.group.tintColor
        
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(accentLine, at: 0)
        
        NSLayoutConstraint.activate([
            accentLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            accentLine.widthAnchor.constraint(equalToConstant: 2),
            accentLine.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        switch statusModel.evolutionStage {
        case .past:
            accentLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        case .present:
            if let lastView = self.stepsViews.last {
                accentLine.bottomAnchor.constraint(equalTo: lastView.centerYAnchor).isActive = true
            } else {
                accentLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
        case .future:
            accentLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        
        // Set bg line
        backgroundLine.backgroundColor = UIColor.hexStringToUIColor(hex: "DFDFDF")
        
        backgroundLine.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundLine, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            backgroundLine.widthAnchor.constraint(equalToConstant: 2),
            backgroundLine.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configureInitialExpandedState(){
        self.isExpanded = false
        commpressStatus()
        self.spacing = isExpanded ? Constant.expanedSpacing : Constant.compressSpacing
    }
}

// MARK: - Toggle state
extension DeliveryStatusView {
    private func toggleState() {
        if isExpanded {
            commpressStatus()
        } else {
            expandStatus()
        }
        isExpanded.toggle()
        self.spacing = isExpanded ? Constant.expanedSpacing : Constant.compressSpacing
    }
    
    private func expandStatus() {
        // Message
        messageContainer?.isHidden = false
        messageContainer?.alpha = 1
        
        // Card or Table
        if statusModel?.card != nil {
            expandStatusForCard()
        } else {
            expandStatusForTable()
        }
    }
    
    private func commpressStatus() {
        // Message
        messageContainer?.isHidden = true
        messageContainer?.alpha = 0

        // Card or Table
        if statusModel?.card != nil {
            commpressStatusForCard()
        } else {
            commpressStatusForTable()
        }
    }
    
    private func expandStatusForTable() {
        stepsViews.enumerated().forEach { index, view in
            guard let model = statusModel else { return }
            view.configure(withModel: model.steps[index])
        }
        stepsViews.forEach { view in
                view.alpha = 1
                view.isHidden = false
        }
    }
    
    private func expandStatusForCard() {
        self.cardView?.isHidden = false
        self.cardView?.alpha = 1
        
        self.stepsContainerView.isHidden = true
        self.stepsContainerView.alpha = 0
    }
    
    private func commpressStatusForTable() {
        guard let model = statusModel else { return }
        
        // TODO: Alesya Volosach | По идее невозможный кейс
        guard let stepForShortView = model.stepForShortView else {
            stepsViews.enumerated().forEach { index, view in
                view.isHidden = true
            }
            return
        }

        stepsViews.last?.configure(withModel: stepForShortView)
        
        stepsViews.enumerated().forEach { index, view in
            view.isHidden = index == stepsViews.count - 1 ? false : true
            view.alpha = index == stepsViews.count - 1 ? 1 : 0
        }
    }
    
    private func commpressStatusForCard() {
        self.cardView?.isHidden = true
        self.cardView?.alpha = 0
        
        self.stepsContainerView.isHidden = false
        self.stepsContainerView.alpha = 1
    }
}

// MARK: - DeliveryStatusTitleDelegate
extension DeliveryStatusView: DeliveryStatusTitleDelegate {
    func tappedTitle() {
        UIView.animate(
            withDuration: GlobalConstant.statusChangeStateAnimationDuration
        ) {
            self.toggleState()
            self.setNeedsLayout()
        }
    }
}
