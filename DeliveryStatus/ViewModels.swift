//
//  ViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 31.05.2022.
//

import Foundation
import UIKit

struct DeliveryStatusViewModel {
    var title: DeliveryStatusTitleViewModel
    var points: [DeliveryStatusPointViewModel]
    
    var shortInfo: DeliveryStatusPointViewModel {
        // Title
        var title = ""
        if let lastSubheadPoint = self.points.last(
            where: { point in
                if case .subhead = point.type {
                        return true
                }
                return false
            }
        ) {
            title = lastSubheadPoint.title
        }
        
        // Status
        var date = ""
        if
            let lastPoint = self.points.last,
            case let .full(lastDate) = lastPoint.type
        {
            date = lastDate
            
            if
                lastPoint.title != title,
                !title.isEmpty
            {
                title = "\(title)\\\(lastPoint.title)"
            } else {
                title = lastPoint.title
            }
        }
        
        return DeliveryStatusPointViewModel(
            title: title,
            type: .full(
                date: date)
        )
    }
}

// TODO: Alesya Volosach | Для плоской структуры

// MARK: - DeliveryStatusTitleViewModel
struct DeliveryStatusTitleViewModel {
    // TODO: Alesya Volosach | нужно еще понимать когда есть и когда нет стрелки
    var title: String
    var group: Group
    var type: StatusType
    var date: String?
    
    // MARK: AdditionalModels
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
        
        var backgroundColorIcon: UIColor {
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
        
        var inactiveTintIconColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "BBBBBB")
        }
        
        var defaultLineColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "DFDFDF")
        }
        
        var inactiveBackgroundIconColor: UIColor {
            return UIColor.hexStringToUIColor(hex: "F4F4F4")
        }
    }
    
    enum StatusType {
        case past
        case future
        case present
    }
}

// MARK: - DeliveryStatusPointViewModel
struct DeliveryStatusPointViewModel {
    var title: String
    var type: PointType
    
    // MARK: AdditionalModels
    enum PointType {
        case simple
        case subhead
        case full(
            date: String
        )
    }
}
