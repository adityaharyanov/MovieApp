//
//  MovieReviewListViewController.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 29/10/20.
//

import Foundation
import UIKit

class MovieReviewListViewController : UIViewController {
    let viewModel = MovieReviewListViewModel()
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.rowHeight = UITableView.automaticDimension
                
        self.viewModel.isLoading
            .map({ (self.viewModel.meta.value == nil) ? $0 : false })
            .bind(to: self.tableView.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.reviews.bind(to: tableView.rx.items(cellIdentifier: MovieReviewCell.Id, cellType: MovieReviewCell.self)) { (row,item,cell) in
                cell.lblAuthor.text = item.author
                cell.lblContent.text = item.content
            }.disposed(by: self.viewModel.disposeBag)
        
        self.tableView.rx.onReachBottomOffset(bottomOffset: 20.0) {
            self.viewModel.getReviews(error: self.showErrorAlert(message:))
        }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.getReviews(error: self.showErrorAlert(message:))
    }
}
