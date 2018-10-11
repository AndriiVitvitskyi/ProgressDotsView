//
//  DotView.swift
//  BuddeeFramework
//
//  Created by Andrii Vitvitskyi on 10/4/18.
//  Copyright © 2018 buddee fitness. All rights reserved.
//

import UIKit

public enum DotState {
    case finished
    case unfinished
}

open class DotView: UIView {
    
    public var index: Int!
    public var activeColor: UIColor = .green
    public var unActiveColor: UIColor = .gray
    
    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    private let dotView = UIView()

    
    public var height: CGFloat = 0.0 {
        didSet {
            addDots()
        }
    }
    
    public var state: DotState = .unfinished {
        didSet {
            switch state {
            case .finished:
                if #available(iOS 10.0, *) {
                    UIViewPropertyAnimator(duration: 0.24, curve: .easeIn) {
                        self.dotView.backgroundColor = self.activeColor
                        }.startAnimation()
                } else {
                    dotView.backgroundColor = activeColor
                }
                
            case .unfinished:
                if #available(iOS 10.0, *) {
                    UIViewPropertyAnimator(duration: 0.24, curve: .easeIn) {
                        self.dotView.backgroundColor = self.unActiveColor
                        }.startAnimation()
                } else {
                    dotView.backgroundColor = unActiveColor
                }
            }
        }
    }
    
    public var parentViewHeight: CGFloat = 0.0 {
        didSet {
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightDotViewConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: parentViewHeight)
            let widthDotViewConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: parentViewHeight)
            self.addConstraints([heightDotViewConstraint, widthDotViewConstraint])
        }
    }
    
    var pressed: ((Int) -> ())?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setGesture()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setGesture()
    }
    
    private func addDots() {
        dotView.backgroundColor = .black
        dotView.layer.cornerRadius = height / 2
        self.translatesAutoresizingMaskIntoConstraints = false
        dotView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dotView)
        heightConstraint = NSLayoutConstraint(item: dotView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        widthConstraint = NSLayoutConstraint(item: dotView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let centerXDotViewConstraint = NSLayoutConstraint(item: dotView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYDotViewConstraint = NSLayoutConstraint(item: dotView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        dotView.addConstraints([heightConstraint, widthConstraint])
        self.addConstraints([centerXDotViewConstraint, centerYDotViewConstraint])
    }
    
    
    func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }

    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        pressed?(index)
    }
    
    func setSelectedDot() {
        let newSize = height * 1.5
        heightConstraint.constant = newSize
        widthConstraint.constant = newSize
        dotView.layer.cornerRadius = newSize / 2
        dotView.layoutIfNeeded()
    }
    
    func setUnSelectedDot() {
        let newSize = height
        heightConstraint.constant = newSize
        widthConstraint.constant = newSize
        dotView.layer.cornerRadius = newSize / 2
        dotView.layoutIfNeeded()
    }

}
