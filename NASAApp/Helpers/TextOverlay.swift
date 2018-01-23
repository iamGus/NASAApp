//
//  TextOverlay.swift
//  NASAApp
//
//  Created by Angus Muller on 09/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

// Overlaying Text on image extensions

import UIKit

extension UIView {
    func copyObject<T: UIView> () -> T? {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? T
    }
}

// Helper: Gets a UIView (thats the view that has the text in it), adds this view on top of image and returns new image
extension UIImage {
    
    typealias EditSubviewClosure<T: UIView> = (_ parentSize: CGSize, _ viewToAdd: T)->()
    
    func with<T: UIView>(view: T, editSubviewClosure: EditSubviewClosure<T>) -> UIImage {
        
        if let copiedView = view.copyObject() as? T {
            UIGraphicsBeginImageContext(size)
            
            let basicSize = CGRect(origin: .zero, size: size)
            draw(in: basicSize)
            editSubviewClosure(size, copiedView)
            copiedView.draw(basicSize)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return self
        
    }
}

// This is what is actually called from RoverDetailController.
extension UIImageView {
    
    enum ImageAddingMode {
        case changeOriginalImage
        case addSubview
        case addCopiedSubview
    }
    
    func drawOnCurrentImage<T: UIView>(view: T, mode: ImageAddingMode, editSubviewClosure: @escaping UIImage.EditSubviewClosure<T>) {
        
        guard let image = image else {
            return
        }
        
        let addSubView: (T) -> () = { view in
            editSubviewClosure(self.frame.size, view)
            self.addSubview(view)
        }
        
        switch mode {
        case .changeOriginalImage:
            self.image = image.with(view: view, editSubviewClosure: editSubviewClosure)
            
        case .addSubview:
            addSubView(view)
            
        case .addCopiedSubview:
            if let copiedView = view.copyObject() as? T {
                addSubView(copiedView)
            }
        }
    }
}

