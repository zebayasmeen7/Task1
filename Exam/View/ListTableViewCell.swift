//
//  ListTableViewCell.swift
//  Exam
//
//  Created by Neosoft on 07/12/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
