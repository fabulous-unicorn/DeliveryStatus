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
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        _ isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
            group: group,
            evolutionStage: evolutionStage,
            isLastStatus: isLastStatus,
            title: DeliveryStatusViewModel.Title(
                title: "Посылка прибыла",
                date: nil,
                isAvailableExpanded: true,
                evolutionStage: evolutionStage,
                group: group
            ),
            steps: [
                DeliveryStatusViewModel.Step(
                    title: "Москва",
                    type: .subhead,
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusViewModel.Step(
                    title: "Принято на доставку",
                    type: .point(
                        date: "18.04.2020",
                        isPrimary: false
                    ),
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusViewModel.Step(
                    title: "Отправлено в город назначения",
                    type: .point(
                        date: "20.04.2020",
                        isPrimary: false
                    ),
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusViewModel.Step(
                    title: "Новосибирск",
                    type: .subhead,
                    evolutionStage: evolutionStage,
                    group: group
                ),
                DeliveryStatusViewModel.Step(
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
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        _ isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
        group: group,
        evolutionStage: evolutionStage,
        isLastStatus: isLastStatus,
        title: DeliveryStatusViewModel.Title(
            title: "Доставка курьером",
            date: nil,
            isAvailableExpanded: true,
            evolutionStage: evolutionStage,
            group: group
        ),
        steps: [
            DeliveryStatusViewModel.Step(
                title: "Выдано курьеру",
                type: .point(
                    date: "22.04.2020",
                    isPrimary: true
                ),
                evolutionStage: evolutionStage,
                group: group
            ),
            DeliveryStatusViewModel.Step(
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
    
    func getStatus3(
        _ group: DeliveryStatusViewModel.Group,
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        _ isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
                group: group,
                evolutionStage: evolutionStage,
                isLastStatus: isLastStatus,
                title: DeliveryStatusViewModel.Title(
                    title: "Вручение",
                    date: "27.04.2020",
                    isAvailableExpanded: false,
                    evolutionStage: evolutionStage,
                    group: group
                ),
                steps: []
            )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        let group1: DeliveryStatusViewModel.Group = .inProgress
//        let evolutionStage1: DeliveryStatusViewModel.Stage = .past
//        
//        let group2: DeliveryStatusViewModel.Group = .courier
//        let evolutionStage2: DeliveryStatusViewModel.Stage = .present
//        
//        let group3: DeliveryStatusViewModel.Group = .delivered
//        let evolutionStage3: DeliveryStatusViewModel.Stage = .future
//        
//        let view = DeliveryStatusView()
//        view.configure(getStatus(group1, evolutionStage1, false))
//        self.containerStackView.addArrangedSubview(view)
//        
//        let view2 = DeliveryStatusView()
//        view2.configure(getStatusPrimary(group2, evolutionStage2, false))
//        self.containerStackView.addArrangedSubview(view2)
//        
//        let view3 = DeliveryStatusView()
//        view3.configure(getStatus3(group3, evolutionStage3, true))
//        self.containerStackView.addArrangedSubview(view3)
        
        let view4 = DeliveryStatusCardView()
        view4.configure(DeliveryStatusViewModel.Card(
            group: .delivered,
            mode: .home,
            address: "Москва, ул. Ленина 234, кв. 56",
            displayChangeButton: true,
            message: """
                     Плановая дата доставки будет определена
                     после поступления заказа в СДЭК
                     """
        ))
        self.containerStackView.addArrangedSubview(view4)
    }
}


//DeliveryStatusViewModel.Card(
//    group: .delivered,
//    mode: .home,
//    address: "Москва, ул. Ленина 234, кв. 56",
//    officeId: 1,
//    pickUpInfo: """
//                Дата и время вручения:
//                18.04.2020 с 16:00 до 18:00
//                """,
//    displayChangeButton: true,
//    planedDeliveryInfo: """
//                Поступление в курьерскую службу до:
//                22 апреля 2020
//                """
//)
