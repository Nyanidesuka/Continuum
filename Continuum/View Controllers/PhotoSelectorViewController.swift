//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Haley Jones on 6/5/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var delegate: PhotoSelectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImageButtonTapped(_ sender: Any) {
        let selectPhotoAlert = UIAlertController(title: "Select an image", message: nil, preferredStyle: .actionSheet)
        let pickerController = UIImagePickerController()
        pickerController.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let fromCameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            }
            selectPhotoAlert.addAction(fromCameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let fromLibraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
            selectPhotoAlert.addAction(fromLibraryAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: {
                //nothin
            })
        }
        selectPhotoAlert.addAction(cancelAction)
        
        self.present(selectPhotoAlert, animated: true, completion: nil)
    }
    

}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            //stuff
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            //empty completion
        }
        guard let image = info[.editedImage] as? UIImage else {return}
        postImageView.image = image
        selectImageButton.setTitle("", for: .normal)
        self.delegate?.photoSelectorViewControllerSelected(image: image)
    }
}

protocol PhotoSelectorViewControllerDelegate{
    func photoSelectorViewControllerSelected(image: UIImage)
}
