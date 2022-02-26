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
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        l.textColor = .red
        l.textAlignment = .center
        l.text = "AVPlayerLayer"
        return l
    }()
    
    private lazy var playerView: PlayerView = {
        let v = PlayerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        return v
    }()
    
    private lazy var playerControlsView: PlayerControlsView = {
        let v = PlayerControlsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        v.layer.cornerRadius = 15
        return v
    }()
    
    // MARK: - Public var
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(playerView)
        view.addSubview(playerControlsView)
        
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "AVPlayerLayer", image: nil, selectedImage: nil)
        let attr: [NSAttributedString.Key : Any]? = [.foregroundColor: UIColor.red]
        tabBarItem.setTitleTextAttributes(attr, for: .normal)
        tabBarItem.setTitleTextAttributes(attr, for: .highlighted)
        tabBarItem.setTitleTextAttributes(attr, for: .selected)
        tabBarItem.setTitleTextAttributes(attr, for: .disabled)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playerView.heightAnchor.constraint(equalToConstant: 200),
            
            playerControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            playerControlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            playerControlsView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc private func playVideo() {
        guard let path = Bundle.main.path(forResource: "Video2", ofType:".mov") else {
            debugPrint("Video1.mov not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
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
