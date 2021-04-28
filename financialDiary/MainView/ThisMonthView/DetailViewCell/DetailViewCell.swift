//
//  DetailViewCell.swift
//  financialDiary
//
//  Created by Dong Truong on 4/28/21.
//

import UIKit

class DetailViewCell: UITableViewCell {
    @IBOutlet weak var historyLabel: UILabel!

    var history: String? {
        didSet {
            if let history = history {
                historyLabel.text = "\(history)$"
                historyLabel.textColor = .systemBackground
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: contentView.frame.size.height - 1, width: contentView.frame.size.width, height: 1)
        contentView.layer.addSublayer(border)
    }

}
