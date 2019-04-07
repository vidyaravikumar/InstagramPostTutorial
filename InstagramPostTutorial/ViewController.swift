//
//  ViewController.swift
//  InstagramPostTutorial
//
//  Created by Vidya Ravikumar on 4/6/19.
//  Copyright © 2019 Vidya Ravikumar. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        shareToInstagram()
    }
    
    func shareToInstagram() {
        guard let eventImage = UIImage(named: "image1") else {
            return
        }
        
        guard let instagramBackground = UIImage(named: "InstagramExportBackground") else {
            return
        }
        
        // Probably don't need to pass in the background image and can just load it in the function itself
        let overlayedImage = UIImage.imageByMergingImages(eventImage: eventImage, backgroundImage: instagramBackground, topText: "Looking for the best Social Experience?", profileLink: "www.cozmicgo.com/janedoe")
        
        UIImageWriteToSavedPhotosAlbum(overlayedImage, nil, nil, nil)
        let instagramURL = URL(string: "instagram://app")
        
        if UIApplication.shared.canOpenURL(instagramURL!) {
            UIApplication.shared.open(URL(string: "instagram://library?AssetPath=assets-library")!, options: [:]) { (success) in
                if !success {
                    // alert view not working?
                    let alertController = UIAlertController.init(title: "Instagram was not able to open!", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
                        print(action)
                    })
                    alertController.addAction(cancel)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("Openning was a success is a \(success) statement.")
                }
            }
        } else {
            // alert view not working?
            let alertController = UIAlertController.init(title: "Instagram is not installed!", message: "Please download Instagram to be able to share your event.", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
                print(action)
            })
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
            print("Instagram isn't installed.")
        }
    }
}


extension UIImage {
    
    static func imageByMergingImages(eventImage: UIImage, backgroundImage: UIImage, topText: String, profileLink: String) -> UIImage {
        
        let size = CGSize(width: 1080, height: 1080) // 1080 x 1080 is the instagram post image size
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .high
        
        // resizing image so that aspect ratio is not changed
        let eventImageView = UIImageView(image: eventImage)
        
        var height: CGFloat
        var width: CGFloat
        
        if eventImageView.frame.width < eventImageView.frame.height {
            height = eventImageView.frame.height * 620 / eventImageView.frame.width
            width = 620
        } else {
            width = eventImageView.frame.width * 620 / eventImageView.frame.height
            height = 620
        }
        
        let eventContainer = CGRect(x: 560 - (width / 2), y: 616 - (height / 2), width: width, height: height)
        
        // adding the event image
        eventImageView.image!.draw(in: eventContainer)
        
        // adding the background image
        let backgroundContainer = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundImage.draw(in: backgroundContainer)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let topTextFontAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.92, green: 0.12, blue: 0.5, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "DejaVuSerif", size: 50),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ] as [NSAttributedString.Key: Any]

        // adding the top text
        let topTextContainer = CGRect(x: 0, y:40, width: size.width, height: 266)
        topText.draw(in: topTextContainer, withAttributes: topTextFontAttributes)
        
        let bottomTextFontAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.92, green: 0.12, blue: 0.5, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "DejaVuSerif", size: 40),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
            ] as [NSAttributedString.Key: Any]
        
        // adding the bottom text
        let bottomTextContainer = CGRect(x: 0, y:966, width: size.width, height: 94)
        "Sign up here:  \(profileLink)".draw(in: bottomTextContainer, withAttributes: bottomTextFontAttributes)
        
        let overlayedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return overlayedImage!
    }
}
