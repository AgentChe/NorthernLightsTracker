//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashView: UIView {
    lazy var imageView = makeImageView()
    lazy var title1Label = makeTitle1Label()
    lazy var title2Label = makeTitle2Label()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SplashView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title1Label.centerXAnchor.constraint(equalTo: centerXAnchor),
            title1Label.topAnchor.constraint(equalTo: topAnchor, constant: 117.scale)
        ])
        
        NSLayoutConstraint.activate([
            title2Label.centerXAnchor.constraint(equalTo: centerXAnchor),
            title2Label.topAnchor.constraint(equalTo: title1Label.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 20.scale),
            preloader.heightAnchor.constraint(equalToConstant: 20.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.topAnchor.constraint(equalTo: title2Label.bottomAnchor, constant: 14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitle1Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.IBMPlexSans.bold(size: 52.scale))
            .lineHeight(61.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Splash.Title.1".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitle2Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.IBMPlexSans.bold(size: 24.scale))
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Splash.Title.2".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = Appearance.mono200
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
