//
//  Extensions.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import UIKit
import RxRelay
import RxSwift

extension String {
    
    func convertToDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (self.count > 10) ? "yyyy-MM-dd HH:mm:ss" : "yyyy-MM-dd"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let result = dateFormatter.date(from: self) {
            return result
        }
        
        return nil;
        
    }
    
    func toInt32() -> Int32 {
        return Int32(self)!
    }
    
}

extension Date {
    
    func get(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "id-ID")
        
        let result = dateFormatter.string(from: self)
        return result
    }
    
    func getDateTime() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id-ID")
        
        let result = dateFormatter.string(from: self)
        return result
    }
    func getDate(customFormat:String = "dd-MMM-yyyy") -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = customFormat
        dateFormatter.locale = Locale(identifier: "id-ID")
        
        let result = dateFormatter.string(from: self)
        return result
    }
    func getTime() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "id-ID")
        
        let result = dateFormatter.string(from: self)
        return result
    }
    
}

extension UIViewController {
    
    func showErrorAlert(message:String)  {
        self.showAlert(title: "Error", message: message)
    }
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    static func createInstance() -> UIViewController {
        let vcName = String(describing: self.self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: vcName)
        
        return nextViewController;
    }
    
}

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    
    func acceptAppending(_ element: Element) {
        accept(value + element)
    }
    
    func acceptAppending(_ element: Element.Element) {
        accept(value + [element])
    }
    
}

extension Reactive where Base : UITableView {
    
    
    //TODO : still emits multiple times, need to improve some kinda distinctuntilchanged things
    func onReachBottomOffset(bottomOffset: CGFloat, fetchNewData: @escaping () -> ()) -> Disposable {
        
        base.rx.contentOffset
            .map({ $0.y })
            .filter({ contentOffsetY in
                return contentOffsetY + base.frame.size.height + bottomOffset > base.contentSize.height
            })
            .subscribe({_ in
                fetchNewData()
                print("Fetch New Items")
            })
    }
    
}

extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
