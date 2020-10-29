//
//  GenreListViewController.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import UIKit
import RxSwift

class GenreListViewController : UIViewController {
    
    let viewModel = GenreListViewModel()
    
    //IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.backButtonTitle = ""
        
        self.tableView.rowHeight = UITableView.automaticDimension
               
        self.viewModel.isLoading
            .bind(to: self.tableView.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)
        
        
        self.viewModel.genres
            .bind(to: tableView.rx.items(cellIdentifier: "GenreCell")) { (row,item,cell) in
                cell.textLabel?.text = item.name
            }.disposed(by: self.viewModel.disposeBag)
        
        self.tableView.rx
            .modelSelected(Genre.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.gotoMovieList(selectedGenre: value)
            }).disposed(by: self.viewModel.disposeBag)
        
        viewModel.getGenres(error: self.showErrorAlert(message:))
    }
    
    func gotoMovieList(selectedGenre: Genre) {
        
        
        let nextVC = MovieListViewController.createInstance() as! MovieListViewController
        nextVC.viewModel.selectedGenre.accept(selectedGenre)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
