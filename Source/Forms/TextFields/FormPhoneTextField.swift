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

public class FormPhoneTextField: BaseStringTextFieldForm {
    
    public override init(text: String, placeHolder: String) {
        super.init(text: text, placeHolder: placeHolder)
        self.textField.keyboardType = .PhonePad
    }
    
    public override func validate() throws -> String? {
        guard let
            _ = try super.validate()
        else { return nil }
              
        // validate email
        let phoneReg =
        "(\\+[0-9]+[\\- \\.]*)?"
            + "(\\([0-9]+\\)[\\- \\.]*)?"
            + "([0-9][0-9\\- \\.]+[0-9])"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneReg)
        guard let
            result = result
        where
            phoneTest.evaluateWithObject(self.result) &&
            (result.characters.count >= 10 && result.characters.count <= 20)
        else {
            throw ResultFormError(
                message: "Invalid phone number"
            )
        }
        
        return self.result
    }
    
}