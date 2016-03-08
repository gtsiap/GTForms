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

private class ButtonLabel: UIControl {
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        return label
    }()

    var text: String = "" {
        didSet { self.label.text = self.text }
    }

    private override func didMoveToSuperview() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.textColor = self.tintColor

        addSubview(self.label)

        self.label.snp_makeConstraints() { make in
            make.edges.equalTo(self)
        }
    }

    private var previousColor: UIColor?

    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        self.label.textColor = self.previousColor
        self.label.textColor = UIColor.grayColor()
        return true
    }

    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {

        if let textColor = self.previousColor {
            self.label.textColor = textColor
        }

        sendActionsForControlEvents(.TouchUpInside)
    }

}

private class ActionSheetPicker: ControlLabelView  {
    var valueDidChange: ((String) -> ())?
    var items = [String]()
    weak var viewController: UIViewController?
    var scrollToRow: Bool = false

    lazy var button: ButtonLabel = {
        let button = ButtonLabel()
        button.text = "Choose"
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
                make.left.equalTo(self)
                make.width.equalTo(self).multipliedBy(0.6)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
            } // end label
            
            control.snp_makeConstraints() { make in
                make.right.equalTo(self)
                make.centerY.equalTo(label.snp_centerY).priorityLow()
                make.width.equalTo(self).multipliedBy(0.3)
                make.bottom.equalTo(self)
                make.top.equalTo(self)
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
                self.button.text = title
                self.valueDidChange?(title)

                guard let
                    vc = self.viewController
                        as? UITableViewController
                else { return }


                let point = vc.tableView.convertPoint(self.frame.origin, fromView: self)
                guard let
                    indexPath = vc.tableView.indexPathForRowAtPoint(point)
                else { return }

                vc.tableView.reloadRowsAtIndexPaths(
                    [indexPath],
                    withRowAnimation: .None
                )

                if self.scrollToRow {
                    vc.tableView.scrollToRowAtIndexPath(
                        indexPath,
                        atScrollPosition: .None,
                        animated: false
                    )
                }
            }

            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        guard let vc = self.viewController else {
            print("\(__FILE__):\(__LINE__): view controller doesn't exist")
            return
        }

        if let popoverVC  = alert.popoverPresentationController {
            popoverVC.sourceView = self.button
            popoverVC.sourceRect = self.button.bounds
        }

        vc.presentViewController(alert, animated: true, completion: nil)
    }

    override func tintColorDidChange() {
        self.button.label.textColor = self.tintColor
    }
}

public class FormActionSheetPicker: BaseResultForm<String> {
    
    private let picker = ActionSheetPicker()
    
    public override weak var viewController: UIViewController? {
        didSet { self.picker.viewController = self.viewController }
    }

    /**
        If true, the tableView will scroll to the current row,
        when the value changes.
    */
    public var scrollToRow: Bool = false {
        didSet {
            self.picker.scrollToRow = self.scrollToRow
        }
    }

    /**
        Changes the result of the form.
     */
    public var optionText: String {
        set(value) {
            self.picker.button.label.text = value
            updateResult(value)
        }

        get {
            return self.result ?? "Choose"
        }
    }

    public init(text: String, items: [String]) {
        super.init()
        
        self.text = text

        self.picker.controlLabel.text = text
        self.picker.items = items
        
        self.picker.valueDidChange = { result in
            self.updateResult(result)
        }
    }
    
    public override func formView() -> UIView {
        return self.picker
    }

}

