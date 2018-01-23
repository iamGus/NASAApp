//
//  ProgressView.swift
//  NASAApp
//
//  Created by Angus Muller on 18/01/2018.
//  Copyright © 2018 Angus Muller. All rights reserved.
//

// My own try at writing a progress view that can be used throughout the app
// Currently using some constants which I attend to change further on in development

import UIKit

class ProgressView: UIView {
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var overlay = UIView()
    var label = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    // Create a activity indicator view
    // Returns the activity indicator view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //isHidden = true
        self.alpha = 0.0
        setupOverlay()
        setupText()
        setupActivityIndicator()
    }
    
    // Sets up the base overlay that is the same size as of the frame it shall be overlaying onto
    private func setupOverlay() {
        overlay.backgroundColor = UIColor.lightGray
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.layer.cornerRadius = 8.0
        overlay.layer.masksToBounds = true
        self.addSubview(overlay)
        overlay.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        overlay.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        overlay.widthAnchor.constraint(equalToConstant: 200).isActive = true
        overlay.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func setupText() {
        label.text = "Loading..."
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(label)
        label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor, constant: activityIndicator.frame.width + 10).isActive = true
        label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -10).isActive = true
    }
    
    
    func startAnimating() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }) { (complete) in
            self.activityIndicator.stopAnimating()
        }
        
    }
    
}
