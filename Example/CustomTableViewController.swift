//
//  CustomTableViewController.swift
//  Example
//
//  Created by Giorgos Tsiapaliokas on 28/04/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GTForms
import SnapKit

class CustomTableViewController: SelectionFormTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let myCustomForm = MyCustomForm(cellClass: CustomTableViewCell.self, reuseIdentifier: "foo")
        registerCustomForm(myCustomForm)

        self.selectionForm.didSelectItem = { _ in
            self.formSections[0].appendRow(myCustomForm, animation: .Fade)
        }

        self.selectionForm.didDeselectItem = { _ in
            self.formSections[0].removeRow(myCustomForm, animation: .Fade)
        }
    }
}

class MyCustomForm: CustomForm {
    override func configureCell(cell: UITableViewCell) {
    }
}

class CustomTableViewCell: UITableViewCell {

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.0
        return textView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.textView)

        self.textView.snp_makeConstraints() { make in
         //   make.edges.equalTo(self.contentView)
             //   .offset(UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10))

            make.top.equalTo(self.contentView).offset(10)
            make.leading.equalTo(self.contentView).offset(10)
            make.trailing.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView).offset(-10).priorityLow()
            make.height.equalTo(200)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}