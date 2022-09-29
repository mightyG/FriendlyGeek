//
//  FriendlyTextField.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import UIKit
import SnapKit

@IBDesignable
class FriendlyTextField: CorneredShadowView {
        
    lazy var textFieldTitleLabel: UILabel! = {
        let label = UILabel()
        label.textColor = UIColor(named: "TextGray")!
        label.font = UIFont(name: "WithoutSans-Bold", size: 15.0)!
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textField: UITextField! = {
        let textField = UITextField()
        textField.textColor = UIColor(named: "TextBlack")!
        textField.font = UIFont(name: "WithoutSans-Bold", size: 16.0)!
        textField.borderStyle = .none
        if let _ = self.parentViewController?.view.viewWithTag(self.tag+1) as? FriendlyTextField {
            textField.returnKeyType = .next
        } else{
            textField.returnKeyType = .done
        }
        textField.delegate = self
        return textField
    }()

    @IBInspectable var title : String {
        get {
            return self.textFieldTitleLabel?.text ?? ""
        }
        set(title){
            self.textFieldTitleLabel?.text = title
        }
    }
    
    var textFieldType: FriendlyTextFieldType = .unspecified
    
    @IBInspectable var textFieldTypeAdapter: String {
         get {
             return self.textFieldType.rawValue
         }
         set(type) {
             self.textFieldType = FriendlyTextFieldType(rawValue: type) ?? .unspecified
             
             switch self.textFieldType {
             case .unspecified:
                 break
             case .firstName:
                 self.textField?.textContentType = .givenName
             case .lastName:
                 self.textField?.textContentType = .familyName
             case .email:
                 self.textField?.textContentType = .emailAddress
                 self.textField?.keyboardType = .emailAddress
             case .phone:
                 self.textField?.textContentType = .telephoneNumber
                 self.textField?.keyboardType = .phonePad
             }
         }
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.customInit()
    }
    
    private func customInit() {
        
        // adding title label
        self.addSubview(textFieldTitleLabel) { make in
            make.top.leading.equalTo(10)
            make.trailing.greaterThanOrEqualTo(10)
        }
        
        // adding text field
        self.addSubview(textField) { make in
            make.top.equalTo(self.textFieldTitleLabel.snp_bottomMargin)
            make.leading.trailing.bottom.equalTo(10)
        }
        
    }

}

enum FriendlyTextFieldType: String {
    case firstName
    case lastName
    case phone
    case email
    case unspecified
}

// MARK: UITextFieldDelegate
extension FriendlyTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = self.parentViewController?.view.viewWithTag(self.tag+1) as? FriendlyTextField {
            nextTextField.textField.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
