//
//  EditBioViewController.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import UIKit
import RxCocoa
import RxSwift

class EditBioViewController: ViewController {

    @IBOutlet var bioTextView: FriendlyTextView!
    
    var viewModel: EditBioViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBinding()
    }

}

// MARK: - RxSetup
extension EditBioViewController {
    func setupBinding() {
        
        viewModel.output.bio
            .take(1)
            .asDriver(onErrorJustReturn: "")
            .drive(self.bioTextView.rx.text)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(to: viewModel.input.backButtonSelected)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.input.submitButtonSelected)
            .disposed(by: disposeBag)
        
        bioTextView.rx.text.orEmpty
            .bind(to: viewModel.input.didModifyBio)
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
        
        viewModel.output.bioUpdated
            .map({ _ in return })
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}
