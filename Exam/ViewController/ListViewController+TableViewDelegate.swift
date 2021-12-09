//
//  ListViewController+TableViewDelegate.swift
//  Exam
//
//  Created by Neosoft on 08/12/21.
//

import UIKit

//MARK:- Tableview delegates and datasource
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return 43
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 43))
        let searchBar = createSearchBar(frame: headerView.frame)
        headerView.addSubview(searchBar)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return listViewModel.getListCount()
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
            bannerCell?.bannerPageControl.addTarget(self, action: #selector(changeBanner(sender:)), for: .touchUpInside)
            pageControl = bannerCell?.bannerPageControl
            bannerCollectionView = bannerCell?.bannerCollectionView
            bannerCell?.loadTableviewCellData(bannerCount: listViewModel.getListCount(), index: listViewModel.selectedBannerIndex)
            return bannerCell ?? UITableViewCell()
        } else {
            let listCell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListTableViewCell
            listCell?.loadDataInCell(album: listViewModel.getSelectedAlbum(index: indexPath.row))
            return listCell ?? UITableViewCell()
        }
    }
    
    /// Setup search bar
    private func createSearchBar(frame: CGRect) -> UISearchBar {
        let searchBar = CustomSearchBar.init(frame: frame)
        searchBar.delegate = self
        return searchBar
    }
    
    @objc func changeBanner(sender: UIPageControl) {
        listViewModel.setSelectedBannerIndex(index: sender.currentPage)
        let visibleRect = bannerCollectionView?.layoutAttributesForItem(at: IndexPath.init(row: sender.currentPage, section: 0))
        bannerCollectionView?.scrollRectToVisible(visibleRect?.frame ?? CGRect.init(x: 0, y: 0, width: view.frame.width, height: (view.frame.height * 30) / 100), animated: true)
    }
}

//MARK:- CollectionView delegates and datasource
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.getListCount() - 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionCell", for: indexPath) as? BannerCollectionViewCell
        bannerCell?.loadBannerImageCell(album: listViewModel.getSelectedAlbum(index: indexPath.row))
        return bannerCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: (view.frame.height * 30) / 100)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isPagingEnabled { return }
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        listViewModel.setSelectedBannerIndex(index: index)
        pageControl?.currentPage = listViewModel.selectedBannerIndex
    }
}

//MARK:- Searchbar delegates
extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listViewModel.searchList(searchText: searchText)
        listTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
