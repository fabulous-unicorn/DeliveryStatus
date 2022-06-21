//
//  OrderDetailInfoViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailInfoViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainModel = FakeData.mainModel
    
    enum CellIdentifier {
        static let header = "orderDetailInfoHeader"
        
        static let titleGroup = "orderDetailsInfoTitleGroupCell"
        static let actor = "orderDetailsInfoOrderActorCell"
        static let service = "orderDetailsInfoServiceCell"
        static let parcel = "orderDetailsInfoParcelInfoCell"
    }
    
    struct ElementKind {
        static let background = "orderDetailInfoDecorationItem"
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<OrderDetailInfoViewModel.ContentGroup, AnyHashable>
    
    private var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        dataSource = makeDataSource()
        initialConfigureGroups(self.mainModel)
        
        collectionView.collectionViewLayout = self.createLayout()
        collectionView.collectionViewLayout.register(UINib(nibName: "OrderDetailInfoDecorationItem", bundle: nil), forDecorationViewOfKind: ElementKind.background)
        
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "OrderDetailInfoHeader", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.header)
        collectionView.register(UINib(nibName: "OrderDetailsInfoTitleGroupCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.titleGroup)
        collectionView.register(UINib(nibName: "OrderDetailsInfoOrderActorCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.actor)
        collectionView.register(UINib(nibName: "OrderDetailsInfoServiceCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.service)
        collectionView.register(UINib(nibName: "OrderDetailsInfoParcelInfoCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier.parcel)
    }
}

// MARK: - DataSource

extension OrderDetailInfoViewController {
    private func makeDataSource() -> DataSource? {
        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            if let header = item as? OrderDetailInfoViewModel.HeaderItem {
                let identifier = CellIdentifier.header
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailInfoHeader
                cell.configure(title: header.title, description: header.description)
                return cell
            }

            if let titleGroup = item as? String {
                let identifier = CellIdentifier.titleGroup
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoTitleGroupCell
                cell.configure(title: titleGroup)
                return cell
            }
            
            if let actor = item as? OrderDetailInfoViewModel.OrderActor {
                let identifier = CellIdentifier.actor
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoOrderActorCell
                cell.configure(with: actor)
                return cell
            }
            
            if let service = item as? OrderDetailInfoViewModel.AdditionalService {
                let identifier = CellIdentifier.service
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoServiceCell
                cell.configure(with: service)
                return cell
            }
            
            if let parcelInfo = item as? OrderDetailInfoViewModel.ParcelInfo {
                let identifier = CellIdentifier.parcel
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailsInfoParcelInfoCell
                cell.configure(with: parcelInfo)
                return cell
            }
            return nil
      }
        
        return dataSource
    }
        
    private func initialConfigureGroups(_ mainModel: OrderDetailInfoViewModel) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        
        snapshot.appendSections(mainModel.groups)
        
        mainModel.groups.forEach{ group in
            switch group {
            case let .header(item):
                snapshot.appendItems([item], toSection: group)
            case let .actor(_, items):
                snapshot.appendItems([group.title], toSection: group)
                snapshot.appendItems(items, toSection: group)
            case let .additionalServices(services):
                snapshot.appendItems([group.title], toSection: group)
                snapshot.appendItems(services, toSection: group)
            case let .parcelInfo(items):
                snapshot.appendItems([group.title], toSection: group)
                snapshot.appendItems(items, toSection: group)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension OrderDetailInfoViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard
            let selectedItem = dataSource?.itemIdentifier(for: indexPath)
            else { return }
        
        switch selectedItem {
        case let actorItem as OrderDetailInfoViewModel.OrderActor:
            showDidSelectAnimate(for: indexPath)
            didSelectActorItem(actorItem)
        case let parcelInfo as OrderDetailInfoViewModel.ParcelInfo:
            let cell = collectionView.cellForItem(at: indexPath) as? OrderDetailsInfoParcelInfoCell
            cell?.showIconAnimation()
            didSelectParcelInfoItem(parcelInfo)
        default:
            return
        }
    }
    
    private func showDidSelectAnimate(for indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .autoreverse,
            animations: { cell?.alpha = 0.5 },
            completion: { _ in cell?.alpha = 1 }
        )
    }
    
    private func didSelectActorItem(
        _ selectedItem: OrderDetailInfoViewModel.OrderActor
    ) {
        switch selectedItem.behavior {
        case .copy:
            print("| Log | copy: \(selectedItem.title)")
        case let .contact(modalTitle):
            // TODO: Alesya Volosach | должен быть так же вызов проверки доступности
            print("| Log | open contact model title: \(modalTitle), info: \(selectedItem.title)")
        }
    }
        
    private func didSelectParcelInfoItem(
        _ parcelInfo: OrderDetailInfoViewModel.ParcelInfo
     ) {
        switch parcelInfo.type {
        case .nested:
            if let additionalInfo = parcelInfo.additionalInfo {
                print("| Log | parcelIfo showModalInfo with text: \(additionalInfo)")
            }
        case let .default(nestedItems):
            if nestedItems.isEmpty {
                if let additionalInfo = parcelInfo.additionalInfo {
                    print("| Log | parcelIfo showModalInfo with text: \(additionalInfo)")
                }
                return
            }
            
            if dataSource?.snapshot().indexOfItem(nestedItems.first) == nil {
                showNeestedItems(parcelInfo, nestedItems)
            } else {
                hideNeestedItems(nestedItems)
            }
        }
    }
    
    private func showNeestedItems(
        _ item: OrderDetailInfoViewModel.ParcelInfo,
        _ nestedItems: [OrderDetailInfoViewModel.ParcelInfo]
     ) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
         snapshot.insertItems(nestedItems, afterItem: item)
         dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func hideNeestedItems(
      _ nestedItems: [OrderDetailInfoViewModel.ParcelInfo]
    ) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
         snapshot.deleteItems(nestedItems)
         dataSource.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - UICollectionViewLayout

extension OrderDetailInfoViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            if sectionIndex == 0 {
                return self.createHeaderLayout()
            }
            return self.createBasicLayout()
        }
        return layout
    }
    
    private func createHeaderLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(62)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(62)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        return section
    }
    
    private func createBasicLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
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
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: ElementKind.background)
        backgroundItem.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [backgroundItem]
        section.contentInsets = .init(top: 24, leading: 16, bottom: 24, trailing: 16)
        
        return section
    }
}


