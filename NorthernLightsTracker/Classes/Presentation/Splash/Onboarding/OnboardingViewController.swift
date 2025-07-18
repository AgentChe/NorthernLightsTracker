//
//  OnboardingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    private lazy var mainView = OnboardingView { [weak self] data in
        self?.didCombineDataTrigger.accept(data)
    }
    
    private lazy var viewModel = OnboardingViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didCombineDataTrigger = PublishRelay<OnboardingCombineData.CombineData>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: OnboardingViewModel.Input(
            didCombineData: didCombineDataTrigger.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
    
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: Private
private extension OnboardingViewController {
    func action(_ action: OnboardingViewModel.Action) {
        guard let window = UIApplication.shared.window else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                self?.action(action)
            }
            
            return
        }
        
        switch action {
        case .paygateTransitionMain:
            markAsViewed()
            
            let vc = PaygateViewController.make {
                window.rootViewController = MainViewController.make(requestReview: true)
            }
            present(vc, animated: true)
        case .main:
            markAsViewed()
            
            window.rootViewController = MainViewController.make(requestReview: true)
        }
    }
    
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self else { return Disposables.create() }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}
