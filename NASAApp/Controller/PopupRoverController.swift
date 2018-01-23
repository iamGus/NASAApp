//
//  PopupRoverController.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

// Popup view to enter text that will be displayed ontop of image

import UIKit

protocol textEnteredDelegate: class {
    func addTextToImage(text: String)
}

class PopupRoverController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorText: UILabel!
    
    weak var delegate: textEnteredDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
    @IBAction func addText(_ sender: Any) {
        guard let text = textField.text, text != "" else {
            //Show error message as of no text enetered
            errorText.isHidden = false
            return
        }
        
        delegate?.addTextToImage(text: text)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
