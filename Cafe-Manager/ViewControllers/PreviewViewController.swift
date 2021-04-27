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
var sectionNames=[String]

class CategoryTableView: UITableViewCell {
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    @IBAction func swItemStatus(_ sender: Any) {
    }
    
}

class PreviewViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func makeCategoryArray(){
        for item in ItemData.itemList{
            if
            objectsArray.append(Objects(sectionName: ))
        }
    }
    
}

extension PreviewViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension PreviewViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
    }
    
    func numberOfSectionsInTableView(table:UITableView)->Int{
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryTableView =  tableView.dequeueReusableCell(withIdentifier: "tbvCell") as! CategoryTableView
        cell.imgFoodImage.imageFromServerURL(urlString: ItemData.itemList[indexPath.row].itemThumbnail)
        cell.lblFoodName.text = ItemData.itemList[indexPath.row].itemName
        cell.lblFoodDescription.text = ItemData.itemList[indexPath.row].itemDescription
        cell.lblFoodPrice.text = String(format:"%.2f", ItemData.itemList[indexPath.row].itemPrice)
        
        if ItemData.itemList[indexPath.row].itemDiscount == 0.0{
            cell.lblFoodDiscount.isHidden=true
        }else{
            cell.lblFoodDiscount.text=String(format:"%.2f", ItemData.itemList[indexPath.row].itemDiscount)
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
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
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

