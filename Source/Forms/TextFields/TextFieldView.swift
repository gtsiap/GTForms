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
import SnapKit

protocol  TextFieldViewType: class {
    var textField: UITextField { get }
    weak var delegate: TextFieldViewDelegate? { get set }
}

protocol TextFieldViewDelegate: class {
    func textFieldViewShouldReturn(
        textFieldView: TextFieldViewType
    ) -> Bool
}

class TextFieldView<T: UITextField, L: UILabel> :
    ControlLabelView<L>,
    TextFieldViewType,
    UITextFieldDelegate
{

    var textField: UITextField {
        return self.field
    }

    lazy private(set) var field: T = {
        let textField = T()
        
        textField.addTarget(
            self,
            action: #selector(editingChanged),
            forControlEvents: .EditingChanged
        )
        
        textField.borderStyle = .None
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var textWillChange: ((text: String) -> (Bool))?
    var textDidChange: ((text: String) -> ())?
    var didPressReturnButton: (() -> ())?
    weak var delegate: TextFieldViewDelegate?
    
    override init() {
        super.init()
        
        self.control = self.field
        
        configureView() { (label, control) in
            
            label.snp_makeConstraints() { make in
                make.left.equalTo(self)
                make.top.equalTo(self)
                make.width.equalTo(self).multipliedBy(0.3)
                make.bottom.equalTo(self)
            } // end label
            
            
            control.snp_makeConstraints() { make in
                make.left.equalTo(label.snp_right).offset(10)
                make.right.equalTo(self)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
            } // end control
            
        } // end configureView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func editingChanged() {
        guard let
            text = self.field.text
        else { return }

        self.textDidChange?(text: text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let delegate = self.delegate else {
            print("\(#file):\(#line): Missing Delegate!!")
            return false
        }

        if !delegate.textFieldViewShouldReturn(self) {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textField(
        textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard let
            textWillChange = self.textWillChange
        else { return true }
        
        return textWillChange(text: string)
    }
 
    func textFieldDidEndEditing(textField: UITextField) {
        self.didPressReturnButton?()
    }
}
