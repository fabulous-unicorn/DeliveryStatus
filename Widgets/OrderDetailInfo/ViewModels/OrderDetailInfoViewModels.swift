//
//  InfoDepartureViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import Foundation
import UIKit

// TODO: Alesya Volosach | Можно наверное избавиться от этой обертки
struct OrderDetailInfoViewModel {
    var groups: [ContentGroup]
    
    // MARK: - ContentGroup
    
    /// Секции детальной информации о посылке
    enum ContentGroup {
        /// Header всей таблицы
        case header(item: HeaderItem)
        /// Группа Откуда/Куда
        case actor(role: OrderActorRole, items: [OrderActor])
        /// Группа Дополнительные услуги
        case additionalServices(services: [AdditionalService])
        /// Группа Данные
        case parcelInfo(items: [ParcelInfo])
        
        /// Title для группы
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
    
    /// Модель Header всей таблицы
    struct HeaderItem {
        var title: String
        var description: String
    }
    
    // MARK: - OrderActor
    
    /// Модель Откуда/Куда
    struct OrderActor {
        var title: String
        var icon: UIImage
        var behavior: ItemBehavior
    }
    
    /// Роль для блока Откуда/Куда
    enum OrderActorRole {
        case sender, receiver
    }
    
    /// Поведение по нажатию на элемент
    enum ItemBehavior {
        case copy
        case contact(modalTitle: String)
    }
    
    // MARK: - AdditionalService
    
    /// Модель Дополнительные сервисы
    struct AdditionalService {
        var title: String
        var description: [String]
    }
    
    // MARK: - ParcelInfo
    
    /// Модель Данные
    struct ParcelInfo {
        var title: String
        var description: String
        var additionalInfo: String?
        var type: ParcelInfoType
    }
    
    /// Наличие/отсутствие вложенных элементов для раскрытия
    enum ParcelInfoType {
        case `default`(nestedItems: [ParcelInfo])
        case nested
    }
}

// MARK: - Equatable & Hashable
extension OrderDetailInfoViewModel.HeaderItem: Hashable {}

extension OrderDetailInfoViewModel.OrderActorRole: Equatable {}

extension OrderDetailInfoViewModel.OrderActor: Hashable {}

extension OrderDetailInfoViewModel.ItemBehavior: Hashable {
    static func == (lhs: OrderDetailInfoViewModel.ItemBehavior, rhs: OrderDetailInfoViewModel.ItemBehavior) -> Bool {
        switch (lhs, rhs) {
        case (.copy, .copy): return true
        case let (.contact(titleLhs), .contact(titleRhs)):
            return titleLhs == titleRhs
        default: return false
        }
    }
}

extension OrderDetailInfoViewModel.AdditionalService: Hashable {}

extension OrderDetailInfoViewModel.ParcelInfo: Hashable {}

extension OrderDetailInfoViewModel.ParcelInfoType: Hashable {
    /// Сравнение только на тип, не более
    static func == (lhs: OrderDetailInfoViewModel.ParcelInfoType, rhs: OrderDetailInfoViewModel.ParcelInfoType) -> Bool {
        switch (lhs, rhs) {
        case (.nested, .nested): return true
        case (.`default`(_), .`default`(_)):
            return true
        default: return false
        }
    }
}

extension OrderDetailInfoViewModel.ContentGroup: Hashable {
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
        lhs: OrderDetailInfoViewModel.ContentGroup,
        rhs: OrderDetailInfoViewModel.ContentGroup
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
