//
//  StatusWidgetViewModelBuilder.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 09.06.2022.
//

import Foundation
// TODO: Alesya Volosach | Наверное будет лучше закрыть протоколом, потому что хочется написать адекватные тесты
class StatusWidgetViewModelBuilder {
    // TODO: Alesya Volosach | упаковать входные параметры и инициализаторы в тюплы
    // TODO: Alesya Volosach | какова будет выгода если делать именно билдер?
    
    static func buildStatuses(_ order: Order) -> [DeliveryStatusViewModel] {
        let groups: [DeliveryStatusViewModel] = order.orderStatusGroups.enumerated().compactMap { index, group in
            return buildStatus(order, group, at: index)
        }
        return groups
    }
    
    static private func buildStatus(
        _ order: Order,
        _ groupDTO: OrderStatusGroupDto,
        at index: Int
    ) -> DeliveryStatusViewModel {
        let group = group(groupDTO.code)
        let message = groupDTO.message
        let evolutionStage = configureEvolutionStage(groupDTO.evolutionStage)
        let isLastStatus = index == order.orderStatusGroups.count - 1
        
        let steps = buildSteps(groupDTO, group, evolutionStage)
        
        // Card
        let card = buildCard(order, groupDTO, group)
        
        // Title
        // TODO: Alesya Volosach | тут для теста карточки можно будет комментить
        var isExpandingAvailable = false
        if group == .created && evolutionStage == .past {
            isExpandingAvailable = false
        } else {
            isExpandingAvailable = !steps.isEmpty || card != nil
        }
        let title = buildTitle(groupDTO, group, evolutionStage, isExpandingAvailable: isExpandingAvailable)
        
        return DeliveryStatusViewModel(
            group: group,
            message: message,
            evolutionStage: evolutionStage,
            isLastStatus: isLastStatus,
            title: title,
            steps: steps,
            card: card)
    }
    
    // MARK: - Common
    
    static private func group(
        _ code: OrderStatusGroupDto.Code
    ) -> DeliveryStatusViewModel.Group {
        switch code {
        case .initial: return .created
        case .inProgress: return .inProgress
        case .courierInProgress: return .courier
        case .readyForPickUp: return .readyForPick
        case .recived: return .recived
        case .partiallyRecived: return .partiallyRecived
        case .notRecived: return .notRecived
        case .unowned: return .unknown
        }
    }
    
    static private func configureEvolutionStage(
        _ evolutionStage: OrderStatusGroupDto.EvolutionStage
    ) -> DeliveryStatusViewModel.Stage {
        switch evolutionStage {
        case .past: return .past
        case .present: return .present
        case .future: return .future
        }
    }
    
    // MARK: - Build Title
    
    static private func buildTitle(
        _ groupDTO: OrderStatusGroupDto,
        _ group: DeliveryStatusViewModel.Group,
        _ evolutionStage: DeliveryStatusViewModel.Stage,
        isExpandingAvailable: Bool
    ) -> DeliveryStatusViewModel.Title {
        let title = groupDTO.name
        // TODO: Alesya Volosach | здесь добавится преобразование даты
        let date = groupDTO.occurrence
        
        return DeliveryStatusViewModel.Title(
            title: title,
            date: date,
            isExpandingAvailable: isExpandingAvailable,
            evolutionStage: evolutionStage,
            group: group
        )
    }
    
    // MARK: - Build Steps
    
    static private func buildSteps(
        _ groupDTO: OrderStatusGroupDto,
        _ group: DeliveryStatusViewModel.Group,
        _ evolutionStage: DeliveryStatusViewModel.Stage
    ) -> [DeliveryStatusViewModel.Step] {
        let steps = groupDTO.roadMap.flatMap{ (step) -> [DeliveryStatusViewModel.Step]  in
            let nestedSteps = step.statuses.map { nestedStep in
                return DeliveryStatusViewModel.Step(
                    title: nestedStep.title,
                    type: .point(date: nestedStep.date, isPrimary: step.city != nil),
                    evolutionStage: evolutionStage,
                    group: group
                )
            }
            
            if let city = step.city {
                let subhead = DeliveryStatusViewModel.Step(
                    title: city,
                    type: .subhead,
                    evolutionStage: evolutionStage,
                    group: group
                )

                var result = [subhead]
                result.append(contentsOf: nestedSteps)
                
                return result
            } else {
                return nestedSteps
            }
   
        }
        return steps
    }
    
    // MARK: - Build Card
    
    static private func buildCard(
        _ order: Order,
        _ groupDTO: OrderStatusGroupDto,
        _ group: DeliveryStatusViewModel.Group
    ) -> DeliveryStatusViewModel.Card? {
        switch group {
        case .created: return cardForCreatedGroup(order, group, groupDTO)
        case .recived: return cardForFinalGroup(order, group, groupDTO)
        default: return nil
        }
    }
    
    static private func cardForCreatedGroup(
        _ order: Order,
        _ group: DeliveryStatusViewModel.Group,
        _ groupDTO: OrderStatusGroupDto
    ) -> DeliveryStatusViewModel.Card {
        let deliveryType = deliveryTypeForCard(order.senderDeliveryType)
        let address = senderAddress(order, for: order.senderDeliveryType)
        let officeId = order.senderOffice?.id
        let pickUpInfo = pickUpInfo(order)
        let displayChangeButton = false // Для этого релиза свойство не предполагается
        
        return DeliveryStatusViewModel.Card(
            group: group,
            // TODO: Alesya Volosach | переименновать поле в type или что-то типо того
            deliveryType: deliveryType,
            address: address,
            officeId: officeId,
            pickUpInfo: pickUpInfo,
            displayChangeButton: displayChangeButton,
            planedDeliveryInfo: nil,
            // Общего message для всех карточек на данный момент нет
            message: nil,
            keepDateInfo: nil,
            keepInfoLink: nil
        )
    }
    
    static private func cardForFinalGroup(
        _ order: Order,
        _ group: DeliveryStatusViewModel.Group,
        _ groupDTO: OrderStatusGroupDto
    ) -> DeliveryStatusViewModel.Card {
        
        let deliveryType = deliveryTypeForCard(order.receiverDeliveryType)
        let address = reciverAddress(order, for: order.senderDeliveryType)
        let officeId = order.office?.id
        let displayChangeButton = order.canBeChanged ?? false
        let planedDeliveryInfo = planedDeliveryInfo(order)
        
        let message = order.plannedDeliveryNotAvailableNote
        let keepDateInfo = keepDateInfo(order)
        
        return DeliveryStatusViewModel.Card(
            group: group,
            deliveryType: deliveryType,
            address: address,
            officeId: officeId,
            // Еще нет признака
            pickUpInfo: nil,
            displayChangeButton: displayChangeButton,
            planedDeliveryInfo: planedDeliveryInfo,
            message: message,
            keepDateInfo: keepDateInfo,
            keepInfoLink: order.warehousingInfoUrl
        )
    }
    
    static private func deliveryTypeForCard(
        _ type: DeliveryType?
    ) -> DeliveryStatusViewModel.Card.DeliveryType {
        guard let type = type else {
            return .unknown
        }
        switch type {
        case .home:
            return .home
        case .pvz:
            return .pvz
        case .postomate:
            return .postomate
        }
    }
    
    /// Только для отправителя
    static private func pickUpInfo(_ order: Order) -> String? {
        guard let pickUp = order.pickUp else { return nil }
        let time = "\(pickUp.arrivalDate) c \(pickUp.arrivalTimeFrom) по \(pickUp.arrivalTimeTo)"
        return """
               Дата и время забора:
               \(time)
               """
    }
    
    static private func senderAddress(_ order: Order, for senderMode: DeliveryType?) -> String {
        let result = order.departureCity.name
        
        if senderMode == .home {
            if let address = order.sender?.address, !address.isEmpty {
                return result + "," + address
            }
            return result
        }
        
        if let address = order.senderOffice?.address, !address.isEmpty {
            return result + "," + address
        }
        
        return result
    }
    
    static private func reciverAddress(_ order: Order, for reciverMode: DeliveryType?) -> String {
        let result = order.destinationCity.name
        
        if reciverMode == .home {
            if let address = order.receiver?.address, !address.isEmpty {
                return result + "," + address
            }
            return result
        }
        
        if let address = order.office?.address, !address.isEmpty {
            return result + "," + address
        }
        
        return result
    }
    
    static private func planedDeliveryInfo(_ order: Order) -> String? {
        // TODO: Alesya Volosach | Скорей всего добавяться преобразования для даты
        guard let dateEnd = order.plannedDeliveryDate else { return nil }
        
        let title = order.plannedDeliveryDateNote ?? "Поступление до:"
        return """
                \(title)
                \(dateEnd)
                """
    }
    
    static private func keepDateInfo(_ order: Order) -> String? {
        // TODO: Alesya Volosach | Скорей всего добавяться преобразования для даты
        guard let keepDate = order.storageDateEnd else { return nil }
        return """
                Срок хранения до:
                \(keepDate)
                """
    }
}

    

    
    

