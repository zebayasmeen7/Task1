//
//  ListViewModel.swift
//  Exam
//
//  Created by Neosoft on 08/12/21.
//

import Foundation

protocol ListViewModelDelegate {
    
    func getListCount() -> Int
    func getSelectedAlbum(index: Int) -> Album?
    func setSelectedBannerIndex(index: Int)
    func searchList(searchText: String)
}

class ListViewModel: NSObject, ListViewModelDelegate {
    
    typealias completionHandler = (_ isSuccess:Bool) -> Void
    
    var albumList: [Album]?
    var searchAlbumList: [Album]?
    var isSearch = false
    var selectedBannerIndex = 0
    
    /// Get album list from server
    func getAlbumList(completion: @escaping completionHandler) {
        
        let albumService = AlbumListService()
        albumService.getAlbumListFromServer { [weak self] albumList, isSuccess in
            guard let self = self else { return }
            self.albumList = albumList
            completion(isSuccess)
        }
    }
    
    /// Get album list count based on search
    func getListCount() -> Int {
        if !isSearch {
            return albumList?.count ?? 0
        } else {
            return searchAlbumList?.count ?? 0
        }
    }
    
    /// Get album based on search / non-search
    func getSelectedAlbum(index: Int) -> Album? {
        if !isSearch {
            return albumList?[index]
        } else {
            return searchAlbumList?[index]
        }
    }
    
    func setSelectedBannerIndex(index: Int) {
        selectedBannerIndex = index
    }
    
    /// Search list
    func searchList(searchText: String) {
        if searchText == "" {
            isSearch = false
        } else {
            isSearch = true
            let predicate = NSPredicate(format: "SELF contains[c] %@", searchText)
            searchAlbumList = albumList?.filter { predicate.evaluate(with: $0.title ?? "") }
        }
    }
}
