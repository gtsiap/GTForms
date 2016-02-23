//
//  SelectionItem.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 23/02/16.
//  Copyright © 2016 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class SelectionFormItem: FormableType {
    public let text: String
    public let detailText: String?
    public let accessoryType: UITableViewCellAccessoryType

    weak var selectionForm: SelectionForm?

    public var selected: Bool = false

    public init(
        text: String,
        detailText: String? = nil,
        accessoryType: UITableViewCellAccessoryType = .Checkmark
    ) {
        self.text = text
        self.detailText = text
        self.accessoryType = accessoryType
    }

}