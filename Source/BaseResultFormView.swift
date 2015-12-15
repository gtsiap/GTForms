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
public class BaseResultFormView<T>: FormViewableType {
    /**
        The Result of the form
     */
    private(set) var result: T?
    
    /**
        This closure is being called when the result
        gets changed
     */
    public var didUpdateResult: ((result: T?) -> ())?
    
    /**
        If true then this formView is required and `validate`
        will throw if this formView doesn't have a value
     */
    public var required: Bool = true
    
    /**
        - returns: The UIView of the form
     */
    public func formView() -> UIView {
        fatalError("Missing implementation: \(self.dynamicType)")
    }
    
    /**
        The text of the form
     */
    public var text = ""
    
    /**
        The viewController of the form
     */
    public weak var viewController: UIViewController?
    
    public init() {}
    
    /**
        In this method you must add your validation code.
        Most of the forms need some kind of validation.
        - returns: The result of the form
        - throws: FormViewError
     */
    public func validate() throws -> T? {
        guard self.required else { return nil }
        
        guard let _ = self.result else {
            throw ResultFormViewError(message: "Missing value for \(self.text)")
        }
        
        return self.result
    }
    
    /**
        Internally this method calls `validate`
        if an error exists it will try to show it
        if `viewController` is set
        - returns: The result of the form
        - throws: FormViewError
     */
    public func retrieveResult() throws -> T? {
        do {
            return try self.validate()
        } catch let error {
            guard let
                err = error as? ResultFormViewError
            else { return nil }
            
            showValidationError(err.message)
            return nil
        }
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
