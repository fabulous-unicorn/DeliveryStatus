//
//  ViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var containerStackView: UIStackView!
    let status = DeliveryStatusViewModel(
        title: DeliveryStatusTitleViewModel(
            title: "Посылка прибыла",
            group: .inProgress,
            type: .past,
            date: nil
        ),
        points: [
            DeliveryStatusPointViewModel(
                title: "Москва",
                type: .subhead
            ),
            DeliveryStatusPointViewModel(
                title: "Принято на доставку",
                type: .full(
                    date: "18.04.2020"
                )
            ),
            DeliveryStatusPointViewModel(
                title: "Отправлено в город назначения",
                type: .full(
                    date: "20.04.2020"
                )
            ),
            DeliveryStatusPointViewModel(
                title: "Новосибирск",
                type: .subhead
            ),
            DeliveryStatusPointViewModel(
                title: "Готов  к выдаче",
                type: .full(
                    date: "22.04.2020"
                )
            )
        ]
    )

    let status2 = DeliveryStatusViewModel(
        title: DeliveryStatusTitleViewModel(
            title: "Доставка курьером",
            group: .courier,
            type: .present,
            date: nil
        ),
        points: [
            DeliveryStatusPointViewModel(
                title: "Выдано курьеру",
                type: .full(
                    date: "22.04.2020"
                )
            ),
            DeliveryStatusPointViewModel(
                title: "Курьер не смог вручить посылку",
                type: .full(
                    date: "22.04.2020"
                )
            )
        ]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = DeliveryStatusView()
        view.configure(status)
        self.containerStackView.addArrangedSubview(view)
        
        let view2 = DeliveryStatusView()
        view2.configure(status2)
        self.containerStackView.addArrangedSubview(view2)
        
    }
}
