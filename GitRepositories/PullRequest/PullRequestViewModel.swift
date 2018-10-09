//
//  PullRequestViewModel.swift
//  GitRepositories
//
//  Created by Luiz Fernando dos Santos on 07/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

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

    func getCell(_ at: Int, cell: UITableViewCell) -> UITableViewCell {
        if let cellPR = cell as? PullRequestTVCell {
            cellPR.labelTitle.text = getListData()[at].title
            if let avatar = getListData()[at].user?.avatar {
                cellPR.imageAuthor.kf.setImage(with: URL(string: avatar))
                cellPR.imageAuthor.layer.cornerRadius = cellPR.imageAuthor.frame.width / 2
                cellPR.imageAuthor.layer.masksToBounds = true
            }
            cellPR.labelNome.text = getListData()[at].user?.login
            cellPR.labelData.text = getListData()[at].createdDate
            cellPR.labelBody.text = getListData()[at].body
            return cellPR
        }
        return cell
    }

    func updateData(completion: @escaping(Bool) -> Void) {

        PullRequestService().requestRepositories(fullname: repository) { results in
            switch results {
            case .success(let pr):
                self.savePulls(pr)
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
                print(error)
                for item in self.getRepositoriesFromCoreData() {
                    if self.pullRequestList.contains(where: { inList in
                        return inList.id == item.id
                    }) == false {
                        self.pullRequestList.append(item)
                    }
                    completion(false)
                }
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

    func savePulls(_ list: [PullRequest]) {
        let persistence = PersistenceManager.shared
        list.forEach {
            if !$0.entityCoreData.savedOnCoreData() {
                persistence.saveAnyObject($0.entityCoreData)
            }
        }
    }

    func getRepositoriesFromCoreData() -> [PullRequest] {

        //TODO: check repository
        var coreDataRepositories: [PullRequest] = []
        PullRequestEntity.getAllFromCoreData()?.forEach {
            coreDataRepositories.append(PullRequest.from(coreData: $0))
        }
        return coreDataRepositories
    }
}
