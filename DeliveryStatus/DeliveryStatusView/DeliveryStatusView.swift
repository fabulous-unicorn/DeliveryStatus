//
//  DeliveryStatusView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 31.05.2022.
//

import Foundation
import UIKit

class DeliveryStatusView: UIStackView {
    private var titleView = DeliveryStatusTitleView()
    private var stepsContainerView = UIStackView()
    private var cardView: DeliveryStatusCardView?
    
    private var backgroundLine = UIView()
    private var accentLine = UIView()
    
    private var isExpaned = true
    
    private var stepsViews: [DeliveryStatusStepView] = []
    
    private var model: DeliveryStatusViewModel?
    
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
    
    func commonInit() {
        self.addArrangedSubview(titleView)
        self.addArrangedSubview(stepsContainerView)
        self.axis = .vertical
        self.stepsContainerView.axis = .vertical
        self.stepsContainerView.spacing = 8.0
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func configure(_ model: DeliveryStatusViewModel) {
        self.model = model
        
        self.titleView.configure(model.title, self)
        
        model.steps.forEach { step in
            let view = DeliveryStatusStepView()
            view.setType(step)
            self.stepsViews.append(view)
            self.stepsContainerView.addArrangedSubview(view)
        }
        
        if let cardModel = model.card {
            let cardView = DeliveryStatusCardView()
            cardView.configure(cardModel)
            
            cardView.isLayoutMarginsRelativeArrangement = true
            cardView.layoutMargins = .init(top: 8, left: 26, bottom: 0, right: 0)
            self.addArrangedSubview(cardView)
            self.cardView = cardView
            
            if let shortInfoModel = model.stepForShortView {
                let shortInfoViews = DeliveryStatusStepView()
                shortInfoViews.setType(shortInfoModel)
                self.stepsViews.append(shortInfoViews)
                self.stepsContainerView.addArrangedSubview(shortInfoViews)
            }
        }
        
        // TODO: Alesya Volosach | Определить зачем тогл в конфигурации?
        toggleState()
        if !model.isLastStatus {
            setLine()
        }
    }
    
    func setLine() {
        guard let model = model else { return }
        
        // Set accent line
        accentLine.backgroundColor = model.title.group.tintColor
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(accentLine, at: 0)
        
        NSLayoutConstraint.activate([
            accentLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            accentLine.widthAnchor.constraint(equalToConstant: 2),
            accentLine.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        switch model.evolutionStage {
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
    
    
    func toggleState() {
        if isExpaned {
            commpressStatus()
        } else {
            expandStatus()
        }
        isExpaned.toggle()
        self.spacing = isExpaned ? Constant.expanedSpacing : Constant.compressSpacing
    }
    
    func expandStatus() {
        // TODO: Alesya Volosach | Доработать метод карточка и таблица разные виды сворачивания
        if model?.card != nil {
            expandStatusForCard()
        } else {
            expandStatusForTable()
        }
    }
    
    private func expandStatusForTable() {
        stepsViews.enumerated().forEach { index, view in
            guard let model = model else { return }
            view.setType(model.steps[index])
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
    
    func commpressStatus() {
        // TODO: Alesya Volosach | Доработать метод карточка и таблица разные виды сворачивания
        if model?.card != nil {
            commpressStatusForCard()
        } else {
            commpressStatusForTable()
        }
    }
    
    private func commpressStatusForTable() {
        guard let model = model else { return }
        
        guard let stepForShortView = model.stepForShortView else {
            // TODO: Alesya Volosach | По идее невозможный кейс
            stepsViews.enumerated().forEach { index, view in
                view.isHidden = true
            }
            return
        }

        stepsViews.last?.setType(stepForShortView)
        
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
