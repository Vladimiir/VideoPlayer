//
//  TabBarController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    private var fullWindowPlayer = FullWindowPlayerController()
    private var avPlayerLayer = AVPlayerLayerViewController()
    private var secondPlayer = SecondPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([fullWindowPlayer,
                            avPlayerLayer,
                            secondPlayer],
                           animated: false)
        selectedIndex = 0
    }
}
