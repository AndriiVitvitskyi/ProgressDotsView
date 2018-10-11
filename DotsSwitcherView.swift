//
//  DotsSwitcherView.swift
//  BuddeeFramework
//
//  Created by Andrii Vitvitskyi on 10/4/18.
//  Copyright © 2018 buddee fitness. All rights reserved.
//

import Foundation

open class DotsSwitcherView: UIView {
    
    private var contentView : UIView!
    
    @IBOutlet private weak var trailingLineViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leadingLineViewConstraint: NSLayoutConstraint!
    
    @IBInspectable
    public var numberOfDots: Int = 0
    @IBInspectable
    public var dotSize: CGFloat = 0.0
    @IBInspectable
    public var retreatOnTheSides: CGFloat = 20.0 {
        didSet {
            trailingLineViewConstraint.constant = retreatOnTheSides
            leadingLineViewConstraint.constant = retreatOnTheSides
        }
    }
    @IBInspectable
    public var dotUnActiveColor: UIColor = .gray
    @IBInspectable
    public var dotActiveColor: UIColor = .gray
    @IBInspectable
    public var viewBackGroundColor: UIColor = .white

    
    public var dotVies: [DotView?] = []
    public var dotPressed: ((Int) -> ())?
    @IBOutlet private weak var lineViewBackground: UIView!
    @IBOutlet private weak var lineView: UIView!
    
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.xibSetup()
    }
    
    public override init(frame: CGRect) { 
        super.init(frame: frame)
        
        self.xibSetup()
    }
    
    public convenience init() {
        self.init(frame: .zero)
        
        self.xibSetup()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
        
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    private func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView)
    }
    
    private func setUpView() {
        createDots()
        self.backgroundColor = viewBackGroundColor
    }
    
    private func createDots() {
        let spaceSize = lineView.frame.size.width / CGFloat((numberOfDots - 1))
        var leadingSpace: CGFloat = retreatOnTheSides
        for i in 0...numberOfDots {
            let dotView = DotView()
            self.dotVies.append(dotView)
            dotView.activeColor = dotActiveColor
            dotView.unActiveColor = dotUnActiveColor
            dotView.height = dotSize
            dotView.state = .unfinished
            dotView.index = i
            dotView.parentViewHeight = self.frame.size.height
            dotView.pressed = { [weak self] index in
                self?.dotIsPressed(index)
            }
            lineViewBackground.addSubview(dotView)
            //Constraints
            self.lineViewBackground.translatesAutoresizingMaskIntoConstraints = false
            let centerYConstraint = NSLayoutConstraint(item: dotView, attribute: .centerY, relatedBy: .equal, toItem: lineViewBackground, attribute: .centerY, multiplier: 1, constant: 0.0)
            let centerXConstraint = NSLayoutConstraint(item: dotView, attribute: .centerX, relatedBy: .equal, toItem: lineViewBackground, attribute: .leading, multiplier: 1, constant: leadingSpace)
            self.lineViewBackground.addConstraints([centerXConstraint, centerYConstraint])
            leadingSpace += spaceSize - dotSize
        }
        dotVies[0]?.setSelectedDot()
    }
    
    func setSelectedDot(_ index: Int) {

        heightConstraint.constant = dotSize * 1.5
        widthConstraint.constant = dotSize * 1.5
        
    }
    
    private func dotIsPressed(_ index: Int) {
        self.dotPressed?(index)
        for dot in dotVies {
            if dot?.index == index {
                dot?.setSelectedDot()
            } else {
               dot?.setUnSelectedDot()
            }
        }
    }

}
