//
//  PlayerOptionsModel.swift
//  VideoPlayer
//
//  Created by Стасенко Владимир on 13.03.2022.
//

import UIKit

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
    
    var optionsList: [PlaybackControls] {
        switch self {
        case .playback:
            return PlaybackControl.allCases
        case .editor:
            return EditorControl.allCases
        case .effects:
            return EffectsControl.allCases
        }
    }
}

protocol PlaybackControls {
    var title: String { get }
    var rawVal: Int { get }
}

enum PlaybackControl: Int, CaseIterable, PlaybackControls {
    case slowdown
    case accelerate
    case playBackwards
    
    var title: String {
        switch self {
        case .slowdown:
            return "Slowdown"
        case .accelerate:
            return "Accelerate"
        case .playBackwards:
            return "Play backwards"
        }
    }
    
    var rawVal: Int {
        return rawValue
    }
}

enum EditorControl: Int, CaseIterable, PlaybackControls {
    case trim
    case rotate
    case mirror
    case remove
    
    var title: String {
        switch self {
        case .trim:
            return "Trim"
        case .rotate:
            return "Rotate"
        case .mirror:
            return "Mirror"
        case .remove:
            return "Remove"
        }
    }
    
    var rawVal: Int {
        return rawValue
    }
}

enum EffectsControl: Int, CaseIterable, PlaybackControls {
    case sticker
    case blackAndWhite
    
    var title: String {
        switch self {
        case .sticker:
            return "Sticker"
        case .blackAndWhite:
            return "BlackAndWhite"
        }
    }
    
    var rawVal: Int {
        return rawValue
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
