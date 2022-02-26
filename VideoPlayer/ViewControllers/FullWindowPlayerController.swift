//
//  FullWindowPlayerController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import UIKit
import AVFoundation
import AVKit

final class FullWindowPlayerController: UIViewController {
    
    // MARK: - Private var
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        l.textColor = .red
        l.textAlignment = .center
        l.text = "FullWindowPlayerController"
        return l
    }()
    
    private lazy var playButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        b.setTitle("Play video in full window", for: .normal)
        b.setTitleColor(.blue, for: .normal)
        b.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Public var
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(playButton)
        
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "FullWindowPlayerController", image: nil, selectedImage: nil)
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
            
            playButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            playButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            playButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func playVideo() {
        guard let path = Bundle.main.path(forResource: "Video1", ofType:".mov") else {
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
