//
//  ViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var containerStackView: UIStackView!
    
    func getStatus(
        _ group: DeliveryStatusViewModel.Group,
        _ evolutionStage: DeliveryStatusViewModel.Stage
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
            group: group,
            evolutionStage: evolutionStage,
            title: DeliveryStatusTitleViewModel(
                title: "Посылка прибыла",
                date: nil,
                isExpanded: true,
                evolutionStage: evolutionStage,
                group: group
            ),
            steps: [
                DeliveryStatusStepViewModel(
                    title: "Москва",
                    type: .subhead,
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusStepViewModel(
                    title: "Принято на доставку",
                    type: .point(
                        date: "18.04.2020",
                        isPrimary: false
                    ),
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusStepViewModel(
                    title: "Отправлено в город назначения",
                    type: .point(
                        date: "20.04.2020",
                        isPrimary: false
                    ),
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusStepViewModel(
                    title: "Новосибирск",
                    type: .subhead,
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusStepViewModel(
                    title: "Готов  к выдаче",
                    type: .point(
                        date: "22.04.2020",
                        isPrimary: false
                    ),
                    evolutionStage: evolutionStage,
                    group: group
                )
            ]
        )
    }
    
    func getStatusPrimary(
        _ group: DeliveryStatusViewModel.Group,
        _ evolutionStage: DeliveryStatusViewModel.Stage
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
        group: group,
        evolutionStage: evolutionStage,
        title: DeliveryStatusTitleViewModel(
            title: "Доставка курьером",
            date: nil,
            isExpanded: true,
            evolutionStage: evolutionStage,
            group: group
        ),
        steps: [
            DeliveryStatusStepViewModel(
                title: "Выдано курьеру",
                type: .point(
                    date: "22.04.2020",
                    isPrimary: true
                ),
                evolutionStage: evolutionStage,
                group: group
            ),
            DeliveryStatusStepViewModel(
                title: "Курьер не смог вручить посылку",
                type: .point(
                    date: "22.04.2020",
                    isPrimary: true
                ),
                evolutionStage: evolutionStage,
                group: group
            )
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let group1: DeliveryStatusViewModel.Group = .inProgress
        let evolutionStage1: DeliveryStatusViewModel.Stage = .past
        
        let group2: DeliveryStatusViewModel.Group = .courier
        let evolutionStage2: DeliveryStatusViewModel.Stage = .present
        
        let view = DeliveryStatusView()
        view.configure(getStatus(group1, evolutionStage1))
        self.containerStackView.addArrangedSubview(view)
        
        let view2 = DeliveryStatusView()
        view2.configure(getStatusPrimary(group2, evolutionStage2))
        self.containerStackView.addArrangedSubview(view2)
    }
}
