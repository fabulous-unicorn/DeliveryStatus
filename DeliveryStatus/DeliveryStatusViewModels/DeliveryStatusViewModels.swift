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
    
    ///  Доступно ли расскрытие группы
    ///  ?Под вопросом - возможно будет удалено
    ///  и вычисление будет происходит с наличием контента
    ///  или станет вычисляемым
//    var isExpandingAvailable: Bool
    
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
    var stepForShortView: Step {
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
        evolutionStage: Stage,
        isLastStatus: Bool,
        title: Title,
        steps: [Step]
    ) {
        self.title = title
        self.group = group
        self.isLastStatus = isLastStatus
        self.evolutionStage = evolutionStage
        self.steps = steps
        
       
    }
    
    // TODO: Alesya Volosach | может быть добавить какие-то специфичные конфигураторы
    
    
    
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
        case delivered
        /// Не вручен
        case notDelivered
        
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
            case .delivered:
                return UIImage(named: "orderDetail.status.delivered")!
            case .notDelivered:
                return UIImage(named: "orderDetail.status.notDelivered")!
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
            case .delivered:
                return UIColor.hexStringToUIColor(hex: "1AB248")
            case .notDelivered:
                return UIColor.hexStringToUIColor(hex: "FF6261")
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
            case .delivered:
                return UIColor.hexStringToUIColor(hex: "DDF3E4")
            case .notDelivered:
                return UIColor.hexStringToUIColor(hex: "FEE3E3")
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
        var isAvailableExpanded: Bool
        
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
        
    }
}
