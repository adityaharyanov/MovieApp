//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MovieDetailViewController : UIViewController, UICollectionViewDelegateFlowLayout {

    let viewModel = MovieDetailViewModel()
    
    //IBOutlets
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRateTotal: UILabel!
    @IBOutlet weak var collectionViewGenres: UICollectionView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var collectionViewTrailerVideos: UICollectionView!
    @IBOutlet weak var lblDisplayedReview: UILabel!
    @IBOutlet weak var lblDisplayedReviewAuthor: UILabel!
    @IBOutlet weak var btnSeeAllReviews: UIButton!
    @IBOutlet weak var baseReviewFound: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        
        // Do any additional setup after loading the view.
        
        self.imgPoster.layer.cornerRadius = 8.0
        
        self.viewModel.isLoading
            .bind(to: self.scrollView.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.posterUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { value in
                self.imgPoster.kf.setImage(with: URL(string: value ))
            })
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.title
            .do(onNext: { self.navigationItem.title = $0 })
            .bind(to: self.lblTitle.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.rateAvg
            .bind(to: self.lblRating.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.rateTotal
            .bind(to: self.lblRateTotal.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.releaseDate
            .bind(to: self.lblReleaseDate.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.overview
            .bind(to: self.lblOverview.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.displayedReviewContent
            .bind(to: self.lblDisplayedReview.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.displayedReviewAuthor
            .bind(to: self.lblDisplayedReviewAuthor.rx.text)
            .disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.trailerVideos
            .map({ $0.isEmpty })
            .bind(to: collectionViewTrailerVideos.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)
        
        let isReviewFound = self.viewModel.displayedReviewContent
            .map({ $0.isEmpty })
            
        isReviewFound
            .bind(to: self.baseReviewFound.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)
        
        isReviewFound
            .bind(to: self.btnSeeAllReviews.rx.isHidden)
            .disposed(by: self.viewModel.disposeBag)

        self.viewModel.genres.bind(to: collectionViewGenres.rx.items(cellIdentifier: GenreCell.Id, cellType: GenreCell.self)) { (row,item,cell) in
            cell.contentView.layer.cornerRadius = (cell.contentView.bounds.height / 2)
                cell.lblName.text = item
            }.disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.trailerVideos.bind(to: collectionViewTrailerVideos.rx.items(cellIdentifier: VideoCell.Id, cellType: VideoCell.self)) { (row,item,cell) in
                cell.imgThumbnail.kf.setImage(with: URL(string: "http://img.youtube.com/vi/\(item.key)/0.jpg"))
                
                cell.btnPlayVideo.rx.controlEvent(.touchUpInside)
                    .map({ item.key })
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { videoKey in
                        self.gotoVideoPlayer(videoKey: videoKey)
                    }).disposed(by: self.viewModel.disposeBag)
                
            }.disposed(by: self.viewModel.disposeBag)
        
        self.btnSeeAllReviews.rx.controlEvent(.touchUpInside)
            .compactMap({ self.viewModel.movie })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { movie in
                self.gotoMovieReviewList(selectedMovie: movie)
            }).disposed(by: self.viewModel.disposeBag)
        
        self.viewModel.getMovie(error: self.showErrorAlert(message:))
    }
    
    func gotoVideoPlayer(videoKey: String) {
        
        let nextVC = VideoPlayerViewController.createInstance() as! VideoPlayerViewController
        nextVC.videoId = videoKey
        nextVC.newTitle = self.navigationItem.title ?? "Video Player"
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func gotoMovieReviewList(selectedMovie: Movie) {
        
        let nextVC = MovieReviewListViewController.createInstance() as! MovieReviewListViewController
        nextVC.viewModel.selectedMovie.accept(selectedMovie)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
