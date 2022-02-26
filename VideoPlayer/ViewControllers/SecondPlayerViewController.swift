//
//  SecondPlayerViewController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import UIKit

final class SecondPlayerViewController: UIViewController {
    
    // MARK: - Private var
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        l.textColor = .red
        l.textAlignment = .center
        l.text = "AVKit & CoreVideo"
        return l
    }()
    
    // MARK: - Public var
    
    // MARK: - Private func
    
    private func setupUI() {
        view.addSubview(titleLabel)
        
        view.backgroundColor = .white
        tabBarItem = UITabBarItem(title: "AVKit & CoreVideo", image: nil, selectedImage: nil)
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
        ])
    }
    
    // MARK: - Public func
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
    }
}