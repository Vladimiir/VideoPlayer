//
//  PlayerCVCell.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 27.02.2022.
//

import UIKit

final class PlayerCVCell: UICollectionViewCell {
    
    // MARK: - Public var
    
    // Subviews
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .black
        l.textAlignment = .center
        return l
    }()
    
    lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.numberOfLines = 0
        l.textColor = .black
        l.textAlignment = .center
        l.setContentHuggingPriority(.required, for: .vertical)
        return l
    }()
    
    // MARK: - Public func
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
