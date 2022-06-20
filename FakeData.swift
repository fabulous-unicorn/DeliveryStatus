//
//  FakeData.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 20.06.2022.
//

import Foundation
import UIKit

enum FakeData {
    static let mainModel = OrderDetailInfoViewModel(
        groups: [
            .header(item: OrderDetailInfoViewModel.HeaderItem(
                title: "Посылочка, размер S.",
                description: "Супер-экспресс, доставит курьер до 16:00."
            )),
            .actor(
                role: .sender,
                items: [
                    OrderDetailInfoViewModel.OrderActor(
                        title: "Москва, ул. Ленина 234, кв. 56",
                        icon: UIImage(named: "orderDetailInfo.mapPin")!,
                        behavior: .copy
                    ),
                    OrderDetailInfoViewModel.OrderActor(
                        title: "Иванов Алексей Евгеньевич",
                        icon: UIImage(named: "orderDetailInfo.userCircle")!,
                        behavior: .copy
                    ),
                    OrderDetailInfoViewModel.OrderActor(
                        title: "+7 (000) 000-00-00",
                        icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                        behavior: .contact(
                            modalTitle: "Связаться с отправителем"
                        )
                    )
                ]
            ),
            .actor(
                role: .receiver,
                items: [
                    OrderDetailInfoViewModel.OrderActor(
                        title: "Новосибирск, ул. Писарева 136, кв. 152",
                        icon: UIImage(named: "orderDetailInfo.mapPin")!,
                        behavior: .copy
                    ),
                    OrderDetailInfoViewModel.OrderActor(
                        title: "Иванов Сергей Алексеевич",
                        icon: UIImage(named: "orderDetailInfo.userCircle")!,
                        behavior: .copy
                    ),
                    OrderDetailInfoViewModel.OrderActor(
                        title: "+7 (000) 000-00-00",
                        icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                        behavior: .contact(
                            modalTitle: "Связаться с получателем"
                        )
                    )
                ]
            ),
            .additionalServices(
                services: [
                    OrderDetailInfoViewModel.AdditionalService(
                        title: "Страхование",
                        description: ["Объявленная стоимость: 1 000 ₽"]
                    ),
                    OrderDetailInfoViewModel.AdditionalService(
                        title: "Коробка",
                        description: ["10 кг. 40×35×28 см. / 10 шт.", "30 кг. 69×39×42 см. / 5 шт."]
                    ),
                    OrderDetailInfoViewModel.AdditionalService(
                        title: "Доп. упаковочные материалы",
                        description: ["Макулатурная бумага / 10 м."]
                    )
                ]
            ),
            .parcelInfo(
                items: [
                    OrderDetailInfoViewModel.ParcelInfo(
                        title: "Характер груза",
                        description: "Бытовая техника, обувь",
                        additionalInfo: nil,
                        type: .default(nestedItems: [])
                    ),
                    OrderDetailInfoViewModel.ParcelInfo(
                        title: "Габариты места 1 (ДхШхВ)",
                        description: "48×42×42 см.",
                        additionalInfo: nil,
                        type: .default(nestedItems: [
                            OrderDetailInfoViewModel.ParcelInfo(
                                title: "Артикул: 435342112",
                                description: "Майка Adidas Fusion Sport Max II / 2 шт.",
                                additionalInfo: nil,
                                type: .nested
                            ),
                            OrderDetailInfoViewModel.ParcelInfo(
                                title: "Артикул: 955342111",
                                description: "Баскетбольный мяч Nike Classic / 1 шт.",
                                additionalInfo: nil,
                                type: .nested
                            )
                        ])
                    ),
                    OrderDetailInfoViewModel.ParcelInfo(
                        title: "Физический вес",
                        description: "9,8 кг",
                        additionalInfo: "Физический вес. Дополнительное описание для модалки",
                        type: .default(nestedItems: [])
                    )
                ]
            )
        ]
    )
//
//    let actorCellModels = [
//        OrderDetailInfoViewModel.OrderActor(
//            title: "Москва, ул. Ленина 234, кв. 56",
//            icon: UIImage(named: "orderDetailInfo.mapPin")!,
//            behavior: .copy
//        ),
//        OrderDetailsInfoViewModel.OrderActor(
//            title: "Иванов Алексей Евгеньевич",
//            icon: UIImage(named: "orderDetailInfo.userCircle")!,
//            behavior: .copy
//        ),
//        OrderDetailsInfoViewModel.OrderActor(
//            title: "+7 (000) 000-00-00",
//            icon: UIImage(named: "orderDetailInfo.messageCircle")!,
//            behavior: .contact
//        )
//    ]
//
//    let serviceCellModels = [
//        OrderDetailsInfoViewModel.AdditionalService(
//            title: "Страхование",
//            description: ["Объявленная стоимость: 1 000 ₽"]
//        ),
//        OrderDetailsInfoViewModel.AdditionalService(
//            title: "Коробка",
//            description: ["10 кг. 40×35×28 см. / 10 шт.", "30 кг. 69×39×42 см. / 5 шт."]
//        ),
//        OrderDetailsInfoViewModel.AdditionalService(
//            title: "Доп. упаковочные материалы",
//            description: ["Макулатурная бумага / 10 м."]
//        )
//    ]
//
//    let parcelInfoModels = [
//        OrderDetailsInfoViewModel.ParcelInfo(
//            title: "Характер груза",
//            description: "Бытовая техника, обувь",
//            additionalInfo: nil,
//            type: .default(nestedItems: [])
//        ),
//        OrderDetailsInfoViewModel.ParcelInfo(
//            title: "Габариты места 1 (ДхШхВ)",
//            description: "48×42×42 см.",
//            additionalInfo: nil,
//            type: .default(nestedItems: [
//                OrderDetailsInfoViewModel.ParcelInfo(
//                    title: "Артикул: 435342112",
//                    description: "Майка Adidas Fusion Sport Max II / 2 шт.",
//                    additionalInfo: nil,
//                    type: .nested
//                ),
//                OrderDetailsInfoViewModel.ParcelInfo(
//                    title: "Артикул: 955342111",
//                    description: "Баскетбольный мяч Nike Classic / 1 шт.",
//                    additionalInfo: nil,
//                    type: .nested
//                )
//            ])
//        ),
//        OrderDetailsInfoViewModel.ParcelInfo(
//            title: "Физический вес",
//            description: "9,8 кг",
//            additionalInfo: "Физический вес. Дополнительное описание для модалки",
//            type: .default(nestedItems: [])
//        )
//    ]
    
    
}
