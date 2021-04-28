//
//  CategoryViewController.swift
//  Cafe-Manager
//
//  Created by Avishka Balasuriya on 2021-04-27.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCategoryName: UILabel!
    
}

class CategoryViewController: UIViewController {

    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var btnAddCategory: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestoreDataService().getAllCategories(){
            completion in
            self.tblCategory.delegate=self
            self.tblCategory.dataSource=self
            self.tblCategory.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnAddCategory.addTarget(self, action: #selector(self.addNewCategory(sender:)), for: .touchUpInside)
    }
    
    @objc func addNewCategory(sender:UIButton){
        let categoryId = NSUUID().uuidString.replacingOccurrences(of:"-", with: "")
        let categoryName = self.txtCategory.text as! String
        let category:Category = Category(categoryId:categoryId, categoryName:categoryName)
        firestoreDataService().addNewCategory(category: category){
            completion in
            print("Category Added")
            self.tblCategory.reloadData()
        }
    }
}

extension CategoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension CategoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryData.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "tblCategoryCell") as! CategoryTableViewCell
        cell.lblCategoryName.text=CategoryData.categoryList[indexPath.row].categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

