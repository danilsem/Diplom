//
//  ExpenseViewCell.swift
//  Diplom
//
//  Created by Admin on 27.03.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ExpenseViewCell: UITableViewCell {

    @IBOutlet weak var expenseImage: UIImageView!
    
    @IBOutlet weak var expenseValue: UILabel!
    
    @IBOutlet weak var expenseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
