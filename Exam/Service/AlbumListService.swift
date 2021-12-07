//
//  AlbumListService.swift
//  Exam
//
//  Created by Neosoft on 07/12/21.
//

import Foundation

struct AlbumListService {
    
    typealias completionHandler = (_ response: [Album]?, _ isSuccess:Bool) -> Void
    
    func getAlbumList(completion: @escaping completionHandler) {
        
        NetworkManager.shared.dataTask(serviceURL: Constant.listUrl, httpMethod: .get, parameters: nil) { response, error in
            if error == nil {
                do {
                    if let resp = response as? NSArray {
                        debugPrint(resp.count)
                        var albumList: [Album] = []
                        var counter = 0
                        for index in 0..<resp.count {
                            let jsonDecoder = JSONDecoder()
                            let jsonData = try JSONSerialization.data(withJSONObject: resp[index], options: JSONSerialization.WritingOptions.prettyPrinted)
                            let responseModel = try jsonDecoder.decode(Album.self, from: jsonData)
                            albumList.append(responseModel)
                            counter = counter + 1
                            if counter == 25 { break }
                        }
                        debugPrint(albumList)
                        completion(albumList,true)
                    }
                } catch {
                    debugPrint("Error to decode")
                }
            } else {
                completion(nil,false)
            }
        }
    }
}
