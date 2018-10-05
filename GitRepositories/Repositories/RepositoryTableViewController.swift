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
                    print(item.name)
                    self.tableView.reloadData()
                    
                }
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.getListData().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoriesCell", for: indexPath)
        
        if let repositoryCell = cell as? RepositoryTVCell {
            repositoryCell.labelName.text = viewModel.getListData()[indexPath.row].name
            repositoryCell.labelLanguage.text = viewModel.getListData()[indexPath.row].language
            //check if pass 9999+
            repositoryCell.labelNumStar.text = viewModel.getListData()[indexPath.row].stars?.description
            //check if pass 9999+
            repositoryCell.labelNumForks.text = viewModel.getListData()[indexPath.row].forks?.description
            return repositoryCell
        }

        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
