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
        
        let steps = configureSteps(groupDTO, group, evolutionStage)
        
        // Card
        let card = configureCard()
        
        // Title
        // TODO: Alesya Volosach | тут для теста карточки можно будет комментить
        var isExpandingAvailable = false
        if group == .created && evolutionStage == .past {
            isExpandingAvailable = false
        } else {
            isExpandingAvailable = !steps.isEmpty || card != nil
        }
        let title = configureTitle(groupDTO, group, evolutionStage, isExpandingAvailable: isExpandingAvailable)
        
        return DeliveryStatusViewModel(
            group: group,
            message: message,
            evolutionStage: evolutionStage,
            isLastStatus: isLastStatus,
            title: title,
            steps: steps,
            card: card)
    }
                    
    func configureCard() -> DeliveryStatusViewModel.Card? {
        // TODO: Alesya Volosach | дописать
        return nil
        //    var mode: DeliveryType
        //    var address: String
        //    var officeId: Int?
        //    var pickUpInfo: String?
        //    var displayChangeButton: Bool
        //    var planedDeliveryInfo: String?
        //    var message: String?
        //    var keepDateInfo: String?
        //    var keepInfoLink: URL?
    }
    
    func configureGroup(
        _ code: OrderStatusGroupDto.Code
    ) -> DeliveryStatusViewModel.Group {
        switch code {
        case .initial: return .created
        case .inProgress: return .inProgress
        case .courierInProgress: return .courier
        case .readyForPickUp: return .readyForPick
        case .delivered: return .delivered
        case .partiallyDelivered: return .partiallyDelivered
        case .notDelivered: return .notDelivered
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
    
    func configureTitle(
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
    
    func configureSteps(
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
}

    

    
    

