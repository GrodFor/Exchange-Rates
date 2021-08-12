//
//  ReusableView.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension UITableView{
    func register<T: UITableViewCell>(_ : T.Type){
        let nib = UINib(nibName: T.defaultReuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func registerNibLess<T: UITableViewCell>(_ : T.Type){
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type){
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.defaultReuseIdentifier, bundle: bundle)
        debugPrint(T.defaultReuseIdentifier)
        register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue with identifier: \(T.defaultReuseIdentifier)")
        }

        return view
    }
    
}
