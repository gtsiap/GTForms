//
//  StaticFormView.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 15/12/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

/**
    This class is used for read only forms.
*/
public struct StaticForm: FormableType {
    let text: String
    let detailText: String?
    
    public init(text: String, detailText: String? = nil) {
        self.text = text
        self.detailText = text
    }

}
