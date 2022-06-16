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
    var groups: [ContentGroup]
    
    // MARK: - ContentGroup
    
    enum ContentGroup {
        case actor(role: OrderActorRole, items: [OrderActor])
        case additionalServices(services: [AdditionalService])
        case parcelInfo(items: [ParcelInfo])
        
        var title: String {
            switch self {
            case let .actor(role, _):
                switch role {
                case .sender: return "Откуда"
                case .receiver: return "Куда"
                }
            case .additionalServices(_):
                return "Дополнительные услуги"
            case .parcelInfo(_):
                return "Данные"
            }
        }
    }
    
    // MARK: - OrderActor
    
    struct OrderActor {
        var title: String
        var icon: UIImage
        var behavior: ItemBehavior
    }
    
    enum OrderActorRole {
        case sender, receiver
        
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
        var title: String
        var description: [String]
    }
    
    // MARK: - ParcelInfo
    
    struct ParcelInfo {
        var title: String
        var description: String
        var additionalInfo: String?
        var type: ParcelInfoType
    }
    
    enum ParcelInfoType: Equatable {
        case `default`(nestedItems: [ParcelInfo])
        case nested
        
        /// Сравнение только на тип, не более
        static func == (lhs: OrderDetailsInfoViewModel.ParcelInfoType, rhs: OrderDetailsInfoViewModel.ParcelInfoType) -> Bool {
            switch (lhs, rhs) {
            case (.nested, .nested): return true
            case let (.`default`(nestedItemsLhs), .`default`(nestedItemsRhs)):
                return true
            default: return false
            }
        }
    }
}
