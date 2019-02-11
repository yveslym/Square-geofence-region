//
//  Helpers.swift
//  SquareRegion
//
//  Created by Yves Songolo on 2/9/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit

struct Helpers{

    public static func showAlert(_ title: String, sender: UIViewController, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message ?? nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        sender.present(alert, animated: true, completion: nil)
    }

    
}
