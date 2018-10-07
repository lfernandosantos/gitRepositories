//
//  RepositoriesViewModel.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 04/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import UIKit

protocol RepositoryViewModelProtocol {
    func updateData(completion: @escaping(Bool) -> Void)
    func getNextData()
    func getListData() -> [Repository]
    func getError() -> String
}

class RepositoryViewModel: RepositoryViewModelProtocol {
    
    var repositoryList: [Repository] = []
    var errorData: String = "Generic error!"
    
    func updateData(completion: @escaping(Bool) -> Void) {
        SearchRepositoriesService().requestRepositories(page: 1) { results in
            switch results {
            case .success(let reposotories):
                for item in reposotories {
                    if self.repositoryList.contains(where: { inList in
                        return inList.id == item.id
                    }) == false {
                        self.repositoryList.append(item)
                    }
                    completion(true)
                }
                break
            case .failure(let error):
                print(error)
//                for item in reposotories {
//                    if self.repositoryList.contains(where: { inList in
//                        return inList.id == item.id
//                    }) == false {
//                        self.repositoryList.append(item)
//                    }
//                    completion()
//                }
                //get from CoreData
                self.errorData = "Check your conection!"
                completion(false)
                break
            }
        }
    }
    
    func getNextData() {
        
    }

    func getListData() -> [Repository] {
        return repositoryList
    }
    
    func getError() -> String {
        return errorData
    }
}
