//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieListViewController : UIViewController {
    
    let viewModel = MovieListViewModel()
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableView.automaticDimension
                
        self.viewModel.isLoading
            .map({ (self.viewModel.meta.value == nil) ? $0 : false })
            .bind(to: self.tableView.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.movies.bind(to: tableView.rx.items(cellIdentifier: MovieCell.Id, cellType: MovieCell.self)) { (row,item,cell) in
                cell.imgPoster.layer.cornerRadius = 5.0
                cell.imgPoster.kf.setImage(with: URL(string: item.posterUrl ))
                cell.lblName.text = item.title
                cell.lblReleaseYear.text = item.releaseDate.get(format: "yyyy") ?? "--"
            }.disposed(by: self.viewModel.disposeBag)
        
        self.tableView.rx
            .modelSelected(Movie.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.gotoMovieDetail(selectedMovie: value)
            }).disposed(by: self.viewModel.disposeBag)
        
        self.tableView.rx.onReachBottomOffset(bottomOffset: 20.0) {
            self.viewModel.getMovies(error: self.showErrorAlert(message:))
        }.disposed(by: self.viewModel.disposeBag)
        
        self.tableView.rx
            .itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.tableView.deselectRow(at: value, animated: true)
            }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.getMovies(error: self.showErrorAlert(message:))
    }
    
    func gotoMovieDetail(selectedMovie: Movie) {
        
        let nextVC = MovieDetailViewController.createInstance() as! MovieDetailViewController
        nextVC.viewModel.movie = selectedMovie
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }

}
