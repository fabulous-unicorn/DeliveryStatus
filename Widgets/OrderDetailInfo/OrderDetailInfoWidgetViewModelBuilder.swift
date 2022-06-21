//
//  OrderDetailInfoWidgetViewModelBuilder.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 21.06.2022.
//

import Foundation
import UIKit

class OrderDetailInfoWidgetViewModelBuilder {
    
    func build(order: Order) -> OrderDetailInfoViewModel {
    return OrderDetailInfoViewModel(
        groups: [
            headerViewModel(order),
            orderActorSenderViewModel(order),
            orderActorReceiverViewModel(order)//,
//            additionalServicesViewModel(order),
//            parcelInfoViewModel(order)
        ]
    )
    }
    
    // MARK: - headerViewModel

    private func headerViewModel(_ order: Order) -> OrderDetailInfoViewModel.ContentGroup {
        // TODO: Alesya Volosach | Этих данных нет
        let title = "Посылочка, размер S"
        let description = "Супер-экспресс, доставит курьер до 16:00"
        
        return .header(
            item: OrderDetailInfoViewModel.HeaderItem(
                title: title,
                description: description
            )
        )
    }
    
    // MARK: - orderActorSenderViewModel
    // TODO: Alesya Volosach | Посмотреть имеет ли смысл объединять функции sender/reciver
    private func orderActorSenderViewModel(_ order: Order) -> OrderDetailInfoViewModel.ContentGroup {
        
        var items: [OrderDetailInfoViewModel.OrderActor] = []
        
        // AddressItem
        let departureCity = order.departureCity.name
        if
            !departureCity.isEmpty,
            let address = order.sender?.address,
            !address.isEmpty {
            
            let addressItem = OrderDetailInfoViewModel.OrderActor(
                title: "\(departureCity), \(address)",
                icon: UIImage(named: "orderDetailInfo.mapPin")!,
                behavior: .copy
            )
            items.append(addressItem)
        }
        
        // Name
        if
            let name = order.sender?.name,
            !name.isEmpty
        {
            
            let nameItem = OrderDetailInfoViewModel.OrderActor(
                title: name,
                icon: UIImage(named: "orderDetailInfo.userCircle")!,
                behavior: .copy
            )
            items.append(nameItem)
        }
        
        // Phone
        // TODO: Alesya Volosach | Возможно здесь преобразование номера
        if
            let phone = order.sender?.phone,
            !phone.isEmpty
        {
            let phoneItem = OrderDetailInfoViewModel.OrderActor(
                title: phone,
                icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                behavior: .contact(modalTitle: "Связаться с отправителем")
            )
            items.append(phoneItem)
        }
        
        // TODO: Alesya Volosach | Спросить про вероятность отсутствия данных
        return .actor(
            role: .sender,
            items: items
        )
    }
    
    // MARK: - orderActorReceiverViewModel
    
    private func orderActorReceiverViewModel(_ order: Order) -> OrderDetailInfoViewModel.ContentGroup {
        
        var items: [OrderDetailInfoViewModel.OrderActor] = []
        
        // AddressItem
        let destinationCity = order.destinationCity.name
        if
            !destinationCity.isEmpty,
            let address = order.sender?.address,
            !address.isEmpty {
            
            let addressItem = OrderDetailInfoViewModel.OrderActor(
                title: "\(destinationCity), \(address)",
                icon: UIImage(named: "orderDetailInfo.mapPin")!,
                behavior: .copy
            )
            items.append(addressItem)
        }
        
        // Name
        if
            let name = order.receiver?.name,
            !name.isEmpty
        {
            
            let nameItem = OrderDetailInfoViewModel.OrderActor(
                title: name,
                icon: UIImage(named: "orderDetailInfo.userCircle")!,
                behavior: .copy
            )
            items.append(nameItem)
        }
        
        // Phone
        // TODO: Alesya Volosach | Возможно здесь преобразование номера
        if
            let phone = order.receiver?.phone,
            !phone.isEmpty
        {
            let phoneItem = OrderDetailInfoViewModel.OrderActor(
                title: phone,
                icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                behavior: .contact(modalTitle: "Связаться с отправителем")
            )
            items.append(phoneItem)
        }

        return .actor(
            role: .receiver,
            items: items
        )
    }
    
    // MARK: - additionalServicesViewModel
    
    private func additionalServicesViewModel(_ order: Order) -> OrderDetailInfoViewModel.ContentGroup {
        var services: [OrderDetailInfoViewModel.AdditionalService] = []
        // TODO: Alesya Volosach | Данных о допуслугах на данный момент в заказе нет!
//        let a = OrderDetailInfoViewModel.AdditionalService(
//            title: <#T##String#>,
//            description: <#T##[String]#>
//        )
        
        return .additionalServices(services: services)
    }
    
    // MARK: - parcelInfoViewModel
    
    private func parcelInfoViewModel(_ order: Order) -> OrderDetailInfoViewModel.ContentGroup {
        var parcelInfo: [OrderDetailInfoViewModel.ParcelInfo] = []
        // TODO: Alesya Volosach | Номера заказа  ИМ на данный момент в заказе нет!
        // TODO: Alesya Volosach | Информации о характере груза на данный момент в заказе нет!
        // TODO: Alesya Volosach | Информации о товарах на данный момент в заказе нет!
        
//        let a = OrderDetailInfoViewModel.ParcelInfo(
//            title: <#T##String#>,
//            description: <#T##String#>,
//            additionalInfo: <#T##String?#>,
//            type: <#T##OrderDetailInfoViewModel.ParcelInfoType#>
//        )
        // TODO: Alesya Volosach | Проверить использование поля servies и serviceName!
        // TODO: Alesya Volosach | Также проверить использование serviceCost!
        
        return .parcelInfo(items: parcelInfo)
    }
}
