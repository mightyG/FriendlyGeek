//
//  ProfileViewController.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 28/09/2022.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewController: UITableViewController {
    
    @IBOutlet var profileButton: CorneredButton!
    @IBOutlet var profileEditButton: CorneredButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!

    let viewModel = ProfileViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupCellTapHandling()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self

    }

}

// MARK: - RxSetup
extension ProfileViewController {
    func setupBinding() {
        
        self.profileButton.rx.tap
            .bind(to: viewModel.input.editImageSelected)
            .disposed(by: disposeBag)
        
        self.profileEditButton.rx.tap
            .bind(to: viewModel.input.editImageSelected)
            .disposed(by: disposeBag)
        
        self.tableView.rx
            .itemSelected
            .map({ $0.item })
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.output.user
            .asDriver()
            .map({ $0.image })
            .drive(profileButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.output.user
            .asDriver()
            .map({ "\($0.firstName) \($0.lastName)" })
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.user
            .asDriver()
            .map({ $0.phone })
            .drive(phoneLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.user
            .asDriver()
            .map({ $0.email })
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.user
            .asDriver()
            .map({ $0.bio })
            .drive(bioLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldEditInfo
            .drive(onNext: { [unowned self] editType in
                switch editType {
                case .editName:
                    let editNameVC = self.defaultStoryboard.instantiateViewController(ofType: EditNameViewController.self)
                    editNameVC.viewModel = self.viewModel.createEditNameViewModel()
                    self.navigationController?.pushViewController(editNameVC, animated: true)
                case .editPhone:
                    let editPhoneVC = self.defaultStoryboard.instantiateViewController(ofType: EditPhoneViewController.self)
                    editPhoneVC.viewModel = self.viewModel.createEditPhoneViewModel()
                    self.navigationController?.pushViewController(editPhoneVC, animated: true)
                case .editEmail:
                    let editEmailVC = self.defaultStoryboard.instantiateViewController(ofType: EditEmailViewController.self)
                    editEmailVC.viewModel = self.viewModel.createEditEmailViewModel()
                    self.navigationController?.pushViewController(editEmailVC, animated: true)
                case .editBio:
                    let editBioVC = self.defaultStoryboard.instantiateViewController(ofType: EditBioViewController.self)
                    editBioVC.viewModel = self.viewModel.createEditBioViewModel()
                    self.navigationController?.pushViewController(editBioVC, animated: true)
                case .editImage:
                    let editImageVC = self.defaultStoryboard.instantiateViewController(ofType: EditImageViewController.self)
                    editImageVC.viewModel = self.viewModel.createEditImageViewModel()
                    self.navigationController?.pushViewController(editImageVC, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func setupCellTapHandling() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] index in
                if let self = self {
                    self.tableView.deselectRow(at: index, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDelegate
extension ProfileViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
