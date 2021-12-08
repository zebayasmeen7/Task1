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
    
    func loadDataInCell(album: Album?) {
        titleLbl.text = album?.title
        if let url = URL.init(string: album?.thumbnailUrl ?? "") {
            leftImgView.loadImageFromUrl(url: url)
        }
    }
}
