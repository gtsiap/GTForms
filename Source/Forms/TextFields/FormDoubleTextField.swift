// Copyright (c) 2015-2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public class FormDoubleTextField: BaseResultForm<Double> {
 
    public var maximumValue: Double?
    public var minimumValue: Double?
    
    public var textField: UITextField {
        return self.textFieldView.textField
    }
    
    let textFieldView = TextFieldView()
    private var candidateText = ""
    
    public init(text: String, placeHolder: String) {
        super.init()
        
        self.text = text

        self.textFieldView.controlLabel.text = text
        self.textFieldView.textField.placeholder = placeHolder
        self.textFieldView.textField.keyboardType = .DecimalPad
        self.textFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        self.textFieldView.textDidChange = { text in
            guard let result = Double(text) else { return }
            self.updateResult(result)
        }
        
        self.textFieldView.didPressReturnButton = {
        
            do {
                try self.validationRulesForLimits()
            } catch let error {
                guard let
                    err = error as? ResultFormError
                else { return }
                
                self.showValidationError(err.message)
            }
        }
        
        self.textFieldView.textWillChange = { text in

            self.candidateText = text
            
            do {
                try self.validationRulesForTextEditing()
            } catch let error {
                guard let
                    err = error as? ResultFormError
                else { return false }

                self.showValidationError(err.message)
                return false
            }
            
            return true
        }
    }
 
    public override func validate() throws -> Double? {
        guard let _  = try super.validate() else { return nil }
        try validationRulesForTextEditing()
        try validationRulesForLimits()

        return self.result
    }
    
    public override func formView() -> UIView {
        return self.textFieldView
    }
    
    private func validationRulesForTextEditing() throws {
        // Backspace
        if self.candidateText.isEmpty {
            return
        }
        
        if let
            textFieldText = self.textFieldView.textField.text
            where self.candidateText == "." &&
                !textFieldText.isEmpty &&
                !textFieldText.containsString(".")
        {
            return
        }
        
        guard let
            _ = Double(self.candidateText)
        else {
            throw ResultFormError(
                message: "Only Decimal numbers are allowed"
            )
        }
    }
    
    private func validationRulesForLimits() throws {
        if let
            maximumValue = self.maximumValue
            where self.result > maximumValue
        {
            self.textFieldView.textField.text = ""
            
            throw ResultFormError(
                message: "The value is too big for \(self.text). \n The maximum value is \(maximumValue)"
            )
        } else if let
            minimumValue = self.minimumValue
            where self.result < minimumValue
        {
            self.textFieldView.textField.text = ""
            
            throw ResultFormError(
                message: "The value is too small for \(self.text) \n The minimum value is \(minimumValue)"
            )
        }
    }
    
  
}

