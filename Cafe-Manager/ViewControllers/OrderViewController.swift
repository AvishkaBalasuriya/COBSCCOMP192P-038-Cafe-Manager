//
//  OrderViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-28.
//

import UIKit

struct OrderObjects{
    var sectionName:String!
    var sectionObjects:[Order]!
}

var orderObjectsArray=[OrderObjects]()

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
}

class OrderViewController: UIViewController {
    
    @IBOutlet weak var tblOrderTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        firestoreDataService().getAllOrders(){completion in
            print("Refreshing")
            self.makeCategoryArray()
            self.tblOrderTable.delegate=self
            self.tblOrderTable.dataSource=self
            self.tblOrderTable.reloadData()
        }
    }
    
    private func makeCategoryArray(){
        var sectionItem:[String:[Order]]=[:]
        for order in OrderData.orderList{
            let statusName:String = self.mapOrderStatus(status:order.status)
            if !sectionItem.keys.contains(statusName){
                sectionItem[statusName]=[]
                sectionItem[statusName]?.append(order)
            }else{
                sectionItem[statusName]?.append(order)
            }
        }
        orderObjectsArray.removeAll()
        for (key,value) in sectionItem{
             orderObjectsArray.append(OrderObjects(sectionName: key, sectionObjects: value))
        }
    }
    
    private func mapOrderStatus(status:Int)->String{
        switch status {
        case 0:
            return "New"
        case 1:
            return "Preparing"
        case 2:
            return "Ready"
        case 3:
            return "Arriving"
        case 4:
            return "Done"
        case 5:
            return "Canceled"
        default:
            return "Other"
        }
    }
    
}

extension OrderViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier:"OrderDetailsViewController") as? OrderDetailsViewController
        orderDetailsViewController?.orderDetails = orderObjectsArray[indexPath.section].sectionObjects[indexPath.row]
        self.navigationController?.pushViewController(orderDetailsViewController!, animated: true)
    }
}

extension OrderViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return orderObjectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return orderObjectsArray[section].sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderObjectsArray.count
    }
    
    func numberOfSectionsInTableView(table:UITableView)->Int{
        return orderObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cellOrder") as! OrderTableViewCell
        
        cell.lblCustomerName.text=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].userEmailAddress
        cell.lblOrderId.text=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].orderId
        
        cell.btnReject.layer.cornerRadius = cell.btnReject.frame.width/2
        cell.btnReject.layer.masksToBounds = true
        
        cell.btnAccept.layer.cornerRadius = cell.btnAccept.frame.width/2
        cell.btnAccept.layer.masksToBounds = true
        
        if orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].status==0{
            cell.btnAccept.backgroundColor=UIColor.systemGreen
            cell.btnAccept.setTitle("Accept", for: .normal)
            cell.btnAccept.accessibilityIdentifier=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].orderId
            cell.btnAccept.addTarget(self, action: #selector(self.acceptOrder(sender:)), for: .touchUpInside)
            
            cell.btnReject.isHidden=false
            cell.btnReject.setTitle("Reject", for: .normal)
            cell.btnReject.accessibilityIdentifier=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].orderId
            cell.btnReject.addTarget(self, action: #selector(self.rejectOrder(sender:)), for: .touchUpInside)
        }else{
            cell.btnReject.isHidden=true
            cell.btnAccept.backgroundColor=UIColor.systemYellow
            cell.btnAccept.setTitle(self.mapOrderStatus(status: orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].status), for: .normal)
            cell.btnAccept.tag=indexPath.row
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.masksToBounds = false
        return cell
    }
    
    @objc func acceptOrder(sender:UIButton){
        let orderId = sender.accessibilityIdentifier!
        firestoreDataService().changeOrderStatus(orderId: orderId, status: 1){
            completion in
        }
    }
    
    @objc func rejectOrder(sender:UIButton){
        let orderId = sender.accessibilityIdentifier!
        firestoreDataService().changeOrderStatus(orderId: orderId, status: 5){
            completion in
        }
    }
}

