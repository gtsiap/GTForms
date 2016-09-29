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

public protocol FormTextFieldValueLengthErrorDescriptionDelegate: class {
    func minimumLengthErrorDescription(_ value: Any, formText: String) -> String?
    func maximumLengthErrorDescription(_ value: Any, formText: String) -> String?
}

public class FormTextField<T: UITextField, L: UILabel>: BaseStringTextFieldForm<T, L> {

    public override init(text: String, placeHolder: String) {
        super.init(text: text, placeHolder: placeHolder)
    }

    public weak var descriptionLengthErrorDelegate: FormTextFieldValueLengthErrorDescriptionDelegate?

    public var maximumLength: Int?
    public var minimumLength: Int?
    
    public override func validate() throws -> String? {
        guard let
            _ = try super.validate()
        else { return nil }

        guard let result = self.result else {
            return nil
        }

        if result.isEmpty {
            return nil
        }

        if let
            maximumLength = self.maximumLength
            , result.characters.count > maximumLength
        {
            self.textFieldView.textField.text = ""

            errorDidOccur()

            throw ResultFormError(
                message: self.descriptionLengthErrorDelegate?.maximumLengthErrorDescription(result, formText: self.text)
                ??
                "\(self.text) is too long"
            )
        } else if let
            minimumLength = self.minimumLength
            , result.characters.count < minimumLength
        {
            self.textFieldView.textField.text = ""

            errorDidOccur()

            throw ResultFormError(
                message:
                self.descriptionLengthErrorDelegate?.minimumLengthErrorDescription(result, formText: self.text)
                ??
                "\(self.text) is too short"
            )
        }
        
        return self.result
    }
    
    
}

