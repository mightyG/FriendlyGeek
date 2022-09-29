//
//  EditNameViewModel.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class EditNameViewModel: ViewModelType {
    
    var input: EditNameViewModel.Input
    var output: EditNameViewModel.Output
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let backButtonSelected: AnyObserver<Void>
        let submitButtonSelected: AnyObserver<Void>
        let didModifyFirstName: AnyObserver<String>
        let didModifyLastName: AnyObserver<String>
    }
    
    // MARK: - Outputs
    struct Output {
        let firstName: BehaviorRelay<String>
        let lastName: BehaviorRelay<String>
        let shouldDimiss: Driver<Void>
        let isSubmitEnabled: Driver<Bool>
        let nameUpdated: Observable<(firstName: String, lastName: String)>
    }

    init(firstName: String, lastName: String) {
        let backButtonSelectedSubject = PublishSubject<Void>()
        let submitButtonSelectedSubject = PublishSubject<Void>()
        let didModifyFirstNameSubject = PublishSubject<String>()
        let didModifyLastNameSubject = PublishSubject<String>()

        self.input = Input(backButtonSelected: backButtonSelectedSubject.asObserver(),
                           submitButtonSelected: submitButtonSelectedSubject.asObserver(),
                           didModifyFirstName: didModifyFirstNameSubject.asObserver(),
                           didModifyLastName:  didModifyLastNameSubject.asObserver()
        )
        
        let shouldDismiss = backButtonSelectedSubject.asDriver(onErrorJustReturn: ())
        
        let firstNameRelay = BehaviorRelay(value: firstName)
        let lastNameRelay = BehaviorRelay(value: lastName)
        
        let isSubmitEnabled = Observable.combineLatest(firstNameRelay.asObservable(), lastNameRelay.asObservable()) { !$0.isEmpty && !$1.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let nameUpdated = Observable.combineLatest(submitButtonSelectedSubject.asObservable(),
                                                   firstNameRelay.asObservable(),
                                                   lastNameRelay.asObservable()) { (firstName: $1, lastName: $2) }
        
        self.output = Output(firstName: firstNameRelay,
                             lastName: lastNameRelay,
                             shouldDimiss: shouldDismiss,
                             isSubmitEnabled: isSubmitEnabled,
                             nameUpdated: nameUpdated
        )
        
        didModifyFirstNameSubject.asObservable()
            .bind(to: self.output.firstName)
            .disposed(by: self.disposeBag)
        
        didModifyLastNameSubject.asObservable()
            .bind(to: self.output.lastName)
            .disposed(by: self.disposeBag)
    }
}
