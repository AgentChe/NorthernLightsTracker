//
//  OPageIndicatorView.swift
//  GISRealEstate
//
//  Created by Андрей Чернышев on 23.06.2025.
//

import UIKit

final class OPageIndicatorView: UIView {
    lazy var indicator1View = makeIndicatorView()
    lazy var indicator2View = makeIndicatorView()
    
    private lazy var indicators = [indicator1View, indicator2View]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OPageIndicatorView {
    func select(index: Int) {
        indicators.enumerated().forEach { indicatorIndex, indicator in
            indicator.backgroundColor = indicatorIndex <= index ? Appearance.main100 : Appearance.mono100
        }
    }
}

// MARK: Private
private extension OPageIndicatorView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension OPageIndicatorView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            indicator1View.widthAnchor.constraint(equalToConstant: 29.5.scale),
            indicator1View.heightAnchor.constraint(equalToConstant: 3.scale),
            indicator1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicator1View.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -2.scale),
            indicator1View.topAnchor.constraint(equalTo: topAnchor),
            indicator1View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicator2View.widthAnchor.constraint(equalToConstant: 29.5.scale),
            indicator2View.heightAnchor.constraint(equalToConstant: 3.scale),
            indicator2View.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicator2View.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 2.scale),
            indicator2View.topAnchor.constraint(equalTo: topAnchor),
            indicator2View.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OPageIndicatorView {
    func makeIndicatorView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 1.5.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
