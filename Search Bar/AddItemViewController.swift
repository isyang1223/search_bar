//
//  AddItemViewController.swift
//  Search Bar
//
//  Created by Ian Yang on 3/26/18.
//  Copyright © 2018 Ian Yang. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    weak var delegate: AddItemViewControllerDelegate?
    var text: String?
    var indexPath: IndexPath?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let text = textField.text!
        delegate?.itemSaved(by: self, with: text, at: indexPath)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = text
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

protocol AddItemViewControllerDelegate: class {
    func cancelButtonPressed(by controller: AddItemViewController)
    func itemSaved (by controller: AddItemViewController, with text: String, at indexPath: IndexPath?)

    }
