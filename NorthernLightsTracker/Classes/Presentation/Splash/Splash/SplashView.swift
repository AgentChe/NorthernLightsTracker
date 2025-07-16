//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var contentView = makeContentView()
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
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
        backgroundColor = Appearance.mono200
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40.scale),
            imageView.heightAnchor.constraint(equalToConstant: 40.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -36.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Splash.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContentView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Splash.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.bold(size: 32.scale))
            .lineHeight(42.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Splash.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        view.color = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
