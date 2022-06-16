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
    
    private typealias DataSource = UITableViewDiffableDataSource<OrderDetailsInfoViewModel.ContentGroup, AnyHashable>
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "OrderDetailsInfoTitleGroupCell", bundle: nil), forCellReuseIdentifier: Constants.titleGroupCellIdentifier)
        tableView.register(UINib(nibName: "OrderDetailsInfoOrderActorCell", bundle: nil), forCellReuseIdentifier: Constants.actorCellIdentifier)
        tableView.register(UINib(nibName: "OrderDetailsInfoServiceCell", bundle: nil), forCellReuseIdentifier: Constants.serviceCellIdentifier)
        tableView.register(UINib(nibName: "OrderDetailsInfoParcelInfoCell", bundle: nil), forCellReuseIdentifier: Constants.parcelInfocellIdentifier)
        
        self.dataSource = makeDataSource()
        self.initialConfigureGroups(self.mainModel)
    }

    // MARK: - Table view data source
    
    private func makeDataSource() -> DataSource? {
        let dataSource = DataSource(
            tableView: tableView
        ) { tableView, indexPath, item in

            if let titleGroup = item as? String {
                let identifier = Constants.titleGroupCellIdentifier
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderDetailsInfoTitleGroupCell
                cell.configure(title: titleGroup)
                return cell
            }
            
            if let actor = item as? OrderDetailsInfoViewModel.OrderActor {
                let identifier = Constants.actorCellIdentifier
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderDetailsInfoOrderActorCell
                cell.configure(with: actor)
                return cell
            }
            
            if let service = item as? OrderDetailsInfoViewModel.AdditionalService {
                let identifier = Constants.serviceCellIdentifier
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderDetailsInfoServiceCell
                cell.configure(with: service)
                return cell
            }
            
            if let parcelInfo = item as? OrderDetailsInfoViewModel.ParcelInfo {
                let identifier = Constants.parcelInfocellIdentifier
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! OrderDetailsInfoParcelInfoCell
                cell.configure(with: parcelInfo)
                return cell
            }
            return nil
      }
        
        return dataSource
    }
    
    func initialConfigureGroups(_ mainModel: OrderDetailsInfoViewModel) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        
        snapshot.appendSections(mainModel.groups)

        
        mainModel.groups.forEach{ group in
            snapshot.appendItems([group.title], toSection: group)
            
            switch group {
            case let .actor(_, items):
                snapshot.appendItems(items, toSection: group)
            case let .additionalServices(services):
                snapshot.appendItems(services, toSection: group)
            case let .parcelInfo(items):
                snapshot.appendItems(items, toSection: group)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
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
    
    let actorCellModels = [
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
    
    let serviceCellModels = [
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
    
    let parcelInfoModels = [
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
}
