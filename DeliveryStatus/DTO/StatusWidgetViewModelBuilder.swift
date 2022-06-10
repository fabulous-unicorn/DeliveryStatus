//
//  StatusWidgetViewModelBuilder.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 09.06.2022.
//

import Foundation

class StatusWidgetViewModelBuilder {
    // TODO: Alesya Volosach | упаковать входные параметры и инициализаторы в тюплы
    
    var order: Order
    var status: [DeliveryStatusViewModel] = []
    
    init(_ order: Order) {
        self.order = order
    }
    
    func buildStatuses(_ order: Order) -> [DeliveryStatusViewModel] {
        let groups: [DeliveryStatusViewModel] = order.orderStatusGroups.enumerated().compactMap { index, group in
            return configureStatus(group, at: index)
        }
        return groups
    }
    
    func configureStatus(_ groupDTO: OrderStatusGroupDto, at index: Int) -> DeliveryStatusViewModel {
        let group = configureGroup(groupDTO.code)
        let message = groupDTO.message
        let evolutionStage = configureEvolutionStage(groupDTO.evolutionStage)
        let isLastStatus = index == order.orderStatusGroups.count - 1
        
        let steps = stepsViewModels(groupDTO, group, evolutionStage)
        
        // Card
        let card = configureCard(groupDTO, group)
        
        // Title
        // TODO: Alesya Volosach | тут для теста карточки можно будет комментить
        var isExpandingAvailable = false
        if group == .created && evolutionStage == .past {
            isExpandingAvailable = false
        } else {
            isExpandingAvailable = !steps.isEmpty || card != nil
        }
        let title = titleViewModel(groupDTO, group, evolutionStage, isExpandingAvailable: isExpandingAvailable)
        
        return DeliveryStatusViewModel(
            group: group,
            message: message,
            evolutionStage: evolutionStage,
            isLastStatus: isLastStatus,
            title: title,
            steps: steps,
            card: card)
    }
                    
    func configureCard(
        _ groupDTO: OrderStatusGroupDto,
        _ group: DeliveryStatusViewModel.Group
    ) -> DeliveryStatusViewModel.Card? {
        // TODO: Alesya Volosach | дописать
        
        switch group {
        case .created: return cardForCreatedGroup(groupDTO)
            // TODO: Alesya Volosach | Проверить добавлять ли другие группы?
//        case .recived: return cardForFinalGroup(groupDTO)
        default: return nil
        }
    }
    
//    func cardForFinalGroup(
//        _ groupDTO: OrderStatusGroupDto,
//    ) -> DeliveryStatusViewModel.Card {
//
//        return DeliveryStatusViewModel.Card(
//            group: <#T##DeliveryStatusViewModel.Group#>,
//            mode: <#T##DeliveryStatusViewModel.Card.DeliveryType#>,
//            address: <#T##String#>,
//            officeId: <#T##Int?#>,
//            pickUpInfo: <#T##String?#>,
//            displayChangeButton: <#T##Bool#>,
//            planedDeliveryInfo: <#T##String?#>,
//            message: <#T##String?#>,
//            keepDateInfo: <#T##String?#>,
//            keepInfoLink: <#T##URL?#>
//        )
//    }
    
    func cardForCreatedGroup(
        _ groupDTO: OrderStatusGroupDto,
    ) -> DeliveryStatusViewModel.Card {
        let mode = deliveryTypeForCard(order.senderDeliveryType)
        let address = createdAddress(for: order.senderDeliveryType)
        let officeId = order.senderOffice?.id
        let pickUpInfo = pickUpInfo()
        let displayChangeButton = false // Для этого релиза свойство не предполагается
        
        return DeliveryStatusViewModel.Card((
            group: group,
            // TODO: Alesya Volosach | переименновать поле в type или что-то типо того
            mode: mode,
            address: address,
            officeId: officeId,
            pickUpInfo: pickUpInfo,
            displayChangeButton: displayChangeButton,
            planedDeliveryInfo: nil,
            // TODO: Alesya Volosach | не преполагается но на всякий проверить
            message: nil,
            keepDateInfo: nil,
            keepInfoLink: nil
        ))
    }
    
    /// Только для отправителя
    func pickUpInfo() -> String? {
        guard let pickUp = order.pickUp else { return nil }
        let time = "\(pickUp.arrivalDate) c \(pickUp.arrivalTimeFrom) по \(pickUp.arrivalTimeTo)"
        return """
               Дата и время забора:
               \(time)
               """
    }
    
    func createdAddress(for deliveryType: DeliveryType?) -> String {
        let result = order.departureCity.name
        
        if deliveryType == .home {
            if let address = order.sender?.address, !address.isEmpty {
                return result + "," + address
            }
            return result
        }
        
        if let address = order.office?.address, !address.isEmpty {
            return result + "," + address
        }
        
        return result
    }
    
    func configureGroup(
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
    
    func configureEvolutionStage(
        _ evolutionStage: OrderStatusGroupDto.EvolutionStage
    ) -> DeliveryStatusViewModel.Stage {
        switch evolutionStage {
        case .past: return .past
        case .present: return .present
        case .future: return .future
        }
    }
    
    func titleViewModel(
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
    
    func stepsViewModels(
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
    
    func deliveryTypeForCard(
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
}

    

    
    

