//
//  TryAgainView.swift
//  ScienceSolver
//
//  Created by Андрей Чернышев on 06.09.2024.
//

import UIKit

final class TryAgainView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var closeButton = makeCloseButton()
    lazy var errorIconView = makeErrorIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tryAgainButton = makeTryAgainButton()
    lazy var contactButton = makeContactButton()
    
    private let error: Error
    
    init(error: Error) {
        self.error = error

        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TryAgainView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    func errorMessage() -> String {
         guard let networkError = error as? NetworkError else {
             return "TryAgain.SubTitle".localized
         }

         switch networkError.code {
         case .serverNotAvailable:
             return "TryAgain.SubTitle".localized
         case .logical(let message):
             return message
         }
     }
}

// MARK: Make constraints
private extension TryAgainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 213.scale : 150.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            errorIconView.widthAnchor.constraint(equalToConstant: 44.scale),
            errorIconView.heightAnchor.constraint(equalToConstant: 38.scale),
            errorIconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorIconView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            titleLabel.topAnchor.constraint(equalTo: errorIconView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            tryAgainButton.widthAnchor.constraint(equalToConstant: 343.scale),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 55.scale),
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.bottomAnchor.constraint(equalTo: contactButton.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactButton.widthAnchor.constraint(equalToConstant: 343.scale),
            contactButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            contactButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -14.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TryAgainView {
    func makeHeaderView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "TryAgain.Header")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Close.White"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeErrorIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TryAgain.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.bold(size: 24.scale))
            .lineHeight(31.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "TryAgain.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = errorMessage().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTryAgainButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.IBMPlexSans.bold(size: 18.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("TryAgain.Button".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main100
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContactButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.bold(size: 18.scale))
        
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("TryAgain.Contact".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
