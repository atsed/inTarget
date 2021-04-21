//
//  UIViewController+Extensions.swift
//  inTarget
//
//  Created by Team on 17.04.2021.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func swapDate(date : String) -> String {
        let oldDAteFormatter = DateFormatter()
        oldDAteFormatter.dateFormat = "dd MM yyyy"
        guard let oldDate = oldDAteFormatter.date(from: date) else {
            return ""
        }
        let newDAteFormatter = DateFormatter()
        newDAteFormatter.dateFormat = "dd MMMM yyyy"
        let newDate = newDAteFormatter.string(from: oldDate)
        return newDate
    }
    
    func animateErrorLable(_ errorLabel : UILabel) {
        UIView.animate(withDuration: 3,
                       delay: 3,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut],
                       animations: {
                        errorLabel.alpha = 0
                       }) { _ in
            errorLabel.alpha = 0
        }
    }
    
    func animatePlaceholderColor(_ titleField : UITextField, _ titleSeparator : UIView) {
        let redColor = UIColor.red.withAlphaComponent(0.5)
        let grayColor = UIColor.gray.withAlphaComponent(0.5)
        titleField.attributedPlaceholder = NSAttributedString(string: titleField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : redColor])
        titleSeparator.backgroundColor = redColor
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            titleField.attributedPlaceholder = NSAttributedString(string: titleField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : grayColor])
            titleSeparator.backgroundColor = .separator
        }
    }
    
    func animateButtonTitleColor(_ button : UIButton) {
        button.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .normal)
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            button.setTitleColor(.accent, for: .normal)
        }
    }
}
