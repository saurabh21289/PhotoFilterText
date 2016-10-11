//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Saurabh Singh on 18/08/16.
//  Copyright © 2016 Saurabh Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var openCVVersionLabel: UILabel!
    //Outlet is a variable linked to the object on the storyboard
    @IBOutlet weak var photoImageView: UIImageView!
    
    //Access camera
    
    @IBAction func openCameraButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Accress gallery
    
    
    @IBAction func openPhotoLibraryButton(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        photoImageView.image = image
        //textToImage("This is hot!", inImage: image, atPoint: CGPointMake(20, 20))
        //was = image

        self.dismiss(animated: true, completion: nil);
        self.view.transform = CGAffineTransform.identity
    }
    
    //Create place in memory to render the filtered image
    let context = CIContext(options: nil)

    
    @IBAction func applyFilter(_ sender: AnyObject) {
    
        //Create an image to filter
        let inputImage = CIImage(image: photoImageView.image!)
        
        //Create random color to pass to a filter
        let randomColor = [kCIInputAngleKey: (Double(arc4random_uniform(314))/100)]
        
        //Apply filter to the image
        let filteredImage = inputImage!.applyingFilter("CIHueAdjust", withInputParameters: randomColor)
    
        //Render the filtered image
        let renderedImage = context.createCGImage(filteredImage, from: filteredImage.extent)
        
        //Reflect the change
        photoImageView.image = UIImage(cgImage: renderedImage!)
    }
    
    //Save button
    
    @IBAction func saveButton(_ sender: AnyObject) {
        //var textOnPhoto = DIImageView.textField
        //print(textOnPhoto)
        
        //Global variable textOnPhoto is used to add text to the image
        let image = textToImage(textOnPhoto as NSString, inImage: photoImageView.image!, atPoint: CGPoint(x: 20, y: 20))
        let imageData = UIImageJPEGRepresentation(image, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Image saved", message: "Your image has been saved to the Photo Library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
        self.present(alert, animated: true){}
    }
    
    //Pinch to zoom, rotate and double tap
    
    @IBAction func pinchZoom(_ sender: UIPinchGestureRecognizer) {
        
        self.view.transform = self.view.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    
    @IBAction func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        self.view.transform = self.view.transform.rotated(by: sender.rotation)
        sender.rotation = 0
        
    }
    
    
    @IBAction func doubleTapZoom(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        self.view.transform = self.view.transform.scaledBy(x: 3.0, y: 3.0)
    }
    
    
    //Add text to image
    
    func textToImage(_ drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 42)!
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        let strokeColor = UIColor.white
        
        let textShadow : NSShadow = NSShadow()
        textShadow.shadowColor = UIColor.darkGray
        textShadow.shadowBlurRadius = 1.2
        textShadow.shadowOffset = CGSize(width: 1,height: 1)
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: titleParagraphStyle,
            NSStrokeColorAttributeName: strokeColor,
            //NSStrokeWidthAttributeName: 1.6,
            NSShadowAttributeName: textShadow
            ]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Create a point within the space that is as big as the image
        let rect = CGRect(x: atPoint.x , y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        openCVVersionLabel.text = OpenCVWrapper.openCVVersionString()
        view.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

