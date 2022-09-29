//
//  ViewController.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(endEditing))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func endEditing(sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
