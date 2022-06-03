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
    private var pointsContainerView = UIStackView()
    private var backgroundLine = UIView()
    private var accentLine = UIView()
    private var isExpaned = true
    
    private var pointsViews: [DeliveryStatusPointView] = []
    
    private var model: DeliveryStatusViewModel?
    
//    private weak var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
//        self.titleView.delegate = self
        
        self.isLayoutMarginsRelativeArrangement = true
        self.addArrangedSubview(titleView)
        self.addArrangedSubview(pointsContainerView)
        self.axis = .vertical
        self.pointsContainerView.axis = .vertical
        self.pointsContainerView.spacing = 8.0
        
        self.layoutMargins = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func configure(_ model: DeliveryStatusViewModel) {
        self.model = model
        
        self.titleView.configure(model.title, self)
        
        model.steps.forEach { point in
            let view = DeliveryStatusPointView()
            view.setType(point)
            self.pointsViews.append(view)
            self.pointsContainerView.addArrangedSubview(view)
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
            if let lastView = self.pointsViews.last {
                accentLine.bottomAnchor.constraint(equalTo: lastView.centerYAnchor).isActive = true
            }
        case .future:
            accentLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
        
        // Set bg line
        backgroundLine.backgroundColor = .lightGray
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
        self.spacing = isExpaned ? 6 : 2
    }
    
    func expandStatus() {
        pointsViews.enumerated().forEach { index, view in
            guard let model = model else { return }
            view.setType(model.steps[index])
        }
        pointsViews.forEach { view in
                view.alpha = 1
                view.isHidden = false
        }
    }
    
    func commpressStatus() {
        guard let model = model else { return }
        pointsViews.last?.setType(model.shortInfo)
        
        pointsViews.enumerated().forEach { index, view in
            view.isHidden = index == pointsViews.count - 1 ? false : true
            view.alpha = index == pointsViews.count - 1 ? 1 : 0
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
