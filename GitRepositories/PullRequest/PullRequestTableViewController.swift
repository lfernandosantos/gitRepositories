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
            if success {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullVM.getListData().count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pullCell", for: indexPath)

        if let cellPR = cell as? PullRequestTVCell {
            cellPR.labelTitle.text = pullVM.getListData()[indexPath.row].title
            cellPR.labelNome.text = pullVM.getListData()[indexPath.row].user?.login
            cellPR.labelData.text = pullVM.getListData()[indexPath.row].createdDate
            cellPR.labelBody.text = pullVM.getListData()[indexPath.row].body

            return cellPR
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pullVM.openInGitub(indexPath.row)
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
