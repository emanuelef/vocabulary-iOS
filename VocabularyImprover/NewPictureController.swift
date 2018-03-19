//
//  NewPictureController.swift
//  VocabularyImprover
//
//  Created by Emanuele Fumagalli on 17/03/18.
//  Copyright © 2018 emafuma. All rights reserved.
//

import UIKit
import AWSS3
import AWSCognito

class NewPictureController: UIViewController,
UINavigationControllerDelegate {
    
    var imagePickerController : UIImagePickerController!
    
    var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    lazy var transferUtility = AWSS3TransferUtility.default()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onTakePicture(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onSendPicture(_ sender: Any) {
        guard let selectedImage = imageView.image else {
            print("No picture to send yet")
            
            self.uploadImage(with: UIImagePNGRepresentation(createImage(from: imageView))!)
            return
        }
        
        self.uploadImage(with: UIImagePNGRepresentation(selectedImage)!)
    }
    
    func createImage(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 32)!
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ]
        
        let rect = view.bounds
        
        let drawText = "First try!"
        
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        imageView.image = viewImage
        
        return viewImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.backgroundColor = .blue
        
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                print("Progress: \(Float(progress.fractionCompleted))")
            })
        }
        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                }
                else {
                    print("Success uploading picture")
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadImage(with data: Data) {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        
        transferUtility.uploadData(
            data,
            bucket: S3BucketName,
            key: S3UploadKeyName,
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandler).continueWith { (task) -> AnyObject! in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        print("Failed")
                    }
                }
                
                if let _ = task.result {
                    DispatchQueue.main.async {
                        print("Upload Starting!")
                    }
                    // Do something with uploadTask.
                }
                
                return nil;
        }
    }
    
    
}

//MARK: UIImagePickerControllerDelegate
extension NewPictureController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}

