//
//  Storyboarded.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit

protocol Storyboarded: AnyObject {
    static var storyboard: UIStoryboard { get }
    static func instantiate(_ storyboardName: String?) -> Self
}
extension Storyboarded {
    static var storyboard: UIStoryboard {
      return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        let id = String(describing: self)
        if let storyboardName = storyboardName {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: id) as! Self
        } else {
            return self.storyboard.instantiateViewController(withIdentifier: id) as! Self
        }
    }
}
