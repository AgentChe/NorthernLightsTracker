//
//  SolarViewController.swift
//  NorthernLightsTracker
//
//  Created by Андрей Чернышев on 18.07.2025.
//

import UIKit
import RxSwift

final class SolarViewController: UIViewController {
    private lazy var mainView = SolarView()
    
    private let viewModel: SolarViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(template: SolarTemplate) {
        viewModel = SolarViewModel(template: template)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            self?.open(error: error) ?? .never()
        }
        
        let output = viewModel.configure(input: SolarViewModel.Input())
        
        output.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SolarViewController {
    static func make(template: SolarTemplate) -> SolarViewController {
        let vc = SolarViewController(template: template)
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = template.name
        return vc
    }
}

// MARK: Private
private extension SolarViewController {
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
