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
    
    // MARK: - Public func
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
