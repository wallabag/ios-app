//
//  UIPodcastSlider.swift
//  wallabag
//
//  Created by maxime marinel on 08/08/2018.
//

import UIKit

class UIPodcastSlider: UISlider {
    func prepare() {
        setThumbImage(UIImage(), for: .normal)
    }

    func displayTick(tick: Int) {
        let x = Int(frame.size.width)
        let tickWith = x / tick
        var xPos = frame.origin.x
        //let pos = CGRect(x: 0, y: -(frame.size.height / 2), width: frame.size.width, height: frame.size.height)
        //let tickView = UIView(frame: pos)
        //tickView.backgroundColor = .red

        for _ in 0...tick {
            let ticker = UIView(frame: CGRect(x: xPos, y: -5, width: 1, height: 10))
            ticker.backgroundColor = .black
            xPos += CGFloat(tickWith)
            insertSubview(ticker, belowSubview: self)
        }

        //insertSubview(tickView, belowSubview: self)
    }
}
