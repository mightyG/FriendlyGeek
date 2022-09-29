//
//  EditImageViewModel.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

final class EditImageViewModel: ViewModelType {
    
    var input: EditImageViewModel.Input
    var output: EditImageViewModel.Output
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let backButtonSelected: AnyObserver<Void>
        let submitButtonSelected: AnyObserver<Void>
        let didModifyImage: AnyObserver<UIImage>
        let imageTapped: AnyObserver<Void>
    }
    
    // MARK: - Outputs
    struct Output {
        let image: BehaviorRelay<UIImage>
        let shouldDimiss: Driver<Void>
        let openImagePicker: Driver<Void>
        let imageUpdated: Observable<UIImage>
    }

    init(image: UIImage) {
        let backButtonSelectedSubject = PublishSubject<Void>()
        let submitButtonSelectedSubject = PublishSubject<Void>()
        let didModifyImageSubject = PublishSubject<UIImage>()
        let imageTappedSubject = PublishSubject<Void>()

        self.input = Input(backButtonSelected: backButtonSelectedSubject.asObserver(),
                           submitButtonSelected: submitButtonSelectedSubject.asObserver(),
                           didModifyImage: didModifyImageSubject.asObserver(),
                           imageTapped: imageTappedSubject.asObserver()
        )
        
        let shouldDismiss = backButtonSelectedSubject.asDriver(onErrorJustReturn: ())
        
        let imageRelay = BehaviorRelay(value: image)
        
        let imageUpdated = Observable.combineLatest(submitButtonSelectedSubject.asObservable(),
                                                    imageRelay.asObservable()) { $1 }
        
        self.output = Output(image: imageRelay,
                             shouldDimiss: shouldDismiss,
                             openImagePicker: imageTappedSubject.asDriver(onErrorJustReturn: ()),
                             imageUpdated: imageUpdated
        )
        
        didModifyImageSubject.asObservable()
            .bind(to: self.output.image)
            .disposed(by: self.disposeBag)

    }
    
}
