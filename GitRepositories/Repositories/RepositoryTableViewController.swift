//
//  RepositoryTableViewController.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 04/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import UIKit

class RepositoryTableViewController: UITableViewController {
    
    var viewModel: RepositoryViewModel = RepositoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTable()

    }

    func loadTable() {
        viewModel.updateData { success in
            if !success {
                print(self.viewModel.getError())
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getListData().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoriesCell", for: indexPath)
        
        if let repositoryCell = cell as? RepositoryTVCell {
            repositoryCell.labelName.text = viewModel.getListData()[indexPath.row].name
            repositoryCell.labelLanguage.text = viewModel.getListData()[indexPath.row].language

            if let stars = viewModel.getListData()[indexPath.row].stars {
                if stars > 999 {
                    let numberString: String = String(stars)
                    let numStart = Int(numberString.prefix(3))
                    repositoryCell.labelNumStar.text = "\(numStart!)+"
                } else {
                    repositoryCell.labelNumStar.text = stars.description
                }
            }

            if let forks = viewModel.getListData()[indexPath.row].forks {
                
                if forks > 999 {
                    let numberString: String = String(forks)
                    let numForks = Int(numberString.prefix(3))!
                    repositoryCell.labelNumForks.text = "\(numForks)+"
                } else {
                    repositoryCell.labelNumForks.text = forks.description
                }
            }
            return repositoryCell
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemSelect = viewModel.getListData()[indexPath.row]
        if let fullRepository = itemSelect.fullname {
            performSegue(withIdentifier: "pullRequests", sender: fullRepository)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pullRequests" {
            if let destinationTVC = segue.destination as? PullRequestTableViewController {
                if let repository = sender as? String {
                    destinationTVC.pullVM = PullRequestViewModel(repository: repository)
                    self.present(destinationTVC, animated: true, completion: nil)
                }
            }
        }
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let actual = scrollView.contentOffset.y
        let height = scrollView.contentSize.height - self.tableView.frame.size.height
        if actual >= height {
            print("desce")
            loadTable()
        }

    }

}
