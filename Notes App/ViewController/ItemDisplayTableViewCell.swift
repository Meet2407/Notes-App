//
//  ItemDisplayTableViewCell.swift
//  News App
//
//  Created by R90 on 07/10/24.
//

import UIKit

class ItemDisplayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var typeSomething: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
