//
//  InfoDepartureViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import Foundation
import UIKit

struct OrderDetailsInfoViewModel {
    var title: String
    var description: String
    var sender: OrderActor
    var receiver: OrderActor
    var additionalServices: AdditionalService
    var parcelInfo: ParcelInfo
    
    // MARK: - OrderActor
    
    struct OrderActor {
        var role: ActorRole
        var items: Item
                
        struct Item {
            var title: String
            var icon: UIImage
            var behavior: ItemBehavior
        }
    }
    
    enum ActorRole {
        case sender, receiver
        
        var title: String {
            switch self {
            case .sender: return "Откуда"
            case .receiver: return "Куда"
            }
        }
        
        var modalTitle: String {
            switch self {
            case .sender: return "Связаться с отправителем"
            case .receiver: return "Связаться с получателем"
            }
        }
    }
    
    enum ItemBehavior {
        case copy, contact
    }
    
    // MARK: - AdditionalService
    
    struct AdditionalService {
        var services: [Service]
        
        struct Service {
            var title: String
            var description: [String]
        }
    }
    
    // MARK: - ParcelInfo
    
    struct ParcelInfo {
        var items: [Item]
        
        struct Item {
            var title: String
            var description: String
            var additionalInfo: String?
            var type: ItemType
        }
        
        enum ItemType {
            case `default`(nestedItems: [Item])
            case nested
        }
    }
}
