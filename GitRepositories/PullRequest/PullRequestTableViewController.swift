//
//  PullRequestTableViewController.swift
//  GitRepositories
//
//  Created by Luiz Fernando dos Santos on 07/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import UIKit

class PullRequestTableViewController: UITableViewController {

    var pullVM: PullRequestViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        pullVM.updateData { success in
            if !success {
                print(self.pullVM.getError())
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullVM.getListData().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pullCell", for: indexPath)
        return pullVM.getCell(indexPath.row, cell: cell)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pullVM.openInGitub(indexPath.row)
    }

}
