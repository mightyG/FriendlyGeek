//
//  EditPhoneViewModel.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class EditPhoneViewModel: ViewModelType {
    
    var input: EditPhoneViewModel.Input
    var output: EditPhoneViewModel.Output
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let backButtonSelected: AnyObserver<Void>
        let submitButtonSelected: AnyObserver<Void>
        let didModifyPhone: AnyObserver<String>
    }
    
    // MARK: - Outputs
    struct Output {
        let phone: BehaviorRelay<String>
        let shouldDimiss: Driver<Void>
        let isSubmitEnabled: Driver<Bool>
        let phoneUpdated: Observable<String>
    }

    init(phone: String) {
        let backButtonSelectedSubject = PublishSubject<Void>()
        let submitButtonSelectedSubject = PublishSubject<Void>()
        let didModifyPhoneSubject = PublishSubject<String>()

        self.input = Input(backButtonSelected: backButtonSelectedSubject.asObserver(),
                           submitButtonSelected: submitButtonSelectedSubject.asObserver(),
                           didModifyPhone: didModifyPhoneSubject.asObserver()
        )
        
        let shouldDismiss = backButtonSelectedSubject.asDriver(onErrorJustReturn: ())
        
        let phoneRelay = BehaviorRelay(value: phone)
        
        let isSubmitEnabled = phoneRelay
            .asObservable()
            .map({ $0.isValidPhone() })
            .asDriver(onErrorJustReturn: false)
        
        let phoneUpdated = Observable.combineLatest(submitButtonSelectedSubject.asObservable(),
                                                   phoneRelay.asObservable()) { $1 }
        
        self.output = Output(phone: phoneRelay,
                             shouldDimiss: shouldDismiss,
                             isSubmitEnabled: isSubmitEnabled,
                             phoneUpdated: phoneUpdated
        )
        
        didModifyPhoneSubject.asObservable()
            .bind(to: self.output.phone)
            .disposed(by: self.disposeBag)

    }
    
}
