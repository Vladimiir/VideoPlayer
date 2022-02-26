//
//  PlayerControlsView.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import UIKit

final class PlayerControlsView: UIView {
    
    private lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        v.layer.cornerRadius = 15
        return v
    }()
    
    // timeline
    // -15 sec / back / play / forward / +15 sec
    
    
}
