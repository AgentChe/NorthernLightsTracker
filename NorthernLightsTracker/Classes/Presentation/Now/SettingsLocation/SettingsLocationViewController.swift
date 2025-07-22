//
//  SettingsLocationViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 22.07.2025.
//

import UIKit
import RxSwift

final class SettingsLocationViewController: UIViewController {
    private lazy var mainView = SettingsLocationView()
    
    private lazy var viewModel = SettingsLocationViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        mainView.tableView.rx.willBeginDragging.asSignal()
            .emit(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: SettingsLocationViewModel.Input(
            changedText: mainView.searchField.changedText,
            didScrollToBottom: mainView.tableView.didScrollToBottom,
            didSelectRecent: mainView.tableView.didSelectRecent,
            didSelectLocation: mainView.tableView.didSelectLocation
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsLocationViewController {
    static func make() -> SettingsLocationViewController {
        let vc = SettingsLocationViewController()
        vc.navigationItem.title = "SettingsLocation.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SettingsLocationViewController {
    func action(_ action: SettingsLocationViewModel.Action) {
        switch action {
        case .setupRecent(let recent):
            mainView.searchField.setup(text: recent)
        case .close:
            navigationController?.popViewController(animated: true)
        }
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
