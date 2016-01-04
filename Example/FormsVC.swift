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

    private var formsDict = [String : FormableType]()
    
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

        let doubleForm = FormDoubleTextField(
            text: "SomeDouble",
            placeHolder: "Type a double"
        )

        doubleForm.required = true

        section.addRow(doubleForm)
        
        let maxAndMinForm = FormDoubleTextField(
            text: "Double with limits",
            placeHolder: "Max is 10 and min is 8"
        )

        maxAndMinForm.maximumValue = 10
        maxAndMinForm.minimumValue = 8

        section.addRow(maxAndMinForm)
        
        self.formSections.append(section)

        self.formsDict["Double (Required)"] = doubleForm
        self.formsDict["Double with max and min"] = maxAndMinForm
    }
    
    private func createIntForms() {
        let section = FormSection()

        let intForm = FormIntTextField(
            text: "SomeInt",
            placeHolder: "Type an int"
        )

        intForm.required = true

        section.addRow(intForm)

        let maxAndMinForm = FormIntTextField(
            text: "Int with limits",
            placeHolder: "Max is 10 and min is 8"
        )
        
        maxAndMinForm.maximumValue = 10
        maxAndMinForm.minimumValue = 8
        
        section.addRow(maxAndMinForm)

        
        self.formSections.append(section)

        self.formsDict["Int (Required"] = intForm
        self.formsDict["Int with limits"] = maxAndMinForm
    }
    
    private func createStringForms() {
        let section = FormSection()

        let stringForm = FormTextField(
            text: "String",
            placeHolder: "Type a string"
        )

        section.addRow(stringForm)
        
        let maxAndMinForm = FormTextField(
            text: "String with limits",
            placeHolder: "Max is 10 and min is 8"
        )
        
        maxAndMinForm.maximumLength = 10
        maxAndMinForm.minimumLength = 8
        
        section.addRow(maxAndMinForm)
        
        self.formSections.append(section)

        self.formsDict["String"] = stringForm
        self.formsDict["String with limits"] = maxAndMinForm
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

        self.formsDict["email"] = emailForm
        self.formsDict["phone"] = phoneForm
    }
    
    private func createMiscForms() {
        let switchForm = FormSwitch(text: self.longText)
        switchForm.required = true

        let section = FormSection()
        section.addRow(switchForm)
        
        self.formSections.append(section)
        self.formsDict["Switch (Required)"] = switchForm
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
                "1", "2", "3", self.longText
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
        
        let datePickerForm = FormDatePicker(text: "Birth Date")
        datePickerForm.datePicker.datePickerMode = .Date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        datePickerForm.dateFormatter = dateFormatter
        section.addRow(datePickerForm)
        
        self.formSections.append(section)

        self.formsDict["Short action picker"] = actionSheetPickerForm
        self.formsDict["Long action picker"] = actionSheetPickerForm2
        self.formsDict["Short segmented picker"] = segmentedPicker
        self.formsDict["Long segmented picker"] = segmentedPicker2
        self.formsDict["Date picker"] = datePickerForm
    }
    
    @objc private func didTapResultsButton() {
        var resultJSON = [String : AnyObject]()
        for (key, value) in self.formsDict {

            do {
                var result: AnyObject?
                if let
                    uiForm = value as? FormSegmentedPicker
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormIntTextField
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormActionSheetPicker
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormDoubleTextField
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormSwitch
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormTextField
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormDatePicker
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormEmailTextField
                {
                    result = try uiForm.validate()
                } else if let
                    uiForm = value as? FormPhoneTextField
                {
                    result = try uiForm.validate()
                } else {
                    fatalError("Missing form: \(value.dynamicType)")
                }

                if let result = result {
                    resultJSON[key] = result
                }
            } catch let error {
                if let resultError = error as? ResultFormError {
                    let alertVC = UIAlertController(
                        title: "Validation Error",
                        message: resultError.message,
                        preferredStyle: .Alert
                    )

                    let okAction = UIAlertAction(title: "Ok", style: .Default)
                    { alertAction in
                        alertVC.dismissViewControllerAnimated(true, completion: nil)
                    }
                            
                    alertVC.addAction(okAction)
                    presentViewController(alertVC, animated: true, completion: nil)
                }
            } // end catch
        } // end for

        print(resultJSON)
    }
}
