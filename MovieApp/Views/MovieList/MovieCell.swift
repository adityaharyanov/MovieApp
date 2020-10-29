//
//  MovieCell.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import UIKit

class MovieCell : UITableViewCell {
    
    static let Id = "MovieCell"
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReleaseYear: UILabel!
    
    
}
