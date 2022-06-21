//
//  DeliveryStatusWidgetView.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class DeliveryStatusWidgetView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(top: 0, left: 6, bottom: 0, right: 16)
    }
    
    func configure(with steps: [DeliveryStatusViewModel]) {
        steps.forEach { step in
            let view = DeliveryStatusView()
            view.configure(withModel: step)
            self.addArrangedSubview(view)
        }
    }

}
