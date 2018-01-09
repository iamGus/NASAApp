//
//  RoverDetailController.swift
//  NASAApp
//
//  Created by Angus Muller on 08/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

// Currently images are not catched, in production app could use libary like Kingfisher to cache images to stop possible multiple downloads.

import UIKit

class RoverDetailController: UIViewController {
    
    @IBOutlet weak var roverPhotoView: UIImageView!
    @IBOutlet weak var addTextLabel: UIButton!
    
    var roverPhoto: RoverPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If roverPhoto type contains needed data
        if let fullSizeImage = roverPhoto, let url = URL(string: fullSizeImage.photoUrl) {
            roverPhotoView.image = fullSizeImage.photo
            
            // get full res image async and display image
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.roverPhotoView.image = UIImage(data: data)
                    }
                    
                // If cannot get image form internet then inform user
                } catch let error {
                    print("Error getting image from internet: \(error)")
                    self.errorAlert(title: "Error: Could not load image", description: "Sorry unable to load full size image, please check your internet connection")
                }
                
                
            }
        } else {
            // If Rover Photo type not containging correct data then inform user
            print("Error: roverPhoto does not contain data needed to show full image")
            errorAlert(title: "Error: Could not load image", description: "Sorry but image could not be loaded")
        }
    }
    
    
    //Share image incluing email
    @IBAction func shareImage(_ sender: Any) {
        //image is fource unwrapped as error / checking already been done above in ViewDidLoad
        let activityViewController = UIActivityViewController(activityItems: [roverPhotoView.image!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // Setting up delegate for PopupRoverController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "roverPopup") {
            if let popUpViewController = segue.destination as? PopupRoverController {
            popUpViewController.delegate = self
            }
        }
    }
}

// After text enetered in popup
extension RoverDetailController: textEnteredDelegate {
    func addTextToImage(text: String) {
        
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 30))
        label.text = text
        self.view.addSubview(label)
        
        roverPhotoView.drawOnCurrentImage(view: label, mode: .changeOriginalImage) { (parentSize, viewToAdd) in
            viewToAdd.font = UIFont.systemFont(ofSize: 40)
            viewToAdd.textColor = .yellow
            viewToAdd.textAlignment = .center
            let height: CGFloat = 30
            let indent: CGFloat = 40
            viewToAdd.bounds = CGRect(x: 0, y: parentSize.height - height - indent, width: parentSize.width, height: height)
        }
        //Do not allow adding of more text
        addTextLabel.isHidden = true
    }

}

//MARK: Helper

extension RoverDetailController {
    
    /// Show alert with OK action sending back to previous view
    func errorAlert(title: String, description: String) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            _ = self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
