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

private class DatePickerView: ControlLabelView  {
    
    private var heightConstraint: Constraint!
    private var hiddenConstraints = [Constraint]()
    private var visibleConstraints = [Constraint]()

    lazy private(set) var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.addTarget(
            self,
            action: "dateValueDidChange",
            forControlEvents: .ValueChanged
        )
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    let displayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    var valueDidChange: ((NSDate) -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        
        self.control = self.displayLabel
        
        configureView() { (label, control) in
            
            label.snp_makeConstraints() { make in
                make.left.equalTo(self).offset(10)
                make.width.equalTo(self).multipliedBy(0.4)
                make.top.equalTo(self).offset(10)
                self.hiddenConstraints.append(
                    make.bottom.equalTo(self).offset(-10).constraint
                )
            } // end label
            
            
            control.snp_makeConstraints() { make in
                make.right.equalTo(self).offset(-10)
                make.top.equalTo(self).offset(10)
                self.hiddenConstraints.append(
                    make.bottom.equalTo(self).offset(-10).constraint
                )
            } // end control
            
        } // end configureView
        
        addSubview(self.datePicker)
        self.datePicker.snp_makeConstraints() { make in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            
            self.hiddenConstraints.append(
                make.height.equalTo(0).constraint
            )
            self.visibleConstraints.append(
                make
                .bottom
                .equalTo(self)
                .offset(-10)
                .constraint
            )
            
            self.visibleConstraints.append(
                make
                .top
                .equalTo(self.controlLabel)
                .offset(10)
                .constraint
            )
            
            self.visibleConstraints.append(
                make
                .top
                .equalTo(self.displayLabel)
                .offset(10)
                .constraint
            )
        }
        
        shrink()
    }
        
    func expand() {
        self.hiddenConstraints.forEach() {
            $0.deactivate()
        }
        
        self.visibleConstraints.forEach() {
            $0.activate()
        }
    }
        
    func shrink() {
        self.visibleConstraints.forEach() {
            $0.deactivate()
        }
        
        self.hiddenConstraints.forEach() {
            $0.activate()
        }
    }
    
    @objc private func dateValueDidChange() {
        self.valueDidChange?(self.datePicker.date)
    }
}


public class FormDatePicker: BaseResultForm<NSDate> {
    
    private let datePickerView = DatePickerView()
    
    public var shouldExpand: Bool = false
    /**
        The UIDatePicker of the form
     */
    public var datePicker: UIDatePicker {
        return self.datePickerView.datePicker
    }
    
    /**
        The text label of form
     */
    public var textLabel: UILabel {
        return self.datePickerView.controlLabel
    }
    
    /**
        The date label of form
     */
    public var dateLabel: UILabel {
        return self.datePickerView.displayLabel
    }
    
    /**
        The dateFormatter will be used for the
        date label
     */
    public var dateFormatter: NSDateFormatter? {
        didSet { changeDisplayedDate() }
    }
    
    public init(text: String) {
        super.init()
        
        self.text = text
        self.datePickerView.controlLabel.text = self.text
        
        self.datePickerView.valueDidChange = { result in
            self.changeDisplayedDate()
            self.updateResult(result)
        }
        
        self.changeDisplayedDate()
    }
    
    public override func formView() -> UIView {
        return self.datePickerView
    }
    
    private func changeDisplayedDate() {
        
        let date = self.datePicker.date
        if let dateFormatter = self.dateFormatter {
            self.datePickerView.displayLabel.text =
                dateFormatter.stringFromDate(date)
            return
        }
        
        self.datePickerView.displayLabel.text = String(date)
    }
}

extension FormDatePicker: FormCellExpandable {
    public func toogleExpand() {
        if self.shouldExpand {
            self.datePickerView.expand()
        } else {
            self.datePickerView.shrink()
        }
    }
}