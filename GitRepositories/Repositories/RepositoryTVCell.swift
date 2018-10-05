//
//  RepositoryTVCell.swift
//  GitRepositories
//
//  Created by Luiz Fernando on 04/10/18.
//  Copyright © 2018 Luiz Fernando. All rights reserved.
//

import Foundation
import UIKit

class RepositoryTVCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageLock: UIImageView!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var imageStar: UIImageView!
    @IBOutlet weak var labelNumStar: UILabel!
    @IBOutlet weak var imageFork: UIImageView!
    @IBOutlet weak var labelNumForks: UILabel!
}
