//
//  ViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 31.05.2022.
//

import Foundation
import UIKit

struct DeliveryStatusViewModel {
    /// Заголовок группы ViewModel
    var title: Title
    
    /// Дополнительный комментарий под заголовком
    ///
    /// Пример
    /// ```
    /// Отправитель еще не передал посылку
    /// для доставки в СДЭК.
    /// ```
    ///
    /// Бэк: order.statusGroup[].message
    var message: String?
    
    ///  Доступно ли расскрытие группы - Здесь свойство будеи не нужно, его конфигурация будет перенесена в конфигурацию title
//    var isExpandingAvailable: Bool {
//        if self.group == .created && self.evolutionStage == .past {
//            return false
//        }
//
//        return !self.steps.isEmpty || self.card != nil
//    }
    
    /// Стадия группы относительно заказа
    ///
    /// Бэк: order.statusGroup[].evolutionStage
    var evolutionStage: Stage
    
    /// Тип группы и ее свойства
    ///
    /// Бэк: order.statusGroup[].code +  order.status
    var group: Group
    
    /// Для отрисовки полоски прогресса
    var isLastStatus: Bool
    
    /// Промежуточные статусы внутри группы ViewModel
    ///
    /// Бэк:  order.statusGroup[].roadMap
    var steps: [Step]
    
    /// Каточка появляющаяся в первой и последней группе
    var card: Card?
        
    /// Конфигурация вида шага, для свернутой группы
    /// Возможны изменения из-за карточки
    var stepForShortView: Step? {
        switch group {
        case .created, .recived, .notRecived:
            return getStepForShortViewCard()
        default:
            return getStepForShortViewTable()
        }
    }
    
    private func getStepForShortViewCard() -> Step? {
        guard let address = card?.address else { return nil }
        
        return Step(
            title: address,
            type: .simple,
            evolutionStage: self.evolutionStage,
            group: self.group
        )
    }
    
    private func getStepForShortViewTable() -> Step? {
        guard !self.steps.isEmpty else { return nil }
        
        // Title
        var title = ""
        if let lastStepSubhead = self.steps.last(
            where: { step in
                if case .subhead = step.type {
                    return true
                }
                return false
            }
        ) {
            title = lastStepSubhead.title
        }
        
        // Status
        var date = ""
        if
            let lastStep = self.steps.last,
            case let .point(lastDate, _) = lastStep.type
        {
            date = lastDate
            if
                lastStep.title != title,
                !title.isEmpty
            {
                title = "\(title) / \(lastStep.title)"
            } else {
                title = lastStep.title
            }
        }
        
        return Step(
            title: title,
            type: .point(
                date: date,
                isPrimary: true
            ),
            evolutionStage: self.evolutionStage,
            group: self.group
        )
    }
    
    // TODO: Alesya Volosach | прост временное упрощение
    init(
        group: Group,
        message: String? = nil,
        evolutionStage: Stage,
        isLastStatus: Bool,
        title: Title,
        steps: [Step],
        card: Card? = nil
    ) {
        self.message = message
        self.title = title
        self.group = group
        self.isLastStatus = isLastStatus
        self.evolutionStage = evolutionStage
        self.steps = steps
        self.card = card
    }
    
    // TODO: Alesya Volosach | прост временное упрощение
    struct StepExample {
        var title: String
        var type: StepType
    }

    struct CardExample {
        var mode: DeliveryType
        var address: String
        var officeId: Int?
        var pickUpInfo: String?
        var displayChangeButton: Bool
        var planedDeliveryInfo: String?
        var message: String?
        var keepDateInfo: String?
        var keepInfoLink: URL?
        
        func getCard(group: Group) -> Card {
            return Card(
                group: group,
                mode: self.mode,
                address: self.address,
                officeId: self.officeId,
                pickUpInfo: self.pickUpInfo,
                displayChangeButton: self.displayChangeButton,
                planedDeliveryInfo: self.planedDeliveryInfo,
                message: self.message,
                keepDateInfo: self.keepDateInfo,
                keepInfoLink: self.keepInfoLink
            )
        }
    }
    
    init(
        group: Group,
        message: String? = nil,
        evolutionStage: Stage,
        isLastStatus: Bool,
        title: String,
        date: String?,
        steps: [StepExample],
        card: CardExample? = nil
    ) {
        self.message = message
        self.group = group
        self.isLastStatus = isLastStatus
        self.evolutionStage = evolutionStage
        
        // Check available expanded
        var isAvailableExpanded = false
//        if group == .created && evolutionStage == .past {
//            isAvailableExpanded = false
//        } else {
            isAvailableExpanded = !steps.isEmpty || card != nil
//        }
        
        // Date
        var dateForTitle: String? = nil
        switch group {
        case .created, .recived, .notRecived, .partiallyRecived:
            dateForTitle = nil
        default:
            dateForTitle = date
        }
        
        // Title
        self.title = Title(
            title: title,
            date: dateForTitle,
            isExpandingAvailable: isAvailableExpanded,
            evolutionStage: evolutionStage,
            group: group
        )
        
        // Card
        self.card = card?.getCard(group: group)
        
        // Steps
        self.steps = steps.map { step in
            return Step(
                title: step.title,
                type: step.type,
                evolutionStage: evolutionStage,
                group: group
            )
        }
    }
    
    
    // MARK: - DeliveryStatusViewModel.Stage
    
    /// Стадия группы относительно заказа
    enum Stage {
        /// Заказ уже прошел этот этап
        case past
        /// Этот этап текущий для заказа
        case present
        /// Заказ еще не дошел до этого этапа
        case future
    }
    
    // MARK: - DeliveryStatusViewModel.Group
    
    /// Тип группы со вспомогательными свойствами
    enum Group: String {
        /// Заказ создан
        case created
        /// В пути
        case inProgress
        /// Передан курьеру (выдача с курьерской доставкой)
        case courier
        /// Готов к выдаче (выдача в пвз/постамат)
        case readyForPick
        /// Вручен
        case recived
        /// Не вручен
        case notRecived
        /// Частично вручен
        case partiallyRecived
        /// Для обратной совместимости
        case unknown
        
        /// Иконка для отображения в заголовке
        var icon: UIImage {
            switch self {
            case .created:
                return UIImage(named: "orderDetail.status.created")!
            case .inProgress:
                return UIImage(named: "orderDetail.status.InProgress")!
            case .courier:
                return UIImage(named: "orderDetail.status.courierInProgress")!
            case .readyForPick:
                return UIImage(named: "orderDetail.status.courierInProgress")!
            case .recived:
                return UIImage(named: "orderDetail.status.delivered")!
            case .notRecived:
                return UIImage(named: "orderDetail.status.notDelivered")!
            case .partiallyRecived:
                return UIImage(named: "orderDetail.status.delivered")!
            case .unknown:
                return UIImage(named: "orderDetail.status.unknown")!
            }
        }
        
        /// Акцентный цвет для группы
        var tintColor: UIColor {
            switch self {
            case .created:
                return UIColor.hexStringToUIColor(hex: "E9C400")
            case .inProgress:
                return UIColor.hexStringToUIColor(hex: "F08A12")
            case .courier:
                return UIColor.hexStringToUIColor(hex: "008C6B")
            case .readyForPick:
                return UIColor.hexStringToUIColor(hex: "008C6B")
            case .recived:
                return UIColor.hexStringToUIColor(hex: "1AB248")
            case .notRecived:
                return UIColor.hexStringToUIColor(hex: "FF6261")
            case .partiallyRecived:
                return UIColor.hexStringToUIColor(hex: "1AB248")
            case .unknown:
                return UIColor.hexStringToUIColor(hex: "F08A12")
            }
        }
        
        /// Фоновый цвет для иконки
        var backgroundColor: UIColor {
            switch self {
            case .created:
                return UIColor.hexStringToUIColor(hex: "FCF6D9")
            case .inProgress:
                return UIColor.hexStringToUIColor(hex: "FDEDDB")
            case .courier:
                return UIColor.hexStringToUIColor(hex: "DBEBE0")
            case .readyForPick:
                return UIColor.hexStringToUIColor(hex: "DBEBE0")
            case .recived:
                return UIColor.hexStringToUIColor(hex: "DDF3E4")
            case .notRecived:
                return UIColor.hexStringToUIColor(hex: "FEE3E3")
            case .partiallyRecived:
                return UIColor.hexStringToUIColor(hex: "DDF3E4")
            case .unknown:
                return UIColor.hexStringToUIColor(hex: "FDEDDB")
            }
        }
        
        /// Не активный цвет для группы
        var inactiveTintColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "BBBBBB")
        }
        
        /// Цвет полоски без прогресса
        var defaultLineColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "DFDFDF")
        }
        
        /// Не активный фоновый цвет для иконки
        var inactiveBackgroundColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "F4F4F4")
        }
    }
    
    // MARK: - DeliveryStatusViewModel.Title
    /// ViewModel для заголовка группы
    struct Title {
        var title: String
        var date: String?
        var isExpandingAvailable: Bool
        
        var evolutionStage: DeliveryStatusViewModel.Stage
        var group: DeliveryStatusViewModel.Group
    }

    // MARK: - DeliveryStatusViewModel.Step
    /// ViewModel для шагов(строк) в группе
    ///
    /// Бэк - order.statusGroup[].roadMap[] - основная информация отсюда
    struct Step {
        var title: String
        var type: StepType
        
        var evolutionStage: DeliveryStatusViewModel.Stage
        var group: DeliveryStatusViewModel.Group
    }
    
    // MARK: - DeliveryStatusViewModel.StepType
    
    /// Тип шага для отображения
    enum StepType {
        case simple
        case subhead
        case point(
            date: String,
            isPrimary: Bool
        )
    }
    
    /// ViewModel для карточек в первой и последней группе
    ///
    /// Формируется из всей модели заказа
    struct Card {
        var group: Group
        // TODO: Под вопросом
        private var mode: DeliveryType
        var address: String
        var officeId: Int?
        var pickUpInfo: String?
        var displayChangeButton: Bool
        var planedDeliveryInfo: String?
        var message: String?
        var keepDateInfo: String?
        var keepInfoLink: URL?
        
        var title: String {
            switch mode {
                // TODO: Alesya Volosach | локализованные ресурсы
            case .postomate: return "Постамат"
            case .pvz: return "Пункт СДЭК"
            case .home:
                switch group {
                case .created: return "Курьер"
                case .recived, .notRecived: return "Курьер привезёт"
                default: return "Информация о доставке"
                }
            }
        }
        
        var icon: UIImage {
            switch mode {
            case .postomate:
                return UIImage(named: "orderDetail.roadpoint.postomate")!
            case .pvz:
                return UIImage(named: "orderDetail.roadpoint.deliveryPoint")!
            case .home:
                return UIImage(named: "orderDetail.roadpoint.courier")!
            }
        }
        
        internal init(
            group: DeliveryStatusViewModel.Group,
            mode: DeliveryType,
            address: String,
            officeId: Int? = nil,
            pickUpInfo: String? = nil,
            displayChangeButton: Bool,
            planedDeliveryInfo: String? = nil,
            message: String? = nil,
            keepDateInfo: String? = nil,
            keepInfoLink: URL? = nil
        ) {
            self.group = group
            self.mode = mode
            self.address = address
            self.officeId = officeId
            self.pickUpInfo = pickUpInfo
            self.displayChangeButton = displayChangeButton
            self.planedDeliveryInfo = planedDeliveryInfo
            self.message = message
            self.keepDateInfo = keepDateInfo
            self.keepInfoLink = keepInfoLink
        }
    }
}
