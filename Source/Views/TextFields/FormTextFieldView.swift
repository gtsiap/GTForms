//
//  FormTextFieldView.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 15/12/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormTextFieldView: BaseResultFormView<String> {
    
    public var maximumLength: Int?
    public var minimumLength: Int?
    
    private let textFieldView = TextFieldView()
    private var candidateText = ""
    private let title: String
    
    public init(title: String, placeHolder: String) {
        self.title = title
        super.init()
        
        self.textFieldView.controlLabel.text = title
        self.textFieldView.textField.placeholder = placeHolder
        self.textFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        self.textFieldView.textDidChange = { text in
            self.updateResult(text)
        }
     
        self.textFieldView.didPressReturnButton = {
            
            do {
                try self.validationRulesForLimits()
            } catch let error {
                guard let
                    err = error as? ResultFormViewError
                    else { return }
                
                self.showValidationError(err.message)
            }
        }
        
    }
    
    public override func validate() throws {
        try validationRulesForLimits()
    }
    
    public override func formView() -> UIView {
        return self.textFieldView
    }
    
    private func validationRulesForLimits() throws {
        if let
            maximumLength = self.maximumLength
            where self.result?.characters.count > maximumLength
        {
            self.textFieldView.textField.text = ""
            
            throw ResultFormViewError(
                message: "\(self.title) is too long"
            )
        } else if let
            minimumLength = self.minimumLength
            where self.result?.characters.count < minimumLength
        {
            self.textFieldView.textField.text = ""
            
            throw ResultFormViewError(
                message: "\(self.title) is too short"
            )
        }
    }
    
    
}

