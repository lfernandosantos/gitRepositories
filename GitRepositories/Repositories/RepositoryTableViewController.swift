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

        viewModel.updateData { success in
            if success {
                for item in self.viewModel.getListData() {
                    self.tableView.reloadData()
                }
            }
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
            
            //check if pass 9999+
            if let stars = viewModel.getListData()[indexPath.row].stars {
                if stars > 999 {
                    let numberString: String = String(stars)
                    let numStart = Int(numberString.prefix(3))
                    repositoryCell.labelNumStar.text = "\(numStart!)+"
                } else {
                    repositoryCell.labelNumStar.text = stars.description
                }
            }

            //check if pass 9999+
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


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
