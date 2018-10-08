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
    func nextPage()
    func getListData() -> [Repository]
    func getError() -> String
}

class RepositoryViewModel: RepositoryViewModelProtocol {
    
    var repositoryList: [Repository] = []
    var errorData: String = "Generic error!"
    var totalPages: Int?
    var currentPage: Int = 1
    
    func updateData(completion: @escaping(Bool) -> Void) {
        readTotalPages()
        SearchRepositoriesService().requestRepositories(page: currentPage) { results in
            switch results {
            case .success(let reposotories):
                self.nextPage()
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

    func nextPage() {
        if let totalP = totalPages {
            if currentPage < totalP {
                currentPage += 1
                print(currentPage)
            }
        }
    }

    func getListData() -> [Repository] {
        return repositoryList
    }
    
    func getError() -> String {
        return errorData
    }

    private func readTotalPages() {
//        var userDefaults = UserDefaults.standard
//        totalPages = userDefaults.integer(forKey: "total.pages.notification") ?? 1


        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addTotalPages(_:)),
                                               name: Notification.Name.init(rawValue: "total.pages.notification"),
                                               object: nil)
    }

    @objc private func addTotalPages(_ notification: Notification) {
        if let dict = notification.userInfo {
            let name = notification.name.rawValue
            if name == "total.pages.notification" {
                self.totalPages = dict["total_pages"] as? Int
                NotificationCenter.default.removeObserver(self,
                                                          name: Notification.Name.init(rawValue: "total.pages.notification"),
                                                          object: nil)
            }
        }
    }
}
