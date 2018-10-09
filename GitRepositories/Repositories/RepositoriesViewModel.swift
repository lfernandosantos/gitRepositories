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
            case .success(let repositories):
                self.saveRepositories(repositories)
                self.nextPage()
                for item in repositories {
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
                for item in self.getRepositoriesFromCoreData() {
                    if self.repositoryList.contains(where: { inList in
                        return inList.id == item.id
                    }) == false {
                        self.repositoryList.append(item)
                    }
                    completion(false)
                }

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

    func saveRepositories(_ list: [Repository]) {
        let persistence = PersistenceManager.shared
        list.forEach {
            if !$0.entityCoreData.savedOnCoreData() {
                persistence.saveAnyObject($0.entityCoreData)
            }
        }
    }

    func getRepositoriesFromCoreData() -> [Repository] {
        var coreDataRepositories: [Repository] = []
        RepositoryEntity.getAllFromCoreData()?.forEach {
            coreDataRepositories.append(Repository.from(coreData: $0))
        }
        return coreDataRepositories
    }

}
