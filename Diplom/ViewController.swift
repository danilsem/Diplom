//
//  ViewController.swift
//  Diplom
//
//  Created by Admin on 26.03.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var expenseTable: UITableView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    var expenseDictionary: Dictionary<String, Dictionary<String, [Expense]>> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //containerExpenseAndIncome.layer.cornerRadius = 20
        
        let maskPath = UIBezierPath(roundedRect: backgroundContainer.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 10))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        backgroundContainer.layer.mask = shape
        
        expenseTable.layer.cornerRadius = 10
        
        expenseTable.dataSource = self
        expenseTable.delegate = self
        
        let realm = try! Realm()
        
        guard let userData = realm.objects(UserDate.self).first else {return}
        
        balanceLabel.text = "\(userData.balance) руб"
        
        print("Print")
        
        fetchAllExpenseAndIncome()
        
        // Adding user personal data
        /*try! realm.write() {
            let user = UserDate()
            user.balance = 10000
            realm.add(user)
        }*/
            
        /*try! realm.write() {
            let e = Expense()
            /*var d = DateComponents()
            d.day = 3
            e.date = Calendar.current.date(byAdding: d, to: e.date)!
            e.value = 100*/
            e.type = "Прочее"
            realm.add(e)
        }*/
    }

    func fetchAllExpenseAndIncome() {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                
                let fromDate = Date()
                let toDate = Date()
                
                var fromComponents = Calendar.current.dateComponents(in: .current, from: fromDate)
                var toComponents = Calendar.current.dateComponents(in: .current, from: toDate)
                
                fromComponents.day = 1
                toComponents.day = Int((Calendar.current.range(of: .day, in: .month, for: toDate)?.endIndex.magnitude)!-1)
                
                let format = NSPredicate(format: "date BETWEEN {%@, %@}", argumentArray: [fromComponents.date!, toComponents.date!])
                let expenses = realm.objects(Expense.self).filter(format)
                
                var curentExpenseValue: Double = 0
                
                expenses.forEach { (expense) in
                    curentExpenseValue += expense.value
                }
                
                var dates: Dictionary<String, Dictionary<String, [Expense]>> = [:]
                
                for expense in expenses.shuffled() {
                    let dateFormat = DateFormatter()
                    dateFormat.dateStyle = .medium
                    dateFormat.locale = Locale(identifier: "ru-RU")
                    if dates[dateFormat.string(from: expense.date)] == nil {
                        
                        var dic: Dictionary<String, [Expense]> = [:]
                        dic[expense.type] = [expense]
                        
                        dates[dateFormat.string(from: expense.date)] = dic
                    }
                    else {
                        dates[dateFormat.string(from: expense.date)]![expense.type]?.append(expense)
                    }
                }
                
                print(dates)
                
                // Add UI info
                DispatchQueue.main.async {
                    self.expenseLabel.text = "-\(Int(curentExpenseValue))₽"
                    //self.expenseDictionary = dates
                    self.expenseTable.reloadData()
                }
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseDictionary.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return expenseDictionary.keys.sorted().reversed()[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell") as! ExpenseViewCell
        
        cell.expenseImage.image = UIImage(systemName: "car.fill")
        
        return cell
    }
    
    
}

