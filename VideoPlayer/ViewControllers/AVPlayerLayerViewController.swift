//
//  AVPlayerLayerViewController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import UIKit
import AVFoundation
import AVKit

final class AVPlayerLayerViewController: UIViewController {
    
    // MARK: - Private var
    
    private var player = AVPlayer()
    
    private lazy var playerView: PlayerView = {
        let v = PlayerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        return v
    }()
    
    private lazy var playerControlsView: PlayerControlsView = {
        let v = PlayerControlsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.out = { [weak self] event in
            switch event {
            case .playerControlDidPress(let playerControl):
                switch playerControl {
                case .skipBack:
                    print("skipBack")
                case .scanBack:
                    print("scanBack")
                case .play:
                    self?.playVideo()
                case .scanForward:
                    print("scanForward")
                case .skipForward:
                    print("skipForward")
                }
            }
        }
        return v
    }()
    
    // MARK: - Public var
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(playerView)
        view.addSubview(playerControlsView)
        
        title = "AVPlayerLayer"
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            
            playerControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerControlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "Video2", ofType:".mov") else {
            debugPrint("Video1.mov not found")
            return
        }
        
        playerView.player = AVPlayer(url: URL(fileURLWithPath: path))
        player = playerView.player!

        // TODO: timeControlStatus not changing, probably I need observers
        switch player.timeControlStatus {
        case .playing:
            // If the player is currently playing, pause it.
            player.pause()
        case .paused:
            /*
             If the player item already played to its end time, seek back to
             the beginning.
             */
            let currentItem = player.currentItem
            if currentItem?.currentTime() == currentItem?.duration {
                currentItem?.seek(to: .zero, completionHandler: nil)
            }
            // The player is currently paused. Begin playback.
            player.play()
        default:
            player.pause()
        }
    }
    
//    func setPlayPauseButtonImage() {
//        var buttonImage: UIImage?
//
//        switch self.player.timeControlStatus {
//        case .playing:
//            buttonImage = UIImage(named: PlayerViewController.pauseButtonImageName)
//        case .paused, .waitingToPlayAtSpecifiedRate:
//            buttonImage = UIImage(named: PlayerViewController.playButtonImageName)
//        @unknown default:
//            buttonImage = UIImage(named: PlayerViewController.pauseButtonImageName)
//        }
//        guard let image = buttonImage else { return }
//        self.playPauseButton.setImage(image, for: .normal)
//    }
    
    // MARK: - Public func
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
}
