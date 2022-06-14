//
//  OrederDTO.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 09.06.2022.
//

import Foundation

// MARK: New models

struct OrderStatusGroupDto {
    let name: String
    let code: Code
    let message: String?
    let occurrence: String?
    let evolutionStage: EvolutionStage
    let roadMap: [OrderDeliveryStepDto]
    
    enum Code: String {
        case initial = "INITIAL"
        case inProgress = "IN_PROGRESS"
        case courierInProgress = "COURIER_IN_PROGRESS"
        case readyForPickUp = "READY_FOR_PICK_UP"
        case notRecived = "NOT_DELIVERED"
        case recived = "DELIVERED"
        case partiallyRecived = "PARTIALLY_DELIVERED"
        case unowned
    }
    
    enum EvolutionStage: String {
        case past = "PAST"
        case present = "PRESENT"
        case future = "FUTURE"
    }
//        code = try container.decode(Code.self, forKey: .code)
//        occurrence = try container.decode(String.self, forKey: .date)
//        evolutionStage = try container.decode(EvolutionStage.self, forKey: .evolutionStage)
        
//    var occurrenceDate: Date? {}
    
}

struct OrderDeliveryStepDto {
    let city: String?
    let statuses: [StatusDto]
}

// TODO: Alesya Volosach | Думаю название будет полней
struct StatusDto {
    let title: String
    let date: String
}


// MARK: - In project

class Order {
    // MARK: Used old properties
    let departureDate: String? //example
    var plannedDeliveryDate: String?
    var status: OrderStatus
    let sender: PersonShortInfo?
    let senderDeliveryType: DeliveryType?
    var receiver: PersonShortInfo?
    let receiverDeliveryType: DeliveryType?
    let departureCity: City
    let destinationCity: City
    let senderOffice: Office?
    let office: Office?
    let canBeChanged: Bool?
    let storageDateEnd: String?
    let warehousingInfoUrl: URL?
    let pickUp: PickUp?
    
    // MARK: New properties
    let orderStatusGroups: [OrderStatusGroupDto]
    let plannedDeliveryDateNote: String?
    let plannedDeliveryNotAvailableNote: String?
    
    
    private enum Constant {
        static let dateFormat = "dd.MM.yyyy"
    }
    
//    var departureOrderDate: Date? {
//        return departureDate?.date(withFormat: .custom(Constant.dateFormat))?.absoluteDate
//    }
    
//    var plannedDeliveryOrderDate: Date? {
//        get {
//            return plannedDeliveryDate?.date(withFormat: .custom(Constant.dateFormat))?.absoluteDate
//        }
//        set {
//            plannedDeliveryDate = newValue?.string(withFormat: .custom(Constant.dateFormat))
//        }
//    }
    
//    let statusString = try container.decode(String.self, forKey: .status)
//
//    if
//        let status = OrderStatusType(rawValue: statusString),
//        let name = status.readableString {
//        self.status = OrderStatus(
//            code: statusString,
//            name: name,
//            colorHex: status.color.toHexString()
//        )
//    } else {
//        self.status = OrderStatus(
//            code: statusString,
//            name: OrderStatusType.unknown.readableString ?? "",
//            colorHex: OrderStatusType.unknown.color.toHexString()
//        )
//    }
    internal init(
        departureDate: String?,
        plannedDeliveryDate: String? = nil,
        status: OrderStatus,
        sender: PersonShortInfo?,
        senderDeliveryType: DeliveryType?,
        receiver: PersonShortInfo? = nil,
        receiverDeliveryType: DeliveryType?,
        departureCity: City,
        destinationCity: City,
        senderOffice: Office?,
        office: Office?,
        canBeChanged: Bool?,
        storageDateEnd: String?,
        warehousingInfoUrl: URL?,
        pickUp: PickUp?,
        orderStatusGroups: [OrderStatusGroupDto],
        plannedDeliveryDateNote: String?,
        plannedDeliveryNotAvailableNote: String?
    ) {
        self.departureDate = departureDate
        self.plannedDeliveryDate = plannedDeliveryDate
        self.status = status
        self.sender = sender
        self.senderDeliveryType = senderDeliveryType
        self.receiver = receiver
        self.receiverDeliveryType = receiverDeliveryType
        self.departureCity = departureCity
        self.destinationCity = destinationCity
        self.senderOffice = senderOffice
        self.office = office
        self.canBeChanged = canBeChanged
        self.storageDateEnd = storageDateEnd
        self.warehousingInfoUrl = warehousingInfoUrl
        self.pickUp = pickUp
        self.orderStatusGroups = orderStatusGroups
        self.plannedDeliveryDateNote = plannedDeliveryDateNote
        self.plannedDeliveryNotAvailableNote = plannedDeliveryNotAvailableNote
    }
}

struct OrderStatus {
    // MARK: Used old properties
    var code: String = ""
    var name: String = ""
    
    var isReceived: Bool {
        code == OrderStatusType.received.rawValue
    }
    
    var isNotReceived: Bool {
        code == OrderStatusType.notReceived.rawValue
    }
    
    var isReadyForReceipt: Bool {
        code == OrderStatusType.readyForReceipt.rawValue
    }
    
    var isDraft: Bool {
        code == OrderStatusType.draft.rawValue
    }
}

enum OrderStatusType: String {
    case invoiceCreated = "INVOICE_CREATED"
    case acceptedInSenderCity = "ACCEPTED_IN_SENDER_CITY"
    case sentToTransitCity = "SENT_TO_TRANSIT_CITY"
    case inTransitCity = "IN_TRANSIT_CITY"
    case sentToReceiverCity = "SENT_TO_RECEIVER_CITY"
    case returnedToStorage = "RETURNED_TO_STORAGE"
    case acceptedInReceiverCity = "ACCEPTED_IN_RECEIVER_CITY"
    case readyForReceipt = "READY_FOR_RECEIPT"
    case courierDelivery = "COURIER_DELIVERY"
    case received = "RECEIVED"
    case notReceived = "NOT_RECEIVED"
    case customClearance = "CUSTOMS_CLEARANCE"
    case customClearanceCompleted = "CUSTOMS_CLEARANCE_COMPLETED"
    case acceptedInRussia = "ACCEPTED_IN_RUSSIA"
    case failedDeliveryAttempt = "FAILED_DELIVERY_ATTEMPT"
    case created = "CREATED"
    case inProgress = "IN_PROGRESS"
    case receivedPartly = "RECEIVED_PARTLY"
    case request = "REQUEST"
    case none = "NONE"
    case draft = "DRAFT" // NOTE: local status
    
    case unknown
}

struct PersonShortInfo {
    // MARK: Used old properties
    var address: String?
}

struct City {
    // MARK: Used old properties
    let name: String
}

struct Office: Decodable {
    // MARK: Used old properties
    let id: Int
    let address: String
}


enum DeliveryType: String, Codable {
    case home = "HOME"
    case pvz = "PVZ"
    case postomate = "POSTOMATE"
    
    var index: UInt {
        switch self {
        case .home:
            return 0
        case .pvz:
            return 1
        case .postomate:
            return 2
        }
    }
    
    static func fromIndex(_ index: UInt) -> DeliveryType {
        switch index {
        case 0:
            return .home
        case 1:
            return .pvz
        default:
            return .postomate
        }
    }
}

struct PickUp {
    // MARK: Used old properties
    let arrivalDate: String
    let arrivalTimeFrom: String
    let arrivalTimeTo: String
}
