//
//  OrderDetailInfoViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailInfoViewController: UITableViewController {
    
    enum Constants {
        static let titleGroupCellIdentifier = "orderDetailsInfoTitleGroupCell"
        static let actorCellIdentifier = "orderDetailsInfoOrderActorCell"
        static let serviceCellIdentifier = "orderDetailsInfoServiceCell"
        static let parcelInfocellIdentifier = "orderDetailsInfoParcelInfoCell"
    }
    
//    let models = [
//        OrderDetailsInfoViewModel.OrderActor(
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
    
    let models = [
        OrderDetailsInfoViewModel.AdditionalService(
            title: "Страхование",
            description: ["Объявленная стоимость: 1 000 ₽"]
        ),
        OrderDetailsInfoViewModel.AdditionalService(
            title: "Коробка",
            description: ["10 кг. 40×35×28 см. / 10 шт.", "30 кг. 69×39×42 см. / 5 шт."]
        ),
        OrderDetailsInfoViewModel.AdditionalService(
            title: "Доп. упаковочные материалы",
            description: ["Макулатурная бумага / 10 м."]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "OrderDetailsInfoTitleGroupCell", bundle: nil), forCellReuseIdentifier: Constants.titleGroupCellIdentifier)
        tableView.register(UINib(nibName: "OrderDetailsInfoOrderActorCell", bundle: nil), forCellReuseIdentifier: Constants.actorCellIdentifier)
        tableView.register(UINib(nibName: "OrderDetailsInfoServiceCell", bundle: nil), forCellReuseIdentifier: Constants.serviceCellIdentifier)
        tableView.register(UINib(nibName: "OrderDetailsInfoParcelInfoCell", bundle: nil), forCellReuseIdentifier: Constants.parcelInfocellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mainModel.groups.count - 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ServiceCell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.serviceCellIdentifier, for: indexPath) as! OrderDetailsInfoServiceCell
        let model = self.models[indexPath.row]
        cell.configure(with: model)
        
        // ActorCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.actorCellIdentifier, for: indexPath) as! OrderDetailsInfoOrderActorCell
//        let model = self.models[indexPath.row]
//        cell.configure(with: model)
        
        // TitleCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleGroupCellIdentifier, for: indexPath) as! OrderDetailsInfoTitleGroupCell
//        cell.configure(title: "Откуда").
        

        return cell
    }
    
    // MARK: - for test
    let mainModel = OrderDetailsInfoViewModel(
        title: "Посылочка, размер S",
        description: "Супер-экспресс, доставит курьер до 16:00",
        groups: [
            .actor(
                role: .sender,
                items: [
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Москва, ул. Ленина 234, кв. 56",
                        icon: UIImage(named: "orderDetailInfo.mapPin")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Иванов Алексей Евгеньевич",
                        icon: UIImage(named: "orderDetailInfo.userCircle")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "+7 (000) 000-00-00",
                        icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                        behavior: .contact
                    )
                ]
            ),
            .actor(
                role: .receiver,
                items: [
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Новосибирск, ул. Писарева 136, кв. 152",
                        icon: UIImage(named: "orderDetailInfo.mapPin")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Иванов Сергей Алексеевич",
                        icon: UIImage(named: "orderDetailInfo.userCircle")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "+7 (000) 000-00-00",
                        icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                        behavior: .contact
                    )
                ]
            ),
            .additionalServices(
                services: [
                    OrderDetailsInfoViewModel.AdditionalService(
                        title: "Страхование",
                        description: ["Объявленная стоимость: 1 000 ₽"]
                    ),
                    OrderDetailsInfoViewModel.AdditionalService(
                        title: "Коробка",
                        description: ["10 кг. 40×35×28 см. / 10 шт.", "30 кг. 69×39×42 см. / 5 шт."]
                    ),
                    OrderDetailsInfoViewModel.AdditionalService(
                        title: "Доп. упаковочные материалы",
                        description: ["Макулатурная бумага / 10 м."]
                    )
                ]
            ),
            .parcelInfo(
                items: [
                    OrderDetailsInfoViewModel.ParcelInfo(
                        title: "Характер груза",
                        description: "Бытовая техника, обувь",
                        additionalInfo: nil,
                        type: .default(nestedItems: [])
                    ),
                    OrderDetailsInfoViewModel.ParcelInfo(
                        title: "Габариты места 1 (ДхШхВ)",
                        description: "48×42×42 см.",
                        additionalInfo: nil,
                        type: .default(nestedItems: [
                            OrderDetailsInfoViewModel.ParcelInfo(
                                title: "Артикул: 435342112",
                                description: "Майка Adidas Fusion Sport Max II / 2 шт.",
                                additionalInfo: nil,
                                type: .nested
                            ),
                            OrderDetailsInfoViewModel.ParcelInfo(
                                title: "Артикул: 955342111",
                                description: "Баскетбольный мяч Nike Classic / 1 шт.",
                                additionalInfo: nil,
                                type: .nested
                            )
                        ])
                    ),
                    OrderDetailsInfoViewModel.ParcelInfo(
                        title: "Физический вес",
                        description: "9,8 кг",
                        additionalInfo: "Физический вес. Дополнительное описание для модалки",
                        type: .default(nestedItems: [])
                    )
                ]
            )
        ]
    )
}
