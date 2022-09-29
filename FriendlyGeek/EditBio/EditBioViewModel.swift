//
//  EditBioViewModel.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class EditBioViewModel: ViewModelType {
    
    var input: EditBioViewModel.Input
    var output: EditBioViewModel.Output
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let backButtonSelected: AnyObserver<Void>
        let submitButtonSelected: AnyObserver<Void>
        let didModifyBio: AnyObserver<String>
    }
    
    // MARK: - Outputs
    struct Output {
        let bio: BehaviorRelay<String>
        let shouldDimiss: Driver<Void>
        let isSubmitEnabled: Driver<Bool>
        let bioUpdated: Observable<String>
    }

    init(bio: String) {
        let backButtonSelectedSubject = PublishSubject<Void>()
        let submitButtonSelectedSubject = PublishSubject<Void>()
        let didModifyBioSubject = PublishSubject<String>()

        self.input = Input(backButtonSelected: backButtonSelectedSubject.asObserver(),
                           submitButtonSelected: submitButtonSelectedSubject.asObserver(),
                           didModifyBio: didModifyBioSubject.asObserver()
        )
        
        let shouldDismiss = backButtonSelectedSubject.asDriver(onErrorJustReturn: ())
        
        let bioRelay = BehaviorRelay(value: bio)
        
        let isSubmitEnabled = bioRelay
            .asObservable()
            .map({ !$0.isEmpty })
            .asDriver(onErrorJustReturn: false)
        
        let bioUpdated = Observable.combineLatest(submitButtonSelectedSubject.asObservable(),
                                                  bioRelay.asObservable()) { $1 }
        
        self.output = Output(bio: bioRelay,
                             shouldDimiss: shouldDismiss,
                             isSubmitEnabled: isSubmitEnabled,
                             bioUpdated: bioUpdated
        )
        
        didModifyBioSubject.asObservable()
            .bind(to: self.output.bio)
            .disposed(by: self.disposeBag)

    }
    
}
