//
//  OnboardingAlertsView.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import UIKit
import RiveRuntime

final class OAlertsView: OSlideView {
    lazy var animationView = makeAnimationView()
    lazy var progressView = makeProgressView()
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeTextLabel()
    lazy var continueButton = makeContinueButton()
    
    private lazy var animationVM = RiveViewModel(fileName: "Onboarding.Alerts")
    
    private lazy var notificationsQuery = PushNotificationsQuery()
    private var authorizationQuery: LocationAuthorizationQuery?
    
    private let didNext: (String?) -> Void
    
    init(didNext: @escaping (String?) -> Void) {
        self.didNext = didNext
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        animationVM.setView(animationView)
    }
}

// MARK: Private
private extension OAlertsView {
    func initialize() {
        backgroundColor = Appearance.mono200
    }
    
    @objc
    func didTapContinue() {
        notificationsQuery.didReceiveToken = { [weak self] token in
            let authorizationQuery = LocationAuthorizationQuery { [weak self] status in
                self?.authorizationQuery = nil
                
                self?.didNext(token)
            }
            self?.authorizationQuery = authorizationQuery
            authorizationQuery.request()
        }
        notificationsQuery.request()
    }
}

// MARK: Make constraints
private extension OAlertsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 404.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            progressView.widthAnchor.constraint(equalToConstant: 100.scale),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale),
            progressView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -57.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 55.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OAlertsView {
    func makeAnimationView() -> RiveView {
        let view = RiveView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> GradientProgressView {
        let view = GradientProgressView()
        view.setProgress(0.6, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.bold(size: 32.scale))
            .lineHeight(42.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Alerts.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 18.scale))
            .lineHeight(23.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Alerts.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.IBMPlexSans.bold(size: 18.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main100
        view.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        view.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.cornerRadius = 12.scale
        view.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
