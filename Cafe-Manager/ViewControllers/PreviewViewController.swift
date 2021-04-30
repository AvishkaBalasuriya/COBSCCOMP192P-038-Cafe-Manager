//
//  PreviewViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-27.
//

import UIKit

struct Objects{
    var sectionName:String!
    var sectionObjects:[Item]!
}

var objectsArray=[Objects]()

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    @IBOutlet weak var tglAvailable: UISwitch!
    
    @IBAction func btnAvailability(_ sender: UISwitch) {
        firestoreDataService().updateItemAvailability(itemId: sender.accessibilityIdentifier!, isAvailable: self.tglAvailable.isOn){
            completion in
        }
    }
    

}

class PreviewViewController: UIViewController {
    
    var sectionItem:[String:[Item]]=[:]

    @IBOutlet weak var tblItemTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeCategoryArray()
        self.tblItemTable.delegate=self
        self.tblItemTable.dataSource=self
        self.tblItemTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func makeCategoryArray(){
        for item in ItemData.itemList{
            if !self.sectionItem.keys.contains(item.category){
                self.sectionItem[item.category]=[]
                self.sectionItem[item.category]?.append(item)
            }else{
                self.sectionItem[item.category]?.append(item)
            }
        }
        for (key,value) in self.sectionItem{
            objectsArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
}

extension PreviewViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension PreviewViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.systemGreen
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if objectsArray.count == 0 {
            self.tblItemTable.setEmptyView(title: "No items", message: "Your items will display in here")
        } else {
            self.tblItemTable.restore()
        }
        return objectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ItemTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cellItem") as! ItemTableViewCell
        
        cell.imgFoodImage.imageFromServerURL(urlString: objectsArray[indexPath.section].sectionObjects[indexPath.row].itemThumbnail)
        cell.lblFoodName.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].itemName
        cell.lblFoodDescription.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].itemDescription
        cell.lblFoodPrice.text = String(format:"%.2f", objectsArray[indexPath.section].sectionObjects[indexPath.row].itemPrice)
        
        if objectsArray[indexPath.section].sectionObjects[indexPath.row].itemDiscount == 0.0{
            cell.lblFoodDiscount.isHidden=true
        }else{
            cell.lblFoodDiscount.text=String(format:"%.2f", objectsArray[indexPath.section].sectionObjects[indexPath.row].itemDiscount)
        }
        cell.lblFoodDiscount?.layer.masksToBounds = true
        cell.lblFoodDiscount?.layer.cornerRadius=cell.lblFoodDiscount.frame.width/10
        
        cell.tglAvailable.isOn=objectsArray[indexPath.section].sectionObjects[indexPath.row].isAvailable
        
       cell.tglAvailable.accessibilityIdentifier=objectsArray[indexPath.section].sectionObjects[indexPath.row].itemId
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.masksToBounds = false
        
        return cell
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        let urlStringNew = urlString.replacingOccurrences(of: " ", with: "%20")
        URLSession.shared.dataTask(with: NSURL(string: urlStringNew)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()

    }
}
