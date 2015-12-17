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
   
    private var longText: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    
    private lazy var resultsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Results",
            style: .Done,
            target: self,
            action: Selector("didTapResultsButton")
        )

        return button
    }()
    
    private let doubleForm = FormDoubleTextField(
        text: "SomeDouble",
        placeHolder: "Type a double"
    )
    
    private let intForm = FormIntTextField(
        text: "SomeInt",
        placeHolder: "Type an int"
    )
    
    private let stringForm = FormTextFieldView(
        text: "String",
        placeHolder: "Type a string"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.resultsButton
        
        createDoubleForms()
        createIntForms()
        createStringForms()
        createInfomationForms()
        createMiscForms()
        createPickers()
    }

    private func createDoubleForms() {
        let section = FormSection()
        section.addRow(self.doubleForm)
        
        let maxAndMinForm = FormDoubleTextField(
            text: "Double with limits",
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
        
        
        let maxAndMinForm = FormIntTextField(
            text: "Int with limits",
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
            text: "String with limits",
            placeHolder: "Max is 10 and min is 8"
        )
        
        maxAndMinForm.maximumLength = 10
        maxAndMinForm.minimumLength = 8
        
        section.addRow(maxAndMinForm)
        
        self.formSections.append(section)
    }
    
    private func createInfomationForms() {
        let emailForm = FormEmailTextField(
            text: "E-mail",
            placeHolder: "Type your e-mail"
        )
        
        let section = FormSection()
        section.addRow(emailForm)
        
        
        let phoneForm = FormPhoneTextField(
            text: "Phone",
            placeHolder: "Type your phone"
        )
        
        section.addRow(phoneForm)
        
        self.formSections.append(section)

    }
    
    private func createMiscForms() {
        let emailForm = FormSwitch(text: self.longText)
        
        let section = FormSection()
        section.addRow(emailForm)
        
        self.formSections.append(section)
    }
    
    private func createPickers() {
        let actionSheetPickerForm = FormActionSheetPicker(
            text: "Choose a number",
            items: [
                "one", "two", "three"
            ]
        )
        
        let actionSheetPickerForm2 = FormActionSheetPicker(
            text: self.longText,
            items: [
                "1", "2", "3"
            ]
        )

        let section = FormSection()
        section.addRow(actionSheetPickerForm)
        section.addRow(actionSheetPickerForm2)

        let items = [
            "one", "two", "three",
            "four", "five", "six",
            "seven", "eight", "nine"
        ]
        
        let segmentedPicker = FormSegmentedPicker(
            text: "Choose",
            items: items
        )
        
        let segmentedPicker2 = FormSegmentedPicker(
            text: self.longText,
            items: items
        )
        
        section.addRow(segmentedPicker)
        section.addRow(segmentedPicker2)
        
        let datePicker = FormDatePicker(text: "BirthDate")
        section.addRow(datePicker)
        
        self.formSections.append(section)
    }
    
    @objc private func didTapResultsButton() {
        self.doubleForm.required = true
        
        let _ = try? self.doubleForm.retrieveResult()
    }
}
