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
        registerCells()
        
        collectionView.dataSource = dataSource
        dataSource = makeDataSource()
        initialConfigureGroups(self.mainModel)
        
        collectionView.collectionViewLayout = self.createLayout()
        collectionView.collectionViewLayout.register(UINib(nibName: "OrderDetailInfoDecorationItem", bundle: nil), forDecorationViewOfKind: Constants.decorationItemIdentifier)
    }
    
    func registerCells() {
        collectionView.register(UINib(nibName: "OrderDetailInfoHeader", bundle: nil), forCellWithReuseIdentifier: Constants.headerIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoTitleGroupCell", bundle: nil), forCellWithReuseIdentifier: Constants.titleGroupCellIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoOrderActorCell", bundle: nil), forCellWithReuseIdentifier: Constants.actorCellIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoServiceCell", bundle: nil), forCellWithReuseIdentifier: Constants.serviceCellIdentifier)
        collectionView.register(UINib(nibName: "OrderDetailsInfoParcelInfoCell", bundle: nil), forCellWithReuseIdentifier: Constants.parcelInfoСellIdentifier)
    }
}

// MARK: - Table view data source

extension OrderDetailInfoViewController {
    private func makeDataSource() -> DataSource? {
        let dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            if let header = item as? OrderDetailsInfoViewModel.HeaderItem {
                let identifier = Constants.headerIdentifier
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderDetailInfoHeader
                cell.configure(title: header.title, description: header.description)
                return cell
            }

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
        
        return dataSource
    }
        
    func initialConfigureGroups(_ mainModel: OrderDetailsInfoViewModel) {
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

// MARK: - UICollectionViewLayout

extension OrderDetailInfoViewController {
    func createLayout() -> UICollectionViewLayout {
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
            heightDimension: .fractionalHeight(1.0)
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
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: Constants.decorationItemIdentifier)]
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
}


