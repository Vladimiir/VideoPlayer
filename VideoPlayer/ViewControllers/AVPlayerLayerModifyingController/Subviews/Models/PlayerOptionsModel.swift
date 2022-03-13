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
}

enum PlaybackControl: Int, CaseIterable {
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
}

enum EditorControl: Int, CaseIterable {
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
}

enum EffectsControl: Int, CaseIterable {
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
