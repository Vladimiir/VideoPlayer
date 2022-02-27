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
    
    private var player: AVPlayer = {
        let path = Bundle.main.path(forResource: "Video2", ofType:".mov")
        let p = AVPlayer(url: URL(fileURLWithPath: path ?? ""))
        return p
    }()
    
    private var timeObserverToken: Any?
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerItemFastForwardObserver: NSKeyValueObservation?
    private var playerItemReverseObserver: NSKeyValueObservation?
    private var playerItemFastReverseObserver: NSKeyValueObservation?
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    
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
        switch player.timeControlStatus {
        case .playing:
            player.pause()
        case .paused:
            let currentItem = player.currentItem
            if currentItem?.currentTime() == currentItem?.duration {
                currentItem?.seek(to: .zero, completionHandler: nil)
            }

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
    
    private func setupPlayerObservers() {
        /*
         Create an observer to toggle the play/pause button control icon to
         reflect the playback state of the player's `timeControStatus` property.
         */
        playerTimeControlStatusObserver = player.observe(\AVPlayer.timeControlStatus,
                                                         options: [.initial, .new]) { [unowned self] _, _ in
            DispatchQueue.main.async {
//                self.setPlayPauseButtonImage()
            }
        }

        /*
         Create a periodic observer to update the movie player time slider
         during playback.
         */
        let interval = CMTime(value: 1, timescale: 2)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval,
                                                           queue: .main) { [unowned self] time in
//            let timeElapsed = Float(time.seconds)
//            self.timeSlider.value = timeElapsed
//            self.startTimeLabel.text = self.createTimeString(time: timeElapsed)
        }

        /*
         Create an observer on the player's `canPlayFastForward` property to
         set the fast forward button enabled state.
         */
        playerItemFastForwardObserver = player.observe(\AVPlayer.currentItem?.canPlayFastForward,
                                                       options: [.new, .initial]) { [unowned self] player, _ in
            DispatchQueue.main.async {
//                self.fastForwardButton.isEnabled = player.currentItem?.canPlayFastForward ?? false
            }
        }

        playerItemReverseObserver = player.observe(\AVPlayer.currentItem?.canPlayReverse,
                                                   options: [.new, .initial]) { [unowned self] player, _ in
            DispatchQueue.main.async {
//                self.rewindButton.isEnabled = player.currentItem?.canPlayReverse ?? false
            }
        }

        playerItemFastReverseObserver = player.observe(\AVPlayer.currentItem?.canPlayFastReverse,
                                                       options: [.new, .initial]) { [unowned self] player, _ in
            DispatchQueue.main.async {
//                self.rewindButton.isEnabled = player.currentItem?.canPlayFastReverse ?? false
            }
        }
        
        /*
         Create an observer on the player item `status` property to observe
         state changes as they occur. The `status` property indicates the
         playback readiness of the player item. Associating a player item with
         a player immediately begins enqueuing the item’s media and preparing it
         for playback, but you must wait until its status changes to
         `.readyToPlay` before it’s ready for use.
         */
        playerItemStatusObserver = player.observe(\AVPlayer.currentItem?.status, options: [.new, .initial]) { [unowned self] _, _ in
            DispatchQueue.main.async {
                /*
                 Configure the user interface elements for playback when the
                 player item's `status` changes to `readyToPlay`.
                 */
//                self.updateUIforPlayerItemStatus()
            }
        }
    }
    
    // MARK: - Public func
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        playerView.player = player
    }
}
