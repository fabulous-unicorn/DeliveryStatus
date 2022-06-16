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
        
        // Created
//        let order = getCreatedOrder()

        // ReadyForPickUp
        let order = getOrderWithNewStatus()
        
        // StatusWidget
        let statusWidget = DeliveryStatusWidgetView()
        let steps = StatusWidgetViewModelBuilder.buildStatuses(order)
        statusWidget.configure(with: steps)
        
        // StatusWidget
        let orderDetailInfoWidget = OrderDetailInfoWidget()
        
        self.containerStackView.addArrangedSubview(statusWidget)
        self.containerStackView.addArrangedSubview(orderDetailInfoWidget)
    }
}

extension ViewController {
    // Дверь -> Дверь
    func getCreatedOrder() -> Order {
        return Order(
            plannedDeliveryDate: nil,
            status: OrderStatus.init(code: "INVOICE_CREATED", name: "Заказ создан"),
            sender: PersonShortInfo(address: "ул. Ленина 234, кв. 56"),
            senderDeliveryType: .home,
            receiver: PersonShortInfo(address: "ул. Лен 200, кв. 2"),
            receiverDeliveryType: .home,
            departureCity: City(name: "Москва"),
            destinationCity: City(name: "Москва"),
            senderOffice: nil,
            office: nil,
            canBeChanged: true,
            storageDateEnd: nil,
            warehousingInfoUrl: nil,
            pickUp: PickUp(
                arrivalDate: "18.04.2020",
                arrivalTimeFrom: "16:00",
                arrivalTimeTo: "18:00"
            ),
            orderStatusGroups: [
                OrderStatusGroupDto(
                    name: "Создан заказ",
                    code: .initial,
                    message: """
                    Отправитель еще не передал посылку
                    для доставки в СДЭК
                    """,
                    occurrence: "17.04.2020",
                    evolutionStage: .present,
                    roadMap: []
                ),
                OrderStatusGroupDto(
                    name: "Посылка в пути",
                    code: .inProgress,
                    message: nil,
                    occurrence: nil,
                    evolutionStage: .future,
                    roadMap: []
                ),
                OrderStatusGroupDto(
                    name: "Доставка курьером",
                    code: .courierInProgress,
                    message: nil,
                    occurrence: nil,
                    evolutionStage: .future,
                    roadMap: []
                ),
                OrderStatusGroupDto(
                    name: "Вручение",
                    code: .recived,
                    message: nil,
                    occurrence: nil,
                    evolutionStage: .future,
                    roadMap: []
                )
            ],
            plannedDeliveryDateNote: nil,
            plannedDeliveryNotAvailableNote: """
                     Плановая дата доставки будет определена
                     после поступления заказа в СДЭК
                     """
        )
    }
    
    
    // ПВЗ -> Постамат
    func getOrder() -> Order {
        return Order(
            plannedDeliveryDate: "22 апреля 2020",
            status: OrderStatus.init(code: "READY_FOR_RECEIPT", name: "Готово к выдаче"),
            sender: nil,
            senderDeliveryType: .pvz,
            receiver: nil,
            receiverDeliveryType: .postomate,
            departureCity: City(name: "Москва"),
            destinationCity: City(name: "Новосибирск"),
            senderOffice: Office(id: 0, address: "ул. Ленина 234"),
            office: Office(id: 1, address: "ул. Лен 200"),
            canBeChanged: true,
            storageDateEnd: "27.04.2020",
            warehousingInfoUrl: URL(string: "https://www.cdek.ru/ru"),
            pickUp: nil,
            orderStatusGroups: [
                OrderStatusGroupDto(
                    name: "Создан заказ",
                    code: .initial,
                    message: nil,
                    occurrence: "17.04.2020",
                    evolutionStage: .past,
                    roadMap: []
                ),
                OrderStatusGroupDto(
                    name: "Посылка в пути",
                    code: .inProgress,
                    message: nil,
                    occurrence: "20.04.2020",
                    evolutionStage: .past,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: "Москва",
                            statuses: [
                                StatusDto(title: "Принято на доставку", date: "21.04.2020"),
                                StatusDto(title: "Отправлено в город назначения", date: "21.04.2020")
                            ]
                        ),
                        OrderDeliveryStepDto(
                            city: "Новосибирск",
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Готов к выдаче",
                    code: .readyForPickUp,
                    message: nil,
                    occurrence: "21.04.2020",
                    evolutionStage: .present,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: nil,
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Вручение",
                    code: .recived,
                    message: nil,
                    occurrence: nil,
                    evolutionStage: .future,
                    roadMap: []
                )
            ],
            plannedDeliveryDateNote: "Поступление в пункт СДЭК до:",
            plannedDeliveryNotAvailableNote: nil
        )
    }
    
    // ПВЗ -> Постамат
    func getOrderWithUnknowDeliveryType() -> Order {
        return Order(
            plannedDeliveryDate: "22 апреля 2020",
            status: OrderStatus.init(code: "READY_FOR_RECEIPT", name: "Готово к выдаче"),
            sender: nil,
            senderDeliveryType: .pvz,
            receiver: nil,
            receiverDeliveryType: nil,
            departureCity: City(name: "Москва"),
            destinationCity: City(name: "Новосибирск"),
            senderOffice: Office(id: 0, address: "ул. Ленина 234"),
            office: Office(id: 1, address: "ул. Лен 200"),
            canBeChanged: true,
            storageDateEnd: "27.04.2020",
            warehousingInfoUrl: URL(string: "https://www.cdek.ru/ru"),
            pickUp: nil,
            orderStatusGroups: [
                OrderStatusGroupDto(
                    name: "Создан заказ",
                    code: .initial,
                    message: nil,
                    occurrence: "17.04.2020",
                    evolutionStage: .past,
                    roadMap: []
                ),
                OrderStatusGroupDto(
                    name: "Посылка в пути",
                    code: .inProgress,
                    message: nil,
                    occurrence: "20.04.2020",
                    evolutionStage: .past,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: "Москва",
                            statuses: [
                                StatusDto(title: "Принято на доставку", date: "21.04.2020"),
                                StatusDto(title: "Отправлено в город назначения", date: "21.04.2020")
                            ]
                        ),
                        OrderDeliveryStepDto(
                            city: "Новосибирск",
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Готов к выдаче",
                    code: .readyForPickUp,
                    message: nil,
                    occurrence: "21.04.2020",
                    evolutionStage: .present,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: nil,
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Вручение",
                    code: .recived,
                    message: nil,
                    occurrence: nil,
                    evolutionStage: .future,
                    roadMap: []
                )
            ],
            plannedDeliveryDateNote: "Поступление в пункт СДЭК до:",
            plannedDeliveryNotAvailableNote: nil
        )
    }
    
    
    
    // ПВЗ -> Постамат
    func getOrderWithNewStatus() -> Order {
        return Order(
            plannedDeliveryDate: "22 апреля 2020",
            status: OrderStatus.init(code: "READY_FOR_RECEIPT", name: "Готово к выдаче"),
            sender: nil,
            senderDeliveryType: .pvz,
            receiver: nil,
            receiverDeliveryType: .postomate,
            departureCity: City(name: "Москва"),
            destinationCity: City(name: "Новосибирск"),
            senderOffice: Office(id: 0, address: "ул. Ленина 234"),
            office: Office(id: 1, address: "ул. Лен 200"),
            canBeChanged: true,
            storageDateEnd: "27.04.2020",
            warehousingInfoUrl: URL(string: "https://www.cdek.ru/ru"),
            pickUp: nil,
            orderStatusGroups: [
                OrderStatusGroupDto(
                    name: "Создан заказ",
                    code: .initial,
                    message: nil,
                    occurrence: "17.04.2020",
                    evolutionStage: .past,
                    roadMap: []
                ),
                OrderStatusGroupDto(
                    name: "Посылка в пути",
                    code: .inProgress,
                    message: nil,
                    occurrence: "20.04.2020",
                    evolutionStage: .past,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: "Москва",
                            statuses: [
                                StatusDto(title: "Принято на доставку", date: "21.04.2020"),
                                StatusDto(title: "Отправлено в город назначения", date: "21.04.2020")
                            ]
                        ),
                        OrderDeliveryStepDto(
                            city: "Новосибирск",
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Посылка на таможне",
                    code: .unknowned,
                    message: nil,
                    occurrence: "20.04.2020",
                    evolutionStage: .past,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: "Москва",
                            statuses: [
                                StatusDto(title: "Принято на доставку", date: "21.04.2020"),
                                StatusDto(title: "Отправлено в город назначения", date: "21.04.2020")
                            ]
                        ),
                        OrderDeliveryStepDto(
                            city: "Новосибирск",
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Готов к выдаче",
                    code: .readyForPickUp,
                    message: nil,
                    occurrence: "21.04.2020",
                    evolutionStage: .present,
                    roadMap: [
                        OrderDeliveryStepDto(
                            city: nil,
                            statuses: [
                                StatusDto(title: "Готов  к выдаче", date: "22.04.2020")
                            ]
                        )
                    ]
                ),
                OrderStatusGroupDto(
                    name: "Вручение",
                    code: .recived,
                    message: nil,
                    occurrence: nil,
                    evolutionStage: .future,
                    roadMap: []
                )
            ],
            plannedDeliveryDateNote: "Поступление в пункт СДЭК до:",
            plannedDeliveryNotAvailableNote: nil
        )
    }
}
