//
//  NavigationController.swift
//  Tesla
//
//  Created by Sahat Yalkabov on 3/6/15.
//  Copyright (c) 2015 Sahat Yalkabov. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println(textField.text)
        searchTextField.resignFirstResponder()
        return true
    }
}