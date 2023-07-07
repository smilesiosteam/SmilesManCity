//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 06/07/2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import SmilesUtilities
import AVKit
import AVFoundation

public class ManCityVideoPlayerViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - PROPERTIES -
    public var videoUrl: String?
    public var welcomeTitle: String?
    var youtubeId: String?
    
    // MARK: - LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        youtubePlayerView.stopVideo()
        youtubePlayerView = nil
    }
    
    // MARK: - ACTIONS -
    @IBAction func playButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.playVideo()
        }
    }
    
    // MARK: - METHODS -
    func initialSetup() {
        self.youtubeId = AppCommonMethods.extractYoutubeId(fromLink: videoUrl ?? "")
        thumbnailImageView.setImageWithUrlString(self.youtubeId ?? "", backgroundColor: .systemGray5) { image in
            if let image {
                self.thumbnailImageView.image = image
            }
        }
        
        self.welcomeTitleLabel.text = welcomeTitle
    }
    
    func playVideo() {
        thumbnailImageView.isHidden = true
        playButton.isHidden = true
        
        if let videoUrl = URL(string: self.videoUrl ?? "") {
            if videoUrl.absoluteString.contains("youtube.com") || videoUrl.absoluteString.contains("youtu.be") {
                // do something here
                youtubePlayerView.load(withVideoId: self.youtubeId ?? "", playerVars: ["origin": "http://www.youtube.com", "autoplay": 1, "playsinline": 1, "showinfo": 1, "rel" : 0])
                youtubePlayerView.delegate = self
            } else {
                let player = AVPlayer(url: videoUrl as URL)
                
                let playerLayer  = AVPlayerLayer(player: player)
                self.view.layer.addSublayer(playerLayer)
                playerLayer.frame = self.view.frame
                
                player.play()
            }
        }
    }
}

extension ManCityVideoPlayerViewController: YTPlayerViewDelegate {
    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
