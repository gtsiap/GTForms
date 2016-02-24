//
//  SelectionFormTableViewController.swift
//  Example
//
//  Created by Giorgos Tsiapaliokas on 23/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GTForms

class SelectionFormTableViewController: FormTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let selectionItems = [
            SelectionFormItem(text: "Apple"),
            SelectionFormItem(text: "Orange")
        ]

        let selectionForm = SelectionForm(
            items: selectionItems,
            text: "Choose a fruit"
        )

        selectionForm.textColor = UIColor.redColor()
        selectionForm.textFont = UIFont
            .preferredFontForTextStyle(UIFontTextStyleHeadline)

        selectionForm.allowsMultipleSelection = true

        let section = FormSection()
        section.addRow(selectionForm)
        self.formSections.append(section)


        
        let selectionItems2 = [
            SelectionFormItem(text: "vim"),
            SelectionFormItem(text: "emacs")
        ]

        let selectionForm2 = SelectionForm(
            items: selectionItems2,
            text: "Choose an editor"
        )

        selectionForm2.allowsMultipleSelection = false
        selectionForm2.shouldAlwaysShowAllItems = true

        selectionForm2.didSelectItem = { item in
            print("Did Select: \(item.text)")
        }

        selectionForm2.didDeselectItem = { item in
            print("Did Deselect: \(item.text)")
        }

        let section2 = FormSection()
        section2.addRow(selectionForm2)
        self.formSections.append(section2)

    }

}
