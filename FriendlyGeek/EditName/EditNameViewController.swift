//
//  EditNameViewController.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import UIKit
import RxCocoa
import RxSwift

class EditNameViewController: ViewController {
    
    @IBOutlet var firstNameTextField: FriendlyTextField!
    @IBOutlet var lastNameTextField: FriendlyTextField!

    var viewModel: EditNameViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        setupBinding()
    }

}

// MARK: - RxSetup
extension EditNameViewController {
    func setupBinding() {
        viewModel.output.firstName
            .take(1)
            .asDriver(onErrorJustReturn: "")
            .drive(self.firstNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.lastName
            .take(1)
            .asDriver(onErrorJustReturn: "")
            .drive(self.lastNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: viewModel.input.backButtonSelected)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.input.submitButtonSelected)
            .disposed(by: disposeBag)
        
        firstNameTextField.textField.rx.text.orEmpty
            .bind(to: viewModel.input.didModifyFirstName)
            .disposed(by: disposeBag)
            
        lastNameTextField.textField.rx.text.orEmpty
            .bind(to: viewModel.input.didModifyLastName)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldDimiss
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isSubmitEnabled
            .drive(self.submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.isSubmitEnabled
            .drive(onNext: { [unowned self] isEnabled in
                self.submitButton.alpha = isEnabled ? 1 : 0.5
            })
            .disposed(by: disposeBag)
        
        viewModel.output.nameUpdated
            .map({ _ in return })
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}
