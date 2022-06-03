//
//  ViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 31.05.2022.
//

import Foundation
import UIKit

struct DeliveryStatusViewModel {
//    let id: Int
    var title: DeliveryStatusTitleViewModel
    var steps: [DeliveryStatusStepViewModel]
//    var expandedSteps: [Int]
    var evolutionStage: Stage
    var group: Group
    
    // TODO: Alesya Volosach | прост временное упрощение
    init(
        group: Group,
        evolutionStage: Stage,
        title: DeliveryStatusTitleViewModel,
        steps: [DeliveryStatusStepViewModel]
    ) {
        self.title = title
        self.group = group
        self.evolutionStage = evolutionStage
        self.steps = steps
    }
    
    var shortInfo: DeliveryStatusStepViewModel {
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
        
        return DeliveryStatusStepViewModel(
            title: title,
            type: .point(
                date: date,
                isPrimary: true
            ),
            evolutionStage: self.evolutionStage,
            group: self.group
        )
    }
    
    // MARK: - DeliveryStatusViewModel.Stage
    enum Stage {
        case past
        case future
        case present
    }
    
    // MARK: - DeliveryStatusViewModel.Group
    enum Group: String {
        case created = "CREATED"
        case inProgress = "IN_PROGRESS"
        case courier = "COURIER_IN_PROGRESS"
        case delivered = "DELIVERED"
        case notDelivered = "NOT_DELIVERED"
        
        var icon: UIImage {
            switch self {
            case .created:
                return UIImage(named: "orderDetail.status.created")!
            case .inProgress:
                return UIImage(named: "orderDetail.status.InProgress")!
            case .courier:
                return UIImage(named: "orderDetail.status.courierInProgress")!
            case .delivered:
                return UIImage(named: "orderDetail.status.delivered")!
            case .notDelivered:
                return UIImage(named: "orderDetail.status.notDelivered")!
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .created:
                return UIColor.hexStringToUIColor(hex: "E9C400")
            case .inProgress:
                return UIColor.hexStringToUIColor(hex: "F08A12")
            case .courier:
                return UIColor.hexStringToUIColor(hex: "008C6B")
            case .delivered:
                return UIColor.hexStringToUIColor(hex: "1AB248")
            case .notDelivered:
                return UIColor.hexStringToUIColor(hex: "FF6261")
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .created:
                return UIColor.hexStringToUIColor(hex: "FCF6D9")
            case .inProgress:
                return UIColor.hexStringToUIColor(hex: "FDEDDB")
            case .courier:
                return UIColor.hexStringToUIColor(hex: "DBEBE0")
            case .delivered:
                return UIColor.hexStringToUIColor(hex: "DDF3E4")
            case .notDelivered:
                return UIColor.hexStringToUIColor(hex: "FEE3E3")
            }
        }
        
        var inactiveTintColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "BBBBBB")
        }
        
        var defaultLineColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "DFDFDF")
        }
        
        var inactiveBackgroundColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "F4F4F4")
        }
    }
}

// MARK: - DeliveryStatusTitleViewModel
struct DeliveryStatusTitleViewModel {
//    let id: Int
    var title: String
    var date: String?
    var isExpanded: Bool
    
    var evolutionStage: DeliveryStatusViewModel.Stage
    var group: DeliveryStatusViewModel.Group
}

// MARK: - DeliveryStatusStepViewModel
struct DeliveryStatusStepViewModel {
//    let id: Int
    var title: String 
    var type: StepType
    
    var evolutionStage: DeliveryStatusViewModel.Stage
    var group: DeliveryStatusViewModel.Group
    
    // MARK: AdditionalModels
    enum StepType {
        case simple
        case subhead
        case point(
            date: String,
            isPrimary: Bool
        )
    }
}
