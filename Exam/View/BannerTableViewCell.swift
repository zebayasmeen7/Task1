//
//  BannerTableViewCell.swift
//  Exam
//
//  Created by Neosoft on 07/12/21.
//

import UIKit

class BannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCell() {
        bannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionCell")
    }
    
    func loadTableviewCellData(bannerCount: Int, index: Int) {
        bannerPageControl.numberOfPages = bannerCount - 15
        bannerPageControl.currentPage = index
    }
    
}
