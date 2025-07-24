//
//  CalloutWithArrowView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 24.07.2025.
//

import UIKit

final class CalloutWithArrowView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let arrowWidth: CGFloat = 20.scale
    private let arrowHeight: CGFloat = 10.scale
    private let cornerRadius: CGFloat = 10.scale
    private let padding = UIEdgeInsets(vertical: 6.scale, horizontal: 8.scale)
    
    init(title: String?, subtitle: String?) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        let titleAttrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 14.scale))
            .textAlignment(.left)
            .lineHeight(19.scale)
        titleLabel.attributedText = title?.attributed(with: titleAttrs)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.IBMPlexSans.regular(size: 12.scale))
            .textAlignment(.left)
            .lineHeight(16.scale)
        subtitleLabel.attributedText = subtitle?.attributed(with: subTitleAttrs)
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxTextWidth = size.width - padding.left - padding.right
        let tSz = titleLabel.sizeThatFits(.init(width: maxTextWidth, height: .greatestFiniteMagnitude))
        let sSz = subtitleLabel.sizeThatFits(.init(width: maxTextWidth, height: .greatestFiniteMagnitude))
        let w = max(tSz.width, sSz.width) + padding.left + padding.right
        let h = tSz.height + sSz.height + padding.top + padding.bottom + arrowHeight
        return .init(width: w, height: h)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxTextWidth = bounds.width - padding.left - padding.right
        let tSz = titleLabel.sizeThatFits(.init(width: maxTextWidth, height: .greatestFiniteMagnitude))
        let sSz = subtitleLabel.sizeThatFits(.init(width: maxTextWidth, height: .greatestFiniteMagnitude))
        
        titleLabel.frame = CGRect(
            x: padding.left,
            y: padding.top,
            width: maxTextWidth,
            height: tSz.height
        )
        
        subtitleLabel.frame = CGRect(
            x: padding.left,
            y: padding.top + tSz.height,
            width: maxTextWidth,
            height: sSz.height
        )
    }
    
    override func draw(_ rect: CGRect) {
        let bubbleRect = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: bounds.height - arrowHeight
        )
        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: cornerRadius)
        
        let midX = bounds.midX
        path.move(to: CGPoint(x: midX - arrowWidth/2, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: midX, y: bubbleRect.maxY + arrowHeight))
        path.addLine(to: CGPoint(x: midX + arrowWidth/2, y: bubbleRect.maxY))
        path.close()
        
        UIColor.white.withAlphaComponent(0.4).setFill()
        path.fill()
    }
}
