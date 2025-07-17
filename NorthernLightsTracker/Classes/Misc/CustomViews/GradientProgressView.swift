//
//  GradientProgressView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import UIKit

final class GradientProgressView: UIView {
    var gradientColors: [CGColor] = Appearance.main100 {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }
    
    private lazy var gradientLayer = CAGradientLayer()
    private lazy var maskLayer = CALayer()
    
    private(set) var progress: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        updateMask()
    }
}

// MARK: Public
extension GradientProgressView {
    func setProgress(_ newProgress: CGFloat, animated: Bool) {
        let clipped = min(max(newProgress, 0), 1)
        progress = clipped
        
        let apply = { [weak self] in
            self?.updateMask()
        }
        
        if animated {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            apply()
            CATransaction.commit()
        } else {
            apply()
        }
    }
}


// MARK: Private
private extension GradientProgressView {
    func initialize() {
        backgroundColor = Appearance.main300
        layer.cornerRadius = 3.scale
        layer.masksToBounds = true
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = gradientColors
        
        gradientLayer.cornerRadius = 3.scale
        layer.addSublayer(gradientLayer)
        
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.cornerRadius = 3.scale
        gradientLayer.mask = maskLayer
    }
    
    func updateMask() {
        maskLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width * progress,
            height: bounds.height
        )
    }
}
