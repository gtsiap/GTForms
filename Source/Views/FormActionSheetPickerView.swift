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
import SnapKit

class ActionSheetPicker: ControlLabelView  {
    
    var valueDidChange: ((String) -> ())?
    var items = [String]()
    weak var viewController: UIViewController?
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .System)
        
        button.setTitle("Choose", forState: .Normal)
        button.addTarget(
            self,
            action: "didTapButton",
            forControlEvents: .TouchUpInside
        )
        
        return button
    }()
    
    override init() {
        super.init()
        
        self.control = self.button
        
        configureView() { (label, control) in
            
            label.snp_makeConstraints() { make in
                make.left.equalTo(self).offset(10)
                make.top.equalTo(self).offset(10)
                make.bottom.equalTo(self).offset(-10)
            } // end label
            
            
            control.snp_makeConstraints() { make in
                make.left.equalTo(label.snp_right)
                make.right.equalTo(self).offset(-10)
                make.centerY.equalTo(label.snp_centerY)
            } // end control
            
        } // end configureView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(
            title: "Please Choose one",
            message: nil,
            preferredStyle: .ActionSheet
        )
        
        for it in self.items {
            let action = UIAlertAction(title: it, style: .Default) { action in
                guard let title = action.title else { return }
                self.button.setTitle(title, forState: .Normal)
                self.valueDidChange?(title)
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.viewController?.presentViewController(alert, animated: true, completion: nil)
    }
}

public class FormActionSheetPickerView: BaseResultFormView<String> {
    
    private let title: String
    private let picker = ActionSheetPicker()
    
    public override weak var viewController: UIViewController? {
        didSet { self.picker.viewController = self.viewController }
    }
    
    public init(title: String, items: [String]) {
        self.title = title
        super.init()
        
        self.picker.controlLabel.text = title
        self.picker.items = items
        
        self.picker.valueDidChange = { result in
            self.updateResult(result)
        }
    }
    
    public override func validate() throws {}
    
    public override func formView() -> UIView {
        return self.picker
    }
    
}

