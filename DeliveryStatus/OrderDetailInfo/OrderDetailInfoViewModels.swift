//
//  InfoDepartureViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import Foundation
import UIKit

struct OrderDetailsInfoViewModel {
    var groups: [ContentGroup]
    
    // MARK: - ContentGroup
    
    enum ContentGroup {
        case header(item: HeaderItem)
        case actor(role: OrderActorRole, items: [OrderActor])
        case additionalServices(services: [AdditionalService])
        case parcelInfo(items: [ParcelInfo])
        
        var title: String {
            switch self {
            case .header: return ""
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
    
    // MARK: - HeaderItem
    
    struct HeaderItem {
        var title: String
        var description: String
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
    
    enum ParcelInfoType {
        case `default`(nestedItems: [ParcelInfo])
        case nested
    }
}

// MARK: - Equatable & Hashable
extension OrderDetailsInfoViewModel.HeaderItem: Hashable {}

extension OrderDetailsInfoViewModel.OrderActorRole: Equatable {}

extension OrderDetailsInfoViewModel.OrderActor: Hashable {}

extension OrderDetailsInfoViewModel.AdditionalService: Hashable {}

extension OrderDetailsInfoViewModel.ParcelInfo: Hashable {}

extension OrderDetailsInfoViewModel.ParcelInfoType: Hashable {
    /// Сравнение только на тип, не более
    static func == (lhs: OrderDetailsInfoViewModel.ParcelInfoType, rhs: OrderDetailsInfoViewModel.ParcelInfoType) -> Bool {
        switch (lhs, rhs) {
        case (.nested, .nested): return true
        case (.`default`(_), .`default`(_)):
            return true
        default: return false
        }
    }
}

extension OrderDetailsInfoViewModel.ContentGroup: Hashable {
    // TODO: Alesya Volosach | проверить
    func hash(into hasher: inout Hasher) {
        switch self {
        case .header:
            hasher.combine("header")
        case let .actor(role, _):
            hasher.combine("actor\(role.hashValue)")
        case .additionalServices:
            hasher.combine("additionalServices")
        case .parcelInfo:
            hasher.combine("parcelInfo")
        }
    }
    
    /// Проверка только на тип
    static func == (
        lhs: OrderDetailsInfoViewModel.ContentGroup,
        rhs: OrderDetailsInfoViewModel.ContentGroup
    ) -> Bool {
        switch (lhs, rhs) {
        case (.header, .header):
            return true
        case let (.actor(roleLhs, _), .actor(roleRhs, _)):
            return roleLhs == roleRhs
        case (.additionalServices, .additionalServices):
            return true
        case (.parcelInfo, .parcelInfo):
            return true
        default:
            return false
        }
    }
}
