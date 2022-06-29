//
//  HowSendReceiveWidget.swift
//  Widgets
//
//  Created by Alesya Volosach on 29.06.2022.
//

import Foundation
import UIKit

class HowSendReceiveWidget: UIStackView {
    @IBOutlet private var contentView: UIStackView!
    
    enum Constant {
        // TODO: Alesya Volosach | было бы круто вынести куда-то к ui-lib эту константу, она распространяется на все виджеты и практически все плашки
        static let surfaceCornerRadius: CGFloat = 12
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("HowSendReceiveWidget", owner: self, options: nil)
        self.addArrangedSubview(contentView)
        self.axis = .vertical
        
        setBackgroundStyle()
    }
    
    func setBackgroundStyle() {
        if #available(iOS 14, *) {
            contentView.cornerRadius = Constant.surfaceCornerRadius
            contentView.backgroundColor = UIColor(named: "Surface Background")
            contentView.shadowColor = .black
            contentView.shadowOffset = .init(x: 0, y: 0)
            contentView.shadowOpacity = 0.1
            contentView.shadowRadius = 8
        } else {
            let mainInfoBackgroundView = UIView()
            mainInfoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            contentView.insertSubview(mainInfoBackgroundView, at: 0)
            NSLayoutConstraint.activate([
                mainInfoBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                mainInfoBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                mainInfoBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
                mainInfoBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
                        
            mainInfoBackgroundView.cornerRadius = Constant.surfaceCornerRadius
            mainInfoBackgroundView.backgroundColor = UIColor(named: "Surface Background")
            mainInfoBackgroundView.shadowColor = .black
            mainInfoBackgroundView.shadowOffset = .init(x: 0, y: 0)
            mainInfoBackgroundView.shadowOpacity = 0.1
            mainInfoBackgroundView.shadowRadius = 8
        }
    }
}
