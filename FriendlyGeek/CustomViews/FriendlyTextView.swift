//
//  FriendlyTextView.swift
//  FriendlyGeek
//
//  Created by Georgio Sayegh on 29/09/2022.
//

import UIKit

@IBDesignable class FriendlyTextView: UITextView {
    
    override var text: String! { // Ensures that the placeholder text is never returned as the field's text
        get {
            if showingPlaceholder {
                return "" // When showing the placeholder, there's no real text to return
            } else { return super.text }
        }
        set {
            if showingPlaceholder {
                removePlaceholderFormatting() // If the placeholder text is what's being changed, it's no longer the placeholder
            }
            super.text = newValue
        }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = UIColor(named: "TextGray")!
    private var showingPlaceholder: Bool = true // Keeps track of whether the field is currently showing a placeholder
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        willSet{
            if(newValue > 0.0){
                self.layer.cornerRadius = newValue
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var isBordered : Bool = true {
        willSet{
            if(newValue){
                self.layer.borderWidth = 1.0
                self.layer.cornerRadius = 7.0
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor(named: "TextGray")! {
        willSet{
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var topTextViewContentInset : CGFloat = 4.0 {
        willSet{
            self.textContainerInset = UIEdgeInsets(top: newValue, left: self.leftTextViewContentInset, bottom: self.bottomTextViewContentInset, right: self.rightTextViewContentInset)
        }
    }
    
    @IBInspectable var bottomTextViewContentInset : CGFloat = 4.0 {
        willSet{
            self.textContainerInset = UIEdgeInsets(top: self.topTextViewContentInset, left: self.leftTextViewContentInset, bottom: newValue, right: self.rightTextViewContentInset)
        }
    }
    
    @IBInspectable var rightTextViewContentInset : CGFloat = 4.0 {
        willSet{
            self.textContainerInset = UIEdgeInsets(top: self.topTextViewContentInset, left: self.leftTextViewContentInset, bottom: self.bottomTextViewContentInset, right: newValue)
        }
    }
    
    @IBInspectable var leftTextViewContentInset : CGFloat = 4.0 {
        willSet{
            self.textContainerInset = UIEdgeInsets(top: self.topTextViewContentInset, left: newValue, bottom: self.bottomTextViewContentInset, right: self.rightTextViewContentInset)
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
        }
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = nil
            removePlaceholderFormatting()
        }
        return super.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        
        // If there's no text, put the placeholder back
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func showPlaceholderText() {
        
        text = placeholderText
        showingPlaceholder = true
        textColor = placeholderTextColor
    }
    
    private func removePlaceholderFormatting() {
        
        showingPlaceholder = false
        textColor = nil // Put the text back to the default, unmodified color
    }
}
