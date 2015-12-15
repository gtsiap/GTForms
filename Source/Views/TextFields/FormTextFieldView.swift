// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

