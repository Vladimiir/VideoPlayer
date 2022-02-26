//
//  TabBarController.swift
//  VideoPlayer
//
//  Created by Владимир Стасенко on 26.02.2022.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    private var firstPlayer = FirstPlayerViewController()
    private var secondPlayer = SecondPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([firstPlayer,
                            secondPlayer],
                           animated: false)
        selectedIndex = 0
    }
}
