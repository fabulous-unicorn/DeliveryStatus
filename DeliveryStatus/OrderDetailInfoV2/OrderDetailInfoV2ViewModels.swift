//
//  InfoDepartureViewModels.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import Foundation
import UIKit

struct OrderDetailInfoV2ViewModel {
    var title: String
    var description: String
    var from: FromToWhere
    var to: FromToWhere
    var aditionalServices: AdditionalService
    var info: Info
    
    // MARK: - FromToWhere
    
    struct FromToWhere {
        var type: FromToWhereType
        var items: Item
                
        struct Item {
            var type: ItemType
            var title: String
        }
        
        enum ItemType {
            case address, person, phone
            
            var icon: UIImage { return UIImage(named: "")!}
        }
    }
    
    enum FromToWhereType {
        case from
        case to
        
        var title: String {
            switch self {
            case .from: return "Откуда"
            case .to: return "Куда"
            }
        }
        
        var icon: UIImage { return UIImage(named: "")!}
    }
    
    // MARK: - AdditionalService
    
    struct AdditionalService {
        var services: [Service]
        
        struct Service {
            var title: String
            var description: String
        }
    }
    
    // MARK: - Info
    
    struct Info {
        var items: [Item]
        
        struct Item {
            var title: String
            var description: String
            var additionalInfo: String?
            var type: ItemType
        }
        
        enum ItemType {
            case `default`(isExpandingAvailable: Bool, items: [Item])
            case nested
        }
    }
}
