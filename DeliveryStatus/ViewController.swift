//
//  ViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var containerStackView: UIStackView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view0 = DeliveryStatusView()
        view0.configure(getCreateStatus(.past, isLastStatus: false))
        self.containerStackView.addArrangedSubview(view0)
        
        let view1 = DeliveryStatusView()
        view1.configure(getStatusInProgress(.past, isLastStatus: false))
        self.containerStackView.addArrangedSubview(view1)
        
        let view2 = DeliveryStatusView()
        view2.configure(getStatusCourier(.present, isLastStatus: false))
        self.containerStackView.addArrangedSubview(view2)
        
        let view3 = DeliveryStatusView()
        view3.configure(getStatusDelivered(.future, isLastStatus: true))
        self.containerStackView.addArrangedSubview(view3)
    }
}

extension ViewController {
    func getCreateStatus(
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
        
        let cardModel = DeliveryStatusViewModel.CardExample(
            mode: .home,
            address: "Москва, ул. Ленина 234, кв. 56",
            officeId: 1,
            pickUpInfo: """
                        Дата и время вручения:
                        18.04.2020 с 16:00 до 18:00
                        """,
            displayChangeButton: true,
            planedDeliveryInfo: """
                        Поступление в курьерскую службу до:
                        22 апреля 2020
                        """,
            keepDateInfo: """
                        Срок хранения до:
                        29 апреля 2022
                        """,
            keepInfoLink: URL(string: "")
        )
        
//        let cardModel = DeliveryStatusViewModel.CardExample(
//            mode: .home,
//            address: "Москва, ул. Ленина 234, кв. 56",
//            displayChangeButton: true,
//            message: """
//                     Плановая дата доставки будет определена
//                     после поступления заказа в СДЭК
//                     """
//        )
        
        return DeliveryStatusViewModel(
            group: .created,
            evolutionStage: evolutionStage,
            isLastStatus: isLastStatus,
            title: "Создан заказ",
            date: "17.04.2020",
            steps: [],
            card: cardModel
        )
    }
    
    func getStatusInProgress(
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
        group: .inProgress,
        evolutionStage: evolutionStage,
        isLastStatus: isLastStatus,
        title: "Посылка прибыла",
        date: "18.04.2020",
        steps: [
            DeliveryStatusViewModel.StepExample(
                title: "Москва",
                type: .subhead
            ),
            DeliveryStatusViewModel.StepExample(
                title: "Принято на доставку",
                type: .point(
                    date: "18.04.2020",
                    isPrimary: false
                )
            ),
            DeliveryStatusViewModel.StepExample(
                title: "Отправлено в город назначения",
                type: .point(
                    date: "20.04.2020",
                    isPrimary: false
                )
            ),
            DeliveryStatusViewModel.StepExample(
                title: "Новосибирск",
                type: .subhead
            ),
            DeliveryStatusViewModel.StepExample(
                title: "Готов  к выдаче",
                type: .point(
                    date: "22.04.2020",
                    isPrimary: false
                )
            )
        ]
    )
    }
    
    func getStatusCourier(
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
        return DeliveryStatusViewModel(
            group: .courier,
            evolutionStage: evolutionStage,
            isLastStatus: isLastStatus,
            title: "Доставка курьером",
            date: "19.04.2020",
            steps: [
                DeliveryStatusViewModel.StepExample(
                    title: "Выдано курьеру",
                    type: .point(
                        date: "22.04.2020",
                        isPrimary: true
                    )
                ),
                DeliveryStatusViewModel.StepExample(
                    title: "Курьер не смог вручить посылку",
                    type: .point(
                        date: "22.04.2020",
                        isPrimary: true
                    )
                )
            ])
    }

    
    func getStatusDelivered(
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        isLastStatus: Bool
    )  -> DeliveryStatusViewModel {
    return DeliveryStatusViewModel(
        group: .recived,
                evolutionStage: evolutionStage,
                isLastStatus: isLastStatus,
                title: "Вручение",
                date: nil,
                steps: []
            )
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
