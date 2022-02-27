//
//  PlayersListViewController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 27.02.2022.
//

import UIKit

enum PlayerType: String {
    case avPlayerVC = "FullWindowPlayerController"
    case avPlayerLayer = "AVPlayerLayerViewController"
}

final class PlayersListViewController: UIViewController {
    
    // MARK: - Private var
    
    private var players: [PlayerType] = [.avPlayerVC,
                                         .avPlayerLayer]
    
    private lazy var fullWindowPlayerVC = FullWindowPlayerController()
    private lazy var avPlayerLayerVC = AVPlayerLayerViewController()
    
    private var collectionViewLayout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = .init(width: UIScreen.main.bounds.width - 40, height: 80)
        l.scrollDirection = .vertical
        l.minimumLineSpacing = 10
        return l
    }()
    
    // Subviews
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = .init(top: 40, left: 0, bottom: 40, right: 0)
        return cv
    }()
    
    // MARK: - Public var
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        title = "Players list"
        view.backgroundColor = .white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22,
                                                                                            weight: .semibold),
                                                                   .foregroundColor: UIColor.red,
                                                                   .paragraphStyle: paragraphStyle]
        
        collectionView.register(PlayerCVCell.self, forCellWithReuseIdentifier: "PlayerCellIdentifier")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Public func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
}

extension PlayersListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let player = players[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCellIdentifier",
                                                      for: indexPath) as! PlayerCVCell
        
        cell.titleLabel.text = player.rawValue
        
        return cell
    }
}

extension PlayersListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        switch players[indexPath.row] {
        case .avPlayerVC:
            navigationController?.pushViewController(fullWindowPlayerVC, animated: true)
        case .avPlayerLayer:
            navigationController?.pushViewController(avPlayerLayerVC, animated: true)
        }
        
        navigationItem.backButtonTitle = ""
    }
}
