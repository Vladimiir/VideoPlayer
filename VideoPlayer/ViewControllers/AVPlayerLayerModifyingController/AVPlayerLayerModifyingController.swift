//
//  AVPlayerLayerModifyingController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import UIKit
import Photos

final class AVPlayerLayerModifyingController: UIViewController {
    
    // MARK: - Private var
    
    private var player = AVPlayer()
    
    private var timeObserverToken: Any?
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    private var playerItemStatusObserver: NSKeyValueObservation?
    
    private var isSliderMoving = false
    
    // Subviews
    
    private lazy var playerView: PlayerView = {
        let v = PlayerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        return v
    }()
    
    private lazy var playerEditorControlsView: PlayerEditorControlsView = {
        let v = PlayerEditorControlsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.out = { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .playerControlDidPress(let playerControl):
                switch playerControl {
                case .skipInitBack:
                    self.skipInitBackward()
                case .scanBack:
                    self.playBackwards()
                case .play, .pause:
                    self.playVideo()
                case .scanForward:
                    self.playFastForward()
                case .skipInitForward:
                    self.skipInitForward()
                }
            case .sliderDidMove(let time):
                self.player.seek(to: time)
            case .sliderDidBegan(let isBegan):
                if isBegan {
                    self.isSliderMoving = true
                    self.player.pause()
                } else {
                    self.isSliderMoving = false
                    self.player.play()
                }
            }
        }
        return v
    }()
    
    private lazy var galleryButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        b.setTitle("Выбрать видео", for: .normal)
        b.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Public var
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(playerView)
        view.addSubview(galleryButton)
        view.addSubview(playerEditorControlsView)
        
        title = "AVPlayerLayer & PhotoGallery"
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            
            galleryButton.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 10),
            galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playerEditorControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerEditorControlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerEditorControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupPlayer() {
        playerView.player = player
        setupPlayerObservers()
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
    
    func updatePlayPauseButtonImage() {
        switch player.timeControlStatus {
        case .playing:
            playerEditorControlsView.isPlaying = true
        default:
            playerEditorControlsView.isPlaying = false
        }
    }
    
    private func setupPlayerObservers() {
        // Create a periodic observer to update the movie player time slider during playback.
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval,
                                                           queue: .main) { [unowned self] time in
            let timeElapsed = Float(time.seconds)
            if !isSliderMoving {
                self.playerEditorControlsView.setTimeSlider(value: timeElapsed)
            }
            self.playerEditorControlsView.setTimeSlider(currentPosition: timeElapsed)
        }
        
        // Create an observer to toggle the play/pause button control icon
        // to reflect the playback state of the player's `timeControStatus` property.
        playerTimeControlStatusObserver = player.observe(\AVPlayer.timeControlStatus,
                                                          options: [.initial, .new]) { [unowned self] _, _ in
            DispatchQueue.main.async {
                self.updatePlayPauseButtonImage()
            }
        }
        
        // Create an observer on the player item `status` property to observe state changes as they occur.
        playerItemStatusObserver = player.observe(\AVPlayer.currentItem?.status,
                                                   options: [.new, .initial]) { [unowned self] _, _ in
            DispatchQueue.main.async {
                // Configure the user interface elements for playback when
                // the player item's `status` changes to `readyToPlay`.
                self.updateUIforPlayerItemStatus()
            }
        }
    }
    
    private func skipInitForward() {
        guard let endDuration = self.player.currentItem?.duration else { return }
        
        let time = CMTime(seconds: CMTimeGetSeconds(endDuration),
                          preferredTimescale: 1)
        self.player.seek(to: time, completionHandler: { _ in })
    }
    
    private func skipInitBackward() {
        let time = CMTime(seconds: .zero,
                          preferredTimescale: 1)
        self.player.seek(to: time, completionHandler: { _ in })
    }
    
    private func playFastForward() {
        if player.currentItem?.currentTime() == player.currentItem?.duration {
            player.currentItem?.seek(to: .zero, completionHandler: { _ in })
        }
        
        // Play fast forward no faster than 2.0.
        player.rate = min(player.rate + 2.0, 2.0)
    }
    
    private func playBackwards() {
        if player.currentItem?.currentTime() == .zero {
            if let duration = player.currentItem?.duration {
                player.currentItem?.seek(to: duration, completionHandler: { _ in })
            }
        }
        
        // Reverse no faster than -2.0.
        player.rate = max(player.rate - 2.0, -2.0)
    }
    
    private func updateUIforPlayerItemStatus() {
        guard let currentItem = player.currentItem else { return }
        
        switch currentItem.status {
        case .failed:
            playerEditorControlsView.setControls(enabled: false)
            break
            
        case .readyToPlay:
            playerEditorControlsView.setControls(enabled: true)
            
            // Update the time slider control, start time and duration labels for the player duration.
            let duration = Float(currentItem.duration.seconds)
            let currentPosition = Float(CMTimeGetSeconds(player.currentTime()))
            playerEditorControlsView.setTimeSlider(currentPosition: currentPosition)
            playerEditorControlsView.setTimeSlider(duration: duration)
            
        default:
            playerEditorControlsView.setControls(enabled: false)
            break
        }
    }
    
    func getUrlFromPHAsset(_ asset: PHAsset,
                           completion: @escaping (_ url: URL?) -> Void) {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(),
                                         completionHandler: { (contentEditingInput, dictInfo) in
            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString {
                completion(URL(string: strURL))
            }
        })
    }
    
    // MARK: - Actions
    
    @objc private func openGallery() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let allVideosAssets = PHAsset.fetchAssets(with: .video, options: PHFetchOptions())
                
                DispatchQueue.main.async {
                    self.present(GalleryAssetsList(assets: allVideosAssets,
                                                   out: { cmd in
                        switch cmd {
                        case .assetDidSelect(let asset):
                            self.getUrlFromPHAsset(asset) { url in
                                guard let url = url else { return }
                                
                                self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
                                self.setupPlayer()
                            }
                        }
                    }), animated: true, completion: nil)
                }
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            case .limited:
                print("limited")
            @unknown default:
                print("default")
            }
        }
    }
    
    // MARK: - Public func
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupPlayer()
    }
}
