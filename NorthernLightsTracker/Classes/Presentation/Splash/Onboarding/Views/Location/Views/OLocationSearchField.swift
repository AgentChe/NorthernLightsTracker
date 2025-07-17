//
//  OLocationSearchField.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 16.07.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class OLocationSearchField: UIView {
    lazy var searchIconView = makeSearchIconView()
    lazy var textField = makeTextField()
    lazy var clearButton = makeClearButton()
    
    private lazy var text = BehaviorRelay(value: "")
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        textEditing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OLocationSearchField {
    var changedText: Signal<String> {
        text.asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Public
extension OLocationSearchField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension OLocationSearchField {
    func initialize() {
        backgroundColor = Appearance.main300
        layer.cornerRadius = 23.scale
        layer.masksToBounds = true
        
        clearButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.textField.text = nil
                base.textEditing()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func textEditing() {
        text.accept(textField.text ?? "")
        
        clearButton.isHidden = (textField.text ?? "").isEmpty
    }
}

// MARK: Make constraints
private extension OLocationSearchField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchIconView.widthAnchor.constraint(equalToConstant: 20.scale),
            searchIconView.heightAnchor.constraint(equalToConstant: 20.scale),
            searchIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 47.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -49.scale),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 18.scale),
            clearButton.heightAnchor.constraint(equalToConstant: 18.scale),
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OLocationSearchField {
    func makeSearchIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Location.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.IBMPlexSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        let textAttrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.IBMPlexSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.delegate = self
        view.returnKeyType = .default
        view.textPadding = UIEdgeInsets(vertical: 11.scale)
        view.defaultTextAttributes = textAttrs.dictionary
        view.attributedPlaceholder = "Onboarding.Location.SearchPlaceholder".localized.attributed(with: placeholderAttrs)
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClearButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Location.Clear"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
