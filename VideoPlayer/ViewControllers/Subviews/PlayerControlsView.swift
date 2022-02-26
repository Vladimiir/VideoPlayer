//
//  PlayerControlsView.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import UIKit

enum PlayerControl: Int, CaseIterable {
    case skipBack
    case scanBack
    case play
    case scanForward
    case skipForward
    
    var image: UIImage? {
        switch self {
        case .skipBack:
            return UIImage(named: "skip15sec_back")
        case .scanBack:
            return UIImage(named: "scanBackward")
        case .play:
            return UIImage(named: "play")
        case .scanForward:
            return UIImage(named: "scanForward")
        case .skipForward:
            return UIImage(named: "skip15sec_forward")
        }
    }
}

enum PlayerControlsViewOutCmd {
    case playerControlDidPress(PlayerControl)
}

typealias PlayerControlsViewOut = (PlayerControlsViewOutCmd) -> ()

final class PlayerControlsView: UIView {
    
    // MARK: - Private var
    
    private var playerControls: [PlayerControl] = PlayerControl.allCases
    
    // Subviews
    private lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    
    // timeline
    // -15 sec / back / play / forward / +15 sec
    
    private lazy var timelineView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .green
        return v
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.spacing = 15
        v.axis = .horizontal
        v.backgroundColor = .orange
        return v
    }()
    
    // MARK: - Public var
    
    public var out: PlayerControlsViewOut?
    
    // MARK: - Private func
    
    private func setupUI() {
        addSubview(containerView)
        addSubview(timelineView)
        addSubview(buttonsStackView)
        
        clipsToBounds = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            timelineView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timelineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timelineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timelineView.heightAnchor.constraint(equalToConstant: 20),
            
            buttonsStackView.topAnchor.constraint(equalTo: timelineView.bottomAnchor, constant: 5),
            buttonsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonsStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupStackView() {
        playerControls.forEach {
            let button = UIButton.systemButton(with: $0.image!,
                                               target: self,
                                               action: #selector(controlButtonDidPres(_:)))
            button.setImage($0.image, for: .normal)
            button.tag = $0.rawValue
            buttonsStackView.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 50),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    @objc private func controlButtonDidPres(_ button: UIButton) {
        let playerControl = PlayerControl(rawValue: button.tag)!
        out?(.playerControlDidPress(playerControl))
    }
    
    // MARK: - Public func
    
    // MARK: - Life cycle
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
