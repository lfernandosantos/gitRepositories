//
//  ViewController.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 01/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchRepositoriesService().requestRepositories(page: 1) { results in
            print("terminou ")
            
            switch results {
            case .success(let reposotories):
                print(reposotories)
                                    
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
        print("pegando pull from Alamofire")
        PullRequestService().requestRepositories(fullname: "Alamofire/Alamofire") { results in
            switch results {
            case .success(let pr):
                pr.forEach {
                    print($0)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
    }


}

