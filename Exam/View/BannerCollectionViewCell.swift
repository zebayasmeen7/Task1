//
//  BannerCollectionViewCell.swift
//  Exam
//
//  Created by Neosoft on 07/12/21.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadBannerImageCell(album: Album?) {
        if let url = URL.init(string: album?.thumbnailUrl ?? "") {
            bannerImgView.loadImageFromUrl(url: url)
        }
    }
}
