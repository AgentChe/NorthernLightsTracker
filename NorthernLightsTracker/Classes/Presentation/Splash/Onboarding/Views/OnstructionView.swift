//
//  OnstructionView.swift
//  InventoryManagement
//
//  Created by Андрей Чернышев on 08.04.2025.
//

import UIKit

final class OnstructionView: UIView {
    enum Slide {
        case first, second
    }
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var nextButton = makeNextButton()
    
    private let slide: Slide
    private let onNext: () -> Void
    
    private var authorizationQuery: LocationAuthorizationQuery?
    
    init(slide: Slide, onNext: @escaping () -> Void) {
        self.slide = slide
        self.onNext = onNext
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OnstructionView {
    func initialize() {
        backgroundColor = Appearance.main300
    }
    
    @objc
    func nextTapped() {
        switch slide {
        case .first:
            onNext()
        case .second:
            let authorizationQuery = LocationAuthorizationQuery { [weak self] _ in
                self?.authorizationQuery = nil
                
                self?.onNext()
            }
            self.authorizationQuery = authorizationQuery
            authorizationQuery.request()
        }
    }
}

// MARK: Make constraints
private extension OnstructionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 544.scale : 410.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 45.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 48.scale),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnstructionView {
    func makeImageView() -> UIImageView {
        let imageName: String = {
            switch slide {
            case .first:
                return "Onboarding.First"
            case .second:
                return "Onboarding.Second"
            }
        }()
        
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: imageName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.IBMPlexSans.bold(size: 28.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let title: String = {
            switch slide {
            case .first:
                return "Onboarding.Instructions.First.Title".localized
            case .second:
                return "Onboarding.Instructions.Second.Title".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.IBMPlexSans.regular(size: 16.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let subTitle: String = {
            switch slide {
            case .first:
                return "Onboarding.Instructions.First.SubTitle".localized
            case .second:
                return "Onboarding.Instructions.Second.SubTitle".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = subTitle.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.bold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 8.scale
        view.backgroundColor = Appearance.main100
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
