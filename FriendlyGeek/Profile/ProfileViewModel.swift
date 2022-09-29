//
//  ProfileViewModel.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 28/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    
}

final class ProfileViewModel: ViewModelType {
    
    var input: ProfileViewModel.Input
    var output: ProfileViewModel.Output
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    struct Input {
        let itemSelected: AnyObserver<Int>
        let editImageSelected: AnyObserver<Void>
    }
    
    // MARK: - Outputs
    struct Output {
        let user: BehaviorRelay<UserModel> = BehaviorRelay(value: UserModel())
        let shouldEditInfo: Driver<EditTypes>
    }

    init() {
        let itemSelectedSubject = PublishSubject<Int>()
        let editImageSelected = PublishSubject<Void>()
        self.input = Input(itemSelected: itemSelectedSubject.asObserver(),
                           editImageSelected: editImageSelected.asObserver()
        )
                
        let editBasicInfo = itemSelectedSubject
            .asObservable()
            .map({  EditTypes(rawValue: $0) ?? .unspecified })
        
        let editImage = editImageSelected
            .asObserver()
            .map({ EditTypes.editImage })
        
        let shoulfEditInfo = Observable.of(editBasicInfo, editImage)
            .merge()
            .asDriver(onErrorJustReturn: .unspecified)
        
        self.output = Output(shouldEditInfo: shoulfEditInfo)
    }
    
    func createEditNameViewModel() -> EditNameViewModel {
        let editNameViewModel = EditNameViewModel(firstName: self.output.user.value.firstName, lastName: self.output.user.value.lastName)
        
        editNameViewModel.output.nameUpdated
            .subscribe(onNext: { [weak self] (firstName, lastName) in
                if let self = self {
                    var user = self.output.user.value
                    user.firstName = firstName
                    user.lastName = lastName
                    self.output.user.accept(user)
                }
                
            })
            .disposed(by: disposeBag)
        
        return editNameViewModel
    }
    
    func createEditPhoneViewModel() -> EditPhoneViewModel {
        let editPhoneViewModel = EditPhoneViewModel(phone: self.output.user.value.phone)
        
        editPhoneViewModel.output.phoneUpdated
            .subscribe(onNext: { [weak self] phone in
                if let self = self {
                    var user = self.output.user.value
                    user.phone = phone
                    self.output.user.accept(user)
                }
                
            })
            .disposed(by: disposeBag)
        
        return editPhoneViewModel
    }
    
    func createEditEmailViewModel() -> EditEmailViewModel {
        let editEmailViewModel = EditEmailViewModel(email: self.output.user.value.email)
        
        editEmailViewModel.output.emailUpdated
            .subscribe(onNext: { [weak self] email in
                if let self = self {
                    var user = self.output.user.value
                    user.email = email
                    self.output.user.accept(user)
                }
                
            })
            .disposed(by: disposeBag)
        
        return editEmailViewModel
    }
    
    func createEditBioViewModel() -> EditBioViewModel {
        let editBioViewModel = EditBioViewModel(bio: self.output.user.value.bio)
        
        editBioViewModel.output.bio
            .subscribe(onNext: { [weak self] bio in
                if let self = self {
                    var user = self.output.user.value
                    user.bio = bio
                    self.output.user.accept(user)
                }
                
            })
            .disposed(by: disposeBag)
        
        return editBioViewModel
    }
    
    func createEditImageViewModel() -> EditImageViewModel {
        let editImageViewModel = EditImageViewModel(image: self.output.user.value.image)
        
        editImageViewModel.output.image
            .subscribe(onNext: { [weak self] image in
                if let self = self {
                    var user = self.output.user.value
                    user.image = image
                    self.output.user.accept(user)
                }
                
            })
            .disposed(by: disposeBag)
        
        return editImageViewModel
    }
}

enum EditTypes: Int {
    case editImage = -1
    case editName = 0
    case editPhone = 1
    case editEmail = 2
    case editBio = 3
    case unspecified = -2
}
