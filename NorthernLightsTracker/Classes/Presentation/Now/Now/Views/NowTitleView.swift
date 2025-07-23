//
//  NowTitleView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class NowTitleView: UIView {
    lazy var geoIconView = makeGeoIconView()
    lazy var geoLabel = makeLabel()
    lazy var settingsButton = makeSettingsButton()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.IBMPlexSans.bold(size: 18.scale))
        .lineHeight(30.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
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
extension NowTitleView {
    func setup(geo: String) {
        geoLabel.attributedText = geo.attributed(with: attrs)
    }
    
    var didTap: Signal<Void> {
        tapGesture.rx.event
            .mapToVoid()
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension NowTitleView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
}

// MARK: Make constraints
private extension NowTitleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            geoIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            geoIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            geoIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            geoIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            geoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            geoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale),
            geoLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension NowTitleView {
    func makeGeoIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Now.Geo")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Now.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
}
