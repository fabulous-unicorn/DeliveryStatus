//
//  ViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var containerStackView: UIStackView!
    private var backgroundLine = UIView()
    private var accentLine = UIView()
    
    @IBOutlet weak var titleView: DeliveryStatusTitleView!
    @IBOutlet var descriptionViews: [DeliveryStatusDescriptionView]!
    
    @IBOutlet weak var infoView: UIStackView!
    
    let descriptionInfo: [(DeliveryStatusDescriptionView.ViewType, Bool)] = [
        (.subhead(title: "Москва"), true),
        (.full(
            title: "Принято на доставку",
            date: "22.04.2020",
            status: .orange
        ), false),
        (.full(
            title: "Отправлено в город назначения",
            date: "22.04.2020",
            status: .orange
        ), false),
        (.subhead(title: "Новосибирск"), true),
        (.full(
            title: "Готов  к выдаче",
            date: "22.04.2020",
            status: .orange
        ), false)
    ]
    
    let shortDescriptionInfo: (DeliveryStatusDescriptionView.ViewType, Bool) =
    (
        .full(
            title: "Новосибирск / Принято на склад доставки",
            date: "22.04.2020",
            status: .orange
        ),
        true
    )
    
    private var isExpaned = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.delegate = self
        
        toggleState()
        
        // Set accent line
        
        accentLine.backgroundColor = .orange
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.insertSubview(accentLine, at: 0)
        
        NSLayoutConstraint.activate([
            accentLine.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 13),
            accentLine.widthAnchor.constraint(equalToConstant: 2),
            accentLine.topAnchor.constraint(equalTo: containerStackView.topAnchor)
        ])
        
        if let lastView = self.descriptionViews.last {
            accentLine.bottomAnchor.constraint(equalTo: lastView.centerYAnchor).isActive = true
        }
        
        // Set bg line
        backgroundLine.backgroundColor = .lightGray
        backgroundLine.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.insertSubview(backgroundLine, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundLine.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 13),
            backgroundLine.widthAnchor.constraint(equalToConstant: 2),
            backgroundLine.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            backgroundLine.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor)
        ])

    }
    
    func toggleState() {
        if isExpaned {
            commpressStatus()
        } else {
            expandStatus()
        }
        isExpaned.toggle()
        containerStackView.spacing = isExpaned ? 6 : 2
    }
    
    func expandStatus() {
        descriptionViews.enumerated().forEach { index, view in
            view.setType(
                descriptionInfo[index].0,
                isPrimary: descriptionInfo[index].1
            )
        }
        descriptionViews.forEach { view in
                view.alpha = 1
                view.isHidden = false
        }
    }
    
    func commpressStatus() {
        descriptionViews.last?.setType(shortDescriptionInfo.0, isPrimary: shortDescriptionInfo.1)
        
        descriptionViews.enumerated().forEach { index, view in
            view.isHidden = index == descriptionViews.count - 1 ? false : true
            view.alpha = index == descriptionViews.count - 1 ? 1 : 0
        }
    }
}

extension ViewController: DeliveryStatusTitleDelegate {
    func tappedTitle() {
        UIView.animate(withDuration: 0.5) {
            self.toggleState()
            self.containerStackView.setNeedsLayout()
        }
    }
}
