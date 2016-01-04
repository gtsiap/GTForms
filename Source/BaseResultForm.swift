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

public struct ResultFormError: ErrorType {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

/**
    This is the base class for all the read-write forms
*/
public class BaseResultForm<T>: FormViewableType {
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
    public var required: Bool = false
    
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
        - throws: ResultFormError
     */
    public func validate() throws -> T? {

        if self.required {
        guard let _ = self.result else  {
            throw ResultFormError(message: "Missing value for \(self.text). \n \(self.text) is Required")
        }
        }
        return self.result
    }
    
    /**
        Internally this method calls `validate`
        if an error exists it will try to show it
        if `viewController` is set
        - returns: The result of the form
        - throws: ResultFormError
     */
    public func retrieveResult() throws -> T? {
        do {
            return try self.validate()
        } catch let error {
            guard let
                err = error as? ResultFormError
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
