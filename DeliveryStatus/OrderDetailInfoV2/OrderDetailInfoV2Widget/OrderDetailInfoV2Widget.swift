//
//  InfoDepartureWidget.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import Foundation
import UIKit

class OrderDetailInfoV2Widget: UIView {
    // TODO: Alesya Volosach | можно и из контейнера вытащить
    @IBOutlet private weak var contentView: UIView!
    
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
        Bundle.main.loadNibNamed("OrderDetailInfoV2WidgetView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    // MARK: - Actions Outlets
    
    @IBAction func tappedWidget(_ sender: Any) {
        print("| Log | tappedWidget")
//        delegate?.tapped()
    }
}
