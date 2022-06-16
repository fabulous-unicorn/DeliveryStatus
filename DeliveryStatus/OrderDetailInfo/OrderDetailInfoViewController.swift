//
//  OrderDetailInfoViewController.swift
//  DeliveryStatus
//
//  Created by Alesya Volosach on 15.06.2022.
//

import UIKit

class OrderDetailInfoViewController: UITableViewController {
    
    enum Constants {
        static let titleGroupCellIdentifier = "orderDetailsInfoTitleGroupCell"
        static let actorCellIdentifier = "orderDetailsInfoOrderActorCell"
        static let serviceCellIdentifier = "orderDetailsInfoServiceCell"
        static let parcelInfocellIdentifier = "orderDetailsInfoParcelInfoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "OrderDetailsInfoTitleGroupCell", bundle: nil), forCellReuseIdentifier: Constants.titleGroupCellIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mainModel.groups.count - 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.titleGroupCellIdentifier, for: indexPath) as! OrderDetailsInfoTitleGroupCell

        cell.configure(title: "Откуда")
        
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - for test
    let mainModel = OrderDetailsInfoViewModel(
        title: "Посылочка, размер S",
        description: "Супер-экспресс, доставит курьер до 16:00",
        groups: [
            .actor(
                role: .sender,
                items: [
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Москва, ул. Ленина 234, кв. 56",
                        icon: UIImage(named: "orderDetailInfo.mapPin")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Иванов Алексей Евгеньевич",
                        icon: UIImage(named: "orderDetailInfo.userCircle")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "+7 (000) 000-00-00",
                        icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                        behavior: .contact
                    )
                ]
            ),
            .actor(
                role: .receiver,
                items: [
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Новосибирск, ул. Писарева 136, кв. 152",
                        icon: UIImage(named: "orderDetailInfo.mapPin")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "Иванов Сергей Алексеевич",
                        icon: UIImage(named: "orderDetailInfo.userCircle")!,
                        behavior: .copy
                    ),
                    OrderDetailsInfoViewModel.OrderActor(
                        title: "+7 (000) 000-00-00",
                        icon: UIImage(named: "orderDetailInfo.messageCircle")!,
                        behavior: .contact
                    )
                ]
            ),
            .additionalServices(
                services: [
                    OrderDetailsInfoViewModel.AdditionalService(
                        title: "Страхование",
                        description: ["Объявленная стоимость: 1 000 ₽"]
                    ),
                    OrderDetailsInfoViewModel.AdditionalService(
                        title: "Коробка",
                        description: ["10 кг. 40×35×28 см. / 10 шт.", "30 кг. 69×39×42 см. / 5 шт."]
                    ),
                    OrderDetailsInfoViewModel.AdditionalService(
                        title: "Доп. упаковочные материалы",
                        description: ["Макулатурная бумага / 10 м."]
                    )
                ]
            ),
            .parcelInfo(
                items: [
                    OrderDetailsInfoViewModel.ParcelInfo(
                        title: "Характер груза",
                        description: "Бытовая техника, обувь",
                        additionalInfo: nil,
                        type: .default(nestedItems: [])
                    ),
                    OrderDetailsInfoViewModel.ParcelInfo(
                        title: "Габариты места 1 (ДхШхВ)",
                        description: "48×42×42 см.",
                        additionalInfo: nil,
                        type: .default(nestedItems: [
                            OrderDetailsInfoViewModel.ParcelInfo(
                                title: "Артикул: 435342112",
                                description: "Майка Adidas Fusion Sport Max II / 2 шт.",
                                additionalInfo: nil,
                                type: .nested
                            ),
                            OrderDetailsInfoViewModel.ParcelInfo(
                                title: "Артикул: 955342111",
                                description: "Баскетбольный мяч Nike Classic / 1 шт.",
                                additionalInfo: nil,
                                type: .nested
                            )
                        ])
                    ),
                    OrderDetailsInfoViewModel.ParcelInfo(
                        title: "Физический вес",
                        description: "9,8 кг",
                        additionalInfo: "Физический вес. Дополнительное описание для модалки",
                        type: .default(nestedItems: [])
                    )
                ]
            )
        ]
    )
}
