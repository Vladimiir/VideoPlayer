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
    
    private var allAssets: PHFetchResult<PHAsset>? = nil
    
    //    private var player: AVPlayer = {
    //        let path = Bundle.main.path(forResource: "Video2", ofType:".mov")
    //        let p = AVPlayer(url: URL(fileURLWithPath: path ?? ""))
    //        return p
    //    }()
    
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
        //        v.out = { [weak self] event in
        //            guard let self = self else { return }
        //
        //            switch event {
        //            case .playerControlDidPress(let playerControl): break
        //                switch playerControl {
        //                case .skipBack:
        //                    self.skipBackward()
        //                case .scanBack:
        //                    self.playBackwards()
        //                case .play, .pause:
        //                    self.playVideo()
        //                case .scanForward:
        //                    self.playFastForward()
        //                case .skipForward:
        //                    self.skipForward()
        //                }
        //            case .sliderDidMove(let time):
        //                self.player.seek(to: time)
        //            case .sliderDidBegan(let isBegan):
        //                if isBegan {
        //                    self.isSliderMoving = true
        //                    self.player.pause()
        //                } else {
        //                    self.isSliderMoving = false
        //                    self.player.play()
        //                }
        //            }
        //        }
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
        
        title = "AVKit & PhotoGallery"
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
    
    @objc private func openGallery() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                allAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
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
    }
}
