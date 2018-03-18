//
//  NewPictureController.swift
//  VocabularyImprover
//
//  Created by Emanuele Fumagalli on 17/03/18.
//  Copyright © 2018 emafuma. All rights reserved.
//

import UIKit

class NewPictureController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePickerController : UIImagePickerController!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onTakePicture(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onSendPicture(_ sender: Any) {
        guard imageView.image != nil else {
            print("No picture to send yet")
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imageView.backgroundColor = .blue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UIImagePickerControllerDelegate
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

