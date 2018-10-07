//
//  PullRequestViewModel.swift
//  GitRepositories
//
//  Created by Luiz Fernando dos Santos on 07/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import UIKit

protocol PullRequestViewModelProtocol {
    func updateData(completion: @escaping(Bool) -> Void)
    func getListData() -> [PullRequest]
    func getError() -> String
}

class PullRequestViewModel: PullRequestViewModelProtocol {

    var pullRequestList: [PullRequest] = []
    var errorData: String = "Generic error!"
    let repository: String

    init(repository: String) {
        self.repository = repository
    }

    func updateData(completion: @escaping(Bool) -> Void) {

        PullRequestService().requestRepositories(fullname: repository) { results in
            switch results {
            case .success(let pr):
                for item in pr {
                    if self.pullRequestList.contains(where: { inList in
                        return inList.id == item.id
                    }) == false {
                        self.pullRequestList.append(item)
                    }
                    completion(true)
                }
                break
            case .failure(let error):

                //                for item in pulls {
                //                    if self.repositoryList.contains(where: { inList in
                //                        return inList.id == item.id
                //                    }) == false {
                //                        self.repositoryList.append(item)
                //                    }
                //                    completion()
                //                }
                //get from CoreData
                print(error)
                break
            }
        }
    }

    func openInGitub(_ at: Int) {

        let item = pullRequestList[at]
        guard let url = URL(string: item.url!) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func getListData() -> [PullRequest] {
        return pullRequestList
    }

    func getError() -> String {
        return errorData
    }

}
