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
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public protocol FormTextFieldValueRangeErrorDescriptionDelegate: class {
    func minimumValueErrorDescription(_ value: Any, formText: String) -> String?
    func maximumValueErrorDescription(_ value: Any, formText: String) -> String?
}

public class BaseNumberTextFieldForm<
    T: UITextField,
    L: UILabel, V: Comparable>:
    BaseTextFieldForm<T, L, V>
{
    public var maximumValue: V?
    public var minimumValue: V?
    public weak var descriptionValueErrorDelegate: FormTextFieldValueRangeErrorDescriptionDelegate?

    func validationRulesForLimits() throws {
        if
            let maximumValue = self.maximumValue,
            self.result > maximumValue
        {
            self.textFieldView.textField.text = ""
            errorDidOccur()

            throw ResultFormError(
                message:
                    self.descriptionValueErrorDelegate?.maximumValueErrorDescription(maximumValue, formText: self.text)
                    ??
                    "The value is too big for \(self.text). \n The maximum value is \(maximumValue)"
            )
        } else if let
            minimumValue = self.minimumValue
            , self.result < minimumValue
        {
            self.textFieldView.textField.text = ""
            errorDidOccur()

            throw ResultFormError(
                message:
                self.descriptionValueErrorDelegate?.minimumValueErrorDescription(minimumValue, formText: self.text)
                ??
                "The value is too small for \(self.text) \n The minimum value is \(minimumValue)"
            )
        }
    }

}
