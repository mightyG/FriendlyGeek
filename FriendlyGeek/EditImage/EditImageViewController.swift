//
//  EditImageViewController.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import UIKit
import RxCocoa
import RxSwift

class EditImageViewController: ViewController {

    @IBOutlet var imageButton: CorneredButton!
    
    var viewModel: EditImageViewModel!
    
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setupBinding()
    }

}

// MARK: - RxSetup
extension EditImageViewController {
    func setupBinding() {
                
        imageButton
            .rx
            .tap
            .bind(to: viewModel.input.imageTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.image
            .asDriver(onErrorJustReturn: UIImage(named: "user")!)
            .drive(imageButton.rx.image(for: .normal))
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(to: viewModel.input.backButtonSelected)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.input.submitButtonSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldDimiss
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.imageUpdated
            .map({ _ in return })
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.openImagePicker
            .drive(onNext: { [unowned self] in
                self.imagePicker.present(from: self.view)
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Image Picker Delegate
extension EditImageViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if let image = image {
            viewModel.input.didModifyImage.onNext(image)
        }
    }
}
