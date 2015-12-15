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
import GTForms

class FormsVC: FormTableViewController {
   
    private lazy var resultsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Results",
            style: .Done,
            target: self,
            action: Selector("didTapResultsButton")
        )

        return button
    }()
    
    private let doubleForm = FormDoubleTextFieldView(
        title: "SomeDouble",
        placeHolder: "Type a double"
    )
    
    private let intForm = FormIntTextFieldView(
        title: "SomeInt",
        placeHolder: "Type an int"
    )
    
    private let stringForm = FormTextFieldView(
        title: "String",
        placeHolder: "Type a string"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.resultsButton
        
        createDoubleForms()
        createIntForms()
        createStringForms()
        
        let emailForm = FormEmailTextFieldView(
            title: "E-mail",
            placeHolder: "Type your e-mail"
        )
        
        let section = FormSection()
        section.addRow(emailForm)

        self.formSections.append(section)
    }

    private func createDoubleForms() {
        let section = FormSection()
        section.addRow(self.doubleForm)
        
        let maxAndMinForm = FormDoubleTextFieldView(
            title: "Double with limits",
            placeHolder: "Max is 10 and min is 8"
        )

        maxAndMinForm.maximumValue = 10
        maxAndMinForm.minimumValue = 8

        section.addRow(maxAndMinForm)
        
        self.formSections.append(section)
    }
    
    private func createIntForms() {
        let section = FormSection()
        section.addRow(self.intForm)
        
        
        let maxAndMinForm = FormIntTextFieldView(
            title: "Int with limits",
            placeHolder: "Max is 10 and min is 8"
        )
        
        maxAndMinForm.maximumValue = 10
        maxAndMinForm.minimumValue = 8
        
        section.addRow(maxAndMinForm)

        
        self.formSections.append(section)
    }
    
    private func createStringForms() {
        let section = FormSection()
        section.addRow(self.stringForm)
        
        
        let maxAndMinForm = FormTextFieldView(
            title: "String with limits",
            placeHolder: "Max is 10 and min is 8"
        )
        
        maxAndMinForm.maximumLength = 10
        maxAndMinForm.minimumLength = 8
        
        section.addRow(maxAndMinForm)
        
        self.formSections.append(section)
    }
    
    @objc private func didTapResultsButton() {
        print("\(self.doubleForm.dynamicType): \(self.doubleForm.result)")
        print( "\(self.intForm.dynamicType): \(self.intForm.result)")
    }
}
