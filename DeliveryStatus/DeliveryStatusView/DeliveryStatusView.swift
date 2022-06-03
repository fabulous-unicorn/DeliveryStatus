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
        self.isLayoutMarginsRelativeArrangement = true
        self.addArrangedSubview(titleView)
        self.addArrangedSubview(stepsContainerView)
        self.axis = .vertical
        self.stepsContainerView.axis = .vertical
        self.stepsContainerView.spacing = 8.0
        
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
        
        toggleState()
        setLine()
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
            }
        case .future:
            accentLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        
        // Set bg line
        backgroundLine.backgroundColor = UIColor.hexStringToUIColor(hex: "DFDFDF")
        backgroundLine.translatesAutoresizingMaskIntoConstraints = false
        self.self.insertSubview(backgroundLine, at: 0)
        
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
        stepsViews.enumerated().forEach { index, view in
            guard let model = model else { return }
            view.setType(model.steps[index])
        }
        stepsViews.forEach { view in
                view.alpha = 1
                view.isHidden = false
        }
    }
    
    func commpressStatus() {
        guard let model = model else { return }
        stepsViews.last?.setType(model.shortInfo)
        
        stepsViews.enumerated().forEach { index, view in
            view.isHidden = index == stepsViews.count - 1 ? false : true
            view.alpha = index == stepsViews.count - 1 ? 1 : 0
        }
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
