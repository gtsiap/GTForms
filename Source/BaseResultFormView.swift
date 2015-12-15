//
//  BaseResultFormView.swift
//  GTForms
//
//  Created by Giorgos Tsiapaliokas on 15/12/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public struct ResultFormViewError: ErrorType {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

/**
    This is the base class for all the read-write forms
*/
public class BaseResultFormView<T: AnyObject>: UIView {
    /**
        The Result of the form
     */
    public private(set) var result: T?
    
    /**
        This closure is being called when the result
        gets changed
     */
    public var didUpdateResult: ((result: AnyObject?) -> ())?
    
    /**
        If true then this formView is required and **FormTableViewController**
        will show an error if this formView doesn't have a value
     */
    public var required: Bool = true
    
    public init() {
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
        In this method you must add your validation code.
        Most of the forms need some kind of validation.
        Subclass should call this implementation in the **start**
        of their implementation
     - throws: FormViewError
     */
    public func validate() throws {
        guard let _ = self.result
            where self.required
        else { throw ResultFormViewError(message: "Missing form \(self.dynamicType)") }
    }
    
    /**
        The subclasses must use this method in order to update
        the result
     */
    func updateResult(result: T) {
        self.result = result
        self.didUpdateResult?(result: self.result)
    }
    
}

extension BaseResultFormView: FormViewableType {}
