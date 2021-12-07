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
    private var selectedBannerIndex = 0
    private var collectionView: UICollectionView?
    private var albumList: [Album]?
    private var searchAlbumList: [Album]?
    private var isSearch = false
    private var searchingText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbumList()
        listTableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "BannerCell")
        listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        listTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    /// Call album list api
    private func getAlbumList() {
        let albumService = AlbumListService()
        albumService.getAlbumList { [weak self] albumList, isSuccess in
            guard let self = self else { return }
            if isSuccess {
                self.albumList = albumList
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
        }
    }
}

//MARK:- Tableview delegates and datasource
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 43
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 43))
        let searchBar = createSearchBar()
        headerView.addSubview(searchBar)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if isSearch {
            return searchAlbumList?.count ?? 0
        }
        return albumList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0, indexPath.section == 0 {
            return (view.frame.height * 30) / 100
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, indexPath.row == 0 {
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: "BannerCell") as? BannerTableViewCell
            bannerCell?.bannerCollectionView.dataSource = self
            bannerCell?.bannerCollectionView.delegate = self
            bannerCell?.bannerCollectionView.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 0)
            bannerCell?.bannerCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionCell")
            
            bannerCell?.bannerPageControl.currentPage = selectedBannerIndex
            collectionView = bannerCell?.bannerCollectionView
            
            return bannerCell ?? UITableViewCell()
        } else {
            let listCell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListTableViewCell
            
            var album = albumList?[indexPath.row]
            if isSearch {
                album = searchAlbumList?[indexPath.row]
            }
            listCell?.titleLbl.text = album?.title
            if let url = URL.init(string: album?.thumbnailUrl ?? "") {
                listCell?.leftImgView.loadImageFromUrl(url: url)
            }
            
            return listCell ?? UITableViewCell()
        }
    }
    
    /// Setup search bar
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        
        searchBar.searchBarStyle = .minimal
        searchBar.text = searchingText
        searchBar.placeholder = " Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        
        let searchBarWidth = searchBar.frame.width
        let placeholderIconWidth = searchBar.searchTextField.leftView?.frame.width
        let placeHolderWidth = searchBar.searchTextField.attributedPlaceholder?.size().width
        let offsetIconToPlaceholder: CGFloat = 8
        let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
        let offset = UIOffset(horizontal: ((searchBarWidth / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon), vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
        return searchBar
    }
}

//MARK:- CollectionView delegates and datasource
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as? BannerCollectionViewCell
        bannerCell?.bannerImgView.image = UIImage.init(named: "Placeholder\(indexPath.row)")
        return bannerCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width - 16, height: (view.frame.height * 30) / 100)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        visibleRect.origin = collectionView?.contentOffset ?? CGPoint.init(x: 0, y: 0)
        visibleRect.size = collectionView?.bounds.size ?? CGSize.init(width: 0, height: 0)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView?.indexPathForItem(at: visiblePoint) else { return }
        selectedBannerIndex = indexPath.row
        listTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        print(indexPath)
    }
}

//MARK:- Searchbar delegates
extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint(searchText)
        searchingText = searchText
        if searchText == "" {
            isSearch = false
            listTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        } else {
            let predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
            searchAlbumList = albumList?.filter { predicate.evaluate(with: $0.title ?? "") }
            isSearch = true
            listTableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
}
