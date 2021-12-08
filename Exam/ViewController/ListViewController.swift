//
//  ListViewController.swift
//  Exam
//
//  Created by Neosoft on 07/12/21.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    //MARKS:- Variables
    var pageControl: UIPageControl?
    var bannerCollectionView: UICollectionView?
    let listViewModel =  ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbumList()
        setupListView()
    }
    
    /// Close keybord on tap
    @IBAction func tapgestureAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func setupListView() {
        listTableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerCell")
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        listTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    /// Call album list api
    private func getAlbumList() {
        listViewModel.getAlbumList { [weak self] isSuccess in
            guard let self = self else { return }
            if isSuccess {
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                    self.bannerCollectionView?.reloadData()
                }
            }
        }
    }
}
