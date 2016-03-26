// Copyright (c) 2015-2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

/**
    - NOTE: All the forms must comfort to this protocol
*/
public protocol FormableType {}

/**
 - NOTE: If your form has custom UI then you must comform
         to this protocol. Otherwise FormTableViewController
         won't add your view in the UI
 */
public protocol FormViewableType: class, FormableType {
    func formView() -> UIView
    var viewController: UIViewController? { get set }
}

extension FormViewableType {
    /**
        If the validation fails you can use this method
        in order to inform the user about it.
     
        - param error: The error that will be displayed to the user
        - NOTE: You don't have to show the errors manually
        FormTableViewController will do it for you.
        This method can be used before its time
        for the FormTableViewController to check
        the forms for validation errors.
        For example you may have a form which accepts
        only Ints and the user will try to add a double
        this action will FormTableViewController's check,
        so in this case you could use if you want the
        showValidationError prematurely
     */
    public func showValidationError(error: String) {
        let alertVC = UIAlertController(
            title: "Validation Error",
            message: error,
            preferredStyle: .Alert
        )
                
        let okAction = UIAlertAction(title: "Ok", style: .Default)
        { alertAction in
            alertVC.dismissViewControllerAnimated(true, completion: nil)
        }

        alertVC.addAction(okAction)
        self.viewController?.presentViewController(
            alertVC,
            animated: true,
            completion: nil
        )
    }
}
