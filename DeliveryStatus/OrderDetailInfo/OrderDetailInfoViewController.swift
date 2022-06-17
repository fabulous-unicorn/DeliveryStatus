//
//  OrderDetailInfoViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailInfoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Constants {
        static let headerIdentifier = "orderDetailInfoHeader"
        
        static let titleGroupCellIdentifier = "orderDetailsInfoTitleGroupCell"
        static let actorCellIdentifier = "orderDetailsInfoOrderActorCell"
        static let serviceCellIdentifier = "orderDetailsInfoServiceCell"
        static let parcelInfoСellIdentifier = "orderDetailsInfoParcelInfoCell"
        
        static let decorationItemIdentifier = "orderDetailInfoDecorationItem"
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<OrderDetailsInfoViewModel.ContentGroup, AnyHashable>
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "OrderDetailsInfoTitleGroupCell", bundle: nil), forCellWithReuseIdentifier: Constants.titleGroupCellIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoOrderActorCell", bundle: nil), forCellWithReuseIdentifier: Constants.actorCellIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoServiceCell", bundle: nil), forCellWithReuseIdentifier: Constants.serviceCellIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoParcelInfoCell", bundle: nil), forCellWithReuseIdentifier: Constants.parcelInfoСellIdentifier)
        
        collectionView.register(UINib(nibName: "OrderDetailInfoHeader", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: Constants.headerIdentifier)
        
        
        collectionView.dataSource = dataSource
        dataSource = makeDataSource()
        initialConfigureGroups(self.mainModel)
        
        
        collectionView.collectionViewLayout = self.createBasicListLayout()
        collectionView.collectionViewLayout.register(UINib(nibName: "OrderDetailInfoDecorationItem", bundle: nil), forDecorationViewOfKind: Constants.decorationItemIdentifier)
    }

    // MARK: - Table view data source
    
    private func makeDataSource() -> DataSource? {
        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            // TODO: Alesya Volosach | Обдумать врапер
            if let titleGroup = item as? String {
                let identifier = Constants.titleGroupCellIdentifier
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoTitleGroupCell
                cell.configure(title: titleGroup)
                return cell
            }
            
            if let actor = item as? OrderDetailsInfoViewModel.OrderActor {
                let identifier = Constants.actorCellIdentifier
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoOrderActorCell
                cell.configure(with: actor)
                return cell
            }
            
            if let service = item as? OrderDetailsInfoViewModel.AdditionalService {
                let identifier = Constants.serviceCellIdentifier
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoServiceCell
                cell.configure(with: service)
                return cell
            }
            
            if let parcelInfo = item as? OrderDetailsInfoViewModel.ParcelInfo {
                let identifier = Constants.parcelInfoСellIdentifier
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoParcelInfoCell
                cell.configure(with: parcelInfo)
                return cell
            }
            return nil
      }
        
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in

            if indexPath.section == 0 {
                let identifier = Constants.headerIdentifier
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: "header",
                    withReuseIdentifier:  identifier,
                    for: indexPath) as! OrderDetailInfoHeader
                header.configure(title: self.mainModel.title, description: self.mainModel.description )

                return header
            }

//            let emptyHeader = UICollectionReusableView()
//            emptyHeader.frame = .zero
//            return emptyHeader
            return nil
        }
        
        return dataSource
    }
    
    func getSpaceView() -> UIView {
        let spaceConstant = 16
        let spaceView = UIView()
        spaceView.frame = .init(x: 0, y: 0, width: 0, height: spaceConstant)
        return spaceView
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
    
    // MARK: - For test
    // TODO: Alesya Volosach | Мем при совпадении ячейк
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
                        title: "+7 (000) 000-00-01",
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

// MARK: - UICollectionViewLayout

extension OrderDetailInfoViewController {
    
    
    func createBasicListLayout() -> UICollectionViewLayout {
//        let headerFooterSize = NSCollectionLayoutSize (widthDimension: .fractionalWidth (1.0), heightDimension: .estimated(44))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerFooterSize,
//                    elementKind: Constants.headerIdentifier, alignment: .top)
//        section.boundarySupplementaryItems = [sectionHeader]
//
        
//        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24)),
//            elementKind: Constants.headerIdentifier,
//            alignment: .top,
//            absoluteOffset: CGPoint(x: 0, y: -24)
//        )]
        
//        let layout = UICollectionViewCompositionalLayout(section: section)

        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            
            if sectionIndex == 0 {
                return self.create1()
            }
                
            return self.create2()
        }
        
        
        
        return layout
    }
    
    private func create1() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(46)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
                
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerItemSize,
            elementKind: Constants.headerIdentifier,//Constants.headerIdentifier
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerItem]
        
//        let backgroundView = NSCollectionLayoutDecorationItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .estimated(section.accessibilityFrame.height - ))
//        )
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: Constants.decorationItemIdentifier)]
        
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
    }
    
    private func create2() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(46)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
//        let backgroundView = NSCollectionLayoutDecorationItem(
//            layoutSize: NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1),
//                heightDimension: .estimated(section.accessibilityFrame.height - ))
//        )
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: Constants.decorationItemIdentifier)]
        
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
    }
}
