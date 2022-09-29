//
//  EditEmailViewModel.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class EditEmailViewModel: ViewModelType {
    
    var input: EditEmailViewModel.Input
    var output: EditEmailViewModel.Output
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let backButtonSelected: AnyObserver<Void>
        let submitButtonSelected: AnyObserver<Void>
        let didModifyEmail: AnyObserver<String>
    }
    
    // MARK: - Outputs
    struct Output {
        let email: BehaviorRelay<String>
        let shouldDimiss: Driver<Void>
        let isSubmitEnabled: Driver<Bool>
        let emailUpdated: Observable<String>
    }

    init(email: String) {
        let backButtonSelectedSubject = PublishSubject<Void>()
        let submitButtonSelectedSubject = PublishSubject<Void>()
        let didModifyEmailSubject = PublishSubject<String>()

        self.input = Input(backButtonSelected: backButtonSelectedSubject.asObserver(),
                           submitButtonSelected: submitButtonSelectedSubject.asObserver(),
                           didModifyEmail: didModifyEmailSubject.asObserver()
        )
        
        let shouldDismiss = backButtonSelectedSubject.asDriver(onErrorJustReturn: ())
        
        let emailRelay = BehaviorRelay(value: email)
        
        let isSubmitEnabled = emailRelay
            .asObservable()
            .map({ $0.isValidEmail() })
            .asDriver(onErrorJustReturn: false)
        
        let emailUpdated = Observable.combineLatest(submitButtonSelectedSubject.asObservable(),
                                                    emailRelay.asObservable()) { $1 }
        
        self.output = Output(email: emailRelay,
                             shouldDimiss: shouldDismiss,
                             isSubmitEnabled: isSubmitEnabled,
                             emailUpdated: emailUpdated
        )
        
        didModifyEmailSubject.asObservable()
            .bind(to: self.output.email)
            .disposed(by: self.disposeBag)

    }
    
}
