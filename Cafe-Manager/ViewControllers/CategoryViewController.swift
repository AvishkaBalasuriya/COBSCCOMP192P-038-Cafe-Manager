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
        
        self.btnAddCategory.addTarget(self, action: #selector(self.addNewCategory(sender:)), for: .touchUpInside)
        self.btnAddCategory?.layer.masksToBounds = true
        self.btnAddCategory?.layer.cornerRadius=self.btnAddCategory.frame.width/10
        
        firestoreDataService().getAllCategories(){
            completion in
            
            if completion is [Category]{
                self.tblCategory.delegate=self
                self.tblCategory.dataSource=self
                self.tblCategory.reloadData()
            }else{
                self.showAlert(title: "Firestore Error", message: "Unable to fetch categories")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func addNewCategory(sender:UIButton){
        if self.txtCategory.text == ""{
            self.showAlert(title: "Invalid input", message: "Please enter valid value as category name")
            return
        }
        
        let categoryId = NSUUID().uuidString.replacingOccurrences(of:"-", with: "")
        let categoryName = self.txtCategory.text!
        let category:Category = Category(categoryId:categoryId, categoryName:categoryName)
        
        firestoreDataService().addNewCategory(category: category){
            completion in
            
            let result = completion as! Int
            
            if result==500{
                self.showAlert(title: "Firestore Error", message: "Unable to add new category")
                return
            }else{
                self.showAlert(title: "Success", message: "Category successfully added")
                self.tblCategory.reloadData()
            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if CategoryData.categoryList.count == 0 {
            self.tblCategory.setEmptyView(title: "No categories", message: "Your categories will display in here")
        } else {
            self.tblCategory.restore()
        }
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

