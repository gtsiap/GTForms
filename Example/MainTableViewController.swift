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
import GTForms

class MainTableViewController: FormTableViewController {
    private lazy var formButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Forms",
            style: .Done,
            target: self,
            action: #selector(didTapFormButton)
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.formButton

        let section = FormSection()
        section.addRow(StaticForm(text: "Forms")).didSelectRow = {
            self.performSegueWithIdentifier("showForms", sender: self)
        }

        section.addRow(StaticForm(text: "Selection Form")).didSelectRow = {
            self.performSegueWithIdentifier("showSelectionForm", sender: self)
        }

        section.addRow(StaticForm(text: "Date Pickers")).didSelectRow = {
            self.performSegueWithIdentifier("showDatePickers", sender: self)
        }

        section.addRow(StaticForm(text: "Test Keyboard")).didSelectRow = {
            self.performSegueWithIdentifier("showTestKeyboard", sender: self)
        }

        let originalText = NSMutableAttributedString(string: "Text with ")

        let text =  NSAttributedString(
            string: "Color",
            attributes: [NSForegroundColorAttributeName: UIColor.greenColor()]
        )

        originalText.appendAttributedString(text)

        section.addRow(AttributedStaticForm(text: originalText))

        section.addRow(StaticForm(text: "Custom Form")).didSelectRow = {
            self.performSegueWithIdentifier("showCustomForm", sender: self)
        }

        self.formSections.append(section)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "showFormsModally" {
            return
        }

        guard let
            nv = segue.destinationViewController as? UINavigationController,
            vc = nv.topViewController as? FormsVC
        else {
            return
        }

        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(didTapCancelButton)
        )
    }

    @objc private func didTapFormButton() {
        self.performSegueWithIdentifier("showFormsModally", sender: self)
    }

    @objc private func didTapCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
