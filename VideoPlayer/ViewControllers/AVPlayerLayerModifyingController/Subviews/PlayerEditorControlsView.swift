//
//  PlayerEditorControlsView.swift
//  VideoPlayer
//
//  Created by Стасенко Владимир on 07.03.2022.
//

import UIKit
import AVFoundation

enum PlayerOptionsEditorControl: Int, CaseIterable {
    case playback
    case editor
    case effects
    
    var title: String {
        switch self {
        case .playback:
            return "Playback"
        case .editor:
            return "Editor"
        case .effects:
            return "Effects"
        }
    }
}

enum PlayerPlaybackEditorControl: Int, CaseIterable {
    case skipInitBack
    case scanBack
    case play
    case pause
    case scanForward
    case skipInitForward
    
    var image: UIImage? {
        switch self {
        case .skipInitBack:
            return UIImage(named: "skipInitBack")
        case .scanBack:
            return UIImage(named: "scanBackward")
        case .play:
            return UIImage(named: "play")
        case .pause:
            return UIImage(named: "pause")
        case .scanForward:
            return UIImage(named: "scanForward")
        case .skipInitForward:
            return UIImage(named: "skipInitForward")
        }
    }
}

enum PlayerEditorControlsViewOutCmd {
    case playerControlDidPress(PlayerPlaybackEditorControl)
    case sliderDidMove(CMTime)
    case sliderDidBegan(Bool)
}

typealias PlayerEditorControlsViewOut = (PlayerControlsViewOutCmd) -> ()

final class PlayerEditorControlsView: UIView {
    
    // MARK: - Private var
    
    private var optionControls: [PlayerOptionsEditorControl] = [.playback,
                                                                .editor,
                                                                .effects]
    private var playerControls: [PlayerPlaybackEditorControl] = [.skipInitBack,
                                                                 .scanBack,
                                                                 .play,
                                                                 .scanForward,
                                                                 .skipInitForward]
    private var playPauseButton: UIButton!
    
    // Subviews
    private lazy var containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        return v
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.distribution = .fillEqually
        v.spacing = 15
        v.axis = .horizontal
        return v
    }()
    
    private lazy var timelineSlider: UISlider = {
        var slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(timeSliderDidChange(_:event:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var timelineCurrentPositionLabel: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12, weight: .light)
        l.textColor = .black
        l.textAlignment = .center
        l.text = "0:12"
        return l
    }()
    
    private lazy var timelineDurationLabel: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 12, weight: .light)
        l.textColor = .black
        l.textAlignment = .center
        l.text = "1:34"
        return l
    }()
    
    private lazy var playbackButtonsStackView: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.spacing = 15
        v.axis = .horizontal
        return v
    }()
    
    // MARK: - Public var
    
    public var out: PlayerControlsViewOut?
    public var isPlaying: Bool = false {
        didSet {
            let playButtonImage = isPlaying ?
            PlayerPlaybackEditorControl.pause.image :
            PlayerPlaybackEditorControl.play.image
            playPauseButton.setImage(playButtonImage, for: .normal)
        }
    }
    
    // MARK: - Private func
    
    private func setupUI() {
        addSubview(containerView)
        addSubview(buttonsStackView)
        addSubview(timelineSlider)
        addSubview(timelineCurrentPositionLabel)
        addSubview(timelineDurationLabel)
        addSubview(playbackButtonsStackView)
        
        clipsToBounds = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            timelineSlider.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
            timelineSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timelineSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timelineSlider.heightAnchor.constraint(equalToConstant: 20),
            
            timelineCurrentPositionLabel.topAnchor.constraint(equalTo: timelineSlider.bottomAnchor,
                                                              constant: 5),
            timelineCurrentPositionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor,
                                                                  constant: 5),
            timelineCurrentPositionLabel.bottomAnchor.constraint(equalTo: playbackButtonsStackView.topAnchor),
            timelineCurrentPositionLabel.trailingAnchor.constraint(equalTo: centerXAnchor,
                                                                   constant: 0),
            
            timelineDurationLabel.topAnchor.constraint(equalTo: timelineSlider.bottomAnchor,
                                                       constant: 5),
            timelineDurationLabel.leadingAnchor.constraint(equalTo: centerXAnchor,
                                                           constant: 0),
            timelineDurationLabel.bottomAnchor.constraint(equalTo: playbackButtonsStackView.topAnchor),
            timelineDurationLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                                            constant: -5),
            
            playbackButtonsStackView.topAnchor.constraint(equalTo: timelineSlider.bottomAnchor,
                                                          constant: 5),
            playbackButtonsStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            playbackButtonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            playbackButtonsStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            playbackButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupOptionsStackView() {
        optionControls.forEach {
            let button = UIButton(type: .system)
            button.tag = $0.rawValue
            button.setTitle($0.title, for: .normal)
            buttonsStackView.addArrangedSubview(button)
        }
    }
    
    private func setupPlaybackStackView() {
        playerControls.forEach {
            let button = UIButton.systemButton(with: $0.image!,
                                               target: self,
                                               action: #selector(controlButtonDidPress(_:)))
            if $0 == .play {
                playPauseButton = button
            }
            button.setImage($0.image, for: .normal)
            button.tag = $0.rawValue
            playbackButtonsStackView.addArrangedSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 50),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    // MARK: - Actions
    
    @objc private func controlButtonDidPress(_ button: UIButton) {
        let playerControl = PlayerControl(rawValue: button.tag)!
        out?(.playerControlDidPress(playerControl))
    }
    
    @objc private func timeSliderDidChange(_ sender: UISlider, event: UIEvent) {
        guard let touch = event.allTouches?.first else { return }
        
        switch touch.phase {
        case .began:
            out?(.sliderDidBegan(true))
        case .moved:
            let newTime = CMTime(seconds: Double(sender.value), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            out?(.sliderDidMove(newTime))
        case .ended:
            out?(.sliderDidBegan(false))
        default: break
        }
    }
    
    // MARK: - Public func
    
    public func setTimeSlider(value: Float) {
        timelineSlider.setValue(value, animated: true)
    }
    
    public func setTimeSlider(currentPosition: Float) {
        timelineCurrentPositionLabel.text = TimeFormatter.formateSecondsToMS(currentPosition)
    }
    
    public func setTimeSlider(duration: Float) {
        timelineSlider.maximumValue = duration
        timelineDurationLabel.text = TimeFormatter.formateSecondsToMS(duration)
    }
    
    public func setControls(enabled: Bool) {
        timelineSlider.isEnabled = enabled
        playbackButtonsStackView.subviews.forEach {
            let button = $0 as! UIButton
            button.isEnabled = enabled
        }
    }
    
    // MARK: - Life cycle
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
        setupOptionsStackView()
        setupPlaybackStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}