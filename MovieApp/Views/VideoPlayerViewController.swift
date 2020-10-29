//
//  VideoPlayerViewController.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 29/10/20.
//

import Foundation
import UIKit
import YouTubePlayer

class VideoPlayerViewController : UIViewController {
    
    let viewModel = GenreListViewModel()
    var newTitle = ""
    var videoId = ""
    
    //IBOutlet
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = newTitle
        // Do any additional setup after loading the view.
        videoPlayer.loadVideoID(videoId)
    }
    
    
}
