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
    
    
    var roverPhoto: RoverPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let fullSizeImage = roverPhoto, let url = URL(string: fullSizeImage.photoUrl) {
            roverPhotoView.image = fullSizeImage.photo
        
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.roverPhotoView.image = UIImage(data: data!) //NOTE: Checking image data there or bringing up error
                    
                }
            }
        }
    }
    
    
    @IBAction func shareImage(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [roverPhotoView.image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "roverPopup") {
            if let popUpViewController = segue.destination as? PopupRoverController {
            popUpViewController.delegate = self
            }
        }
    }
}

extension RoverDetailController: textEnteredDelegate {
    func addTextToImage(text: String) {
        
        let label = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 30))
        label.text = text
        self.view.addSubview(label)
        
        roverPhotoView.drawOnCurrentImage(view: label, mode: .changeOriginalImage) { (parentSize, viewToAdd) in
            viewToAdd.font = UIFont.systemFont(ofSize: 40)
            viewToAdd.textColor = .yellow
            viewToAdd.textAlignment = .center
            let width: CGFloat = 200
            let height: CGFloat = 30
            let indent: CGFloat = 40
            viewToAdd.bounds = CGRect(x: 0, y: parentSize.height - height - indent, width: parentSize.width, height: height)
        }
    }
    
    
}
