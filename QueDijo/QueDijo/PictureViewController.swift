//
//  PictureViewController.swift
//  QueDijo
//
//  Created by Andrea Amezcua Moreno on 12/5/19.
//  Copyright © 2019 Andrea Amezcua Moreno. All rights reserved.
//


import UIKit
import Firebase
import FirebaseStorage

class PictureViewController: UIViewController {
    
    let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .es)
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.backgroundColor = .clear
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    @IBOutlet weak var myImage: UIImageView!
    
    private lazy var vision = Vision.vision()
    private lazy var textRecognizer = vision.onDeviceTextRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutAnnotation()
    }
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Text Recognition
extension PictureViewController {
    
    private func layoutAnnotation() {
        myImage.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: myImage.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: myImage.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: myImage.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: myImage.bottomAnchor),
        ])
    }
    
    @IBAction func translateImage(_ sender: Any) {
        runTextRecognition(with: myImage.image!)
    }
    
    func runTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        print("One")
        textRecognizer.process(visionImage) { features, error in
            self.processResult(from: features, error: error)
        }
    }
    
    func processResult(from text: VisionText?, error: Error?) {
        removeDetectionAnnotations()
        guard error == nil, let text = text else {
            print("Text recognizer failed with error: \(String(describing: error))")
            return
        }
        
        let transform = self.transformMatrix()
        
        // Blocks.
        for block in text.blocks {
            drawFrame(block.frame, in: .purple, transform: transform)
            
            // Lines.
            for line in block.lines {
                drawFrame(line.frame, in: .orange, transform: transform)
                
                // Elements.
                for element in line.elements {
                    drawFrame(element.frame, in: .green, transform: transform)
                    translate(text: " ", transform: transform, element: element)
                }
            }
        }
    }
    
    private func translate(text: String, transform: CGAffineTransform, element: VisionTextElement) {
        let transformedRect = element.frame.applying(transform)
        let label = UILabel(frame: transformedRect)
        let englishSpanishTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishSpanishTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            
            // Model downloaded successfully. Okay to start translating.
            englishSpanishTranslator.translate(element.text) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }
                
                label.text = translatedText
                label.adjustsFontSizeToFitWidth = true
                self.annotationOverlayView.addSubview(label)
            }
        }
    }
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func transformMatrix() -> CGAffineTransform {
        guard let image = myImage.image else { return CGAffineTransform() }
        let imageViewWidth = myImage.frame.size.width
        let imageViewHeight = myImage.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale = (imageViewAspectRatio > imageAspectRatio) ?
            imageViewHeight / imageHeight :
            imageViewWidth / imageWidth
        
        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    private func drawFrame(_ frame: CGRect, in color: UIColor, transform: CGAffineTransform) {
        let transformedRect = frame.applying(transform)
        UIUtilities.addRectangle(
            transformedRect,
            to: self.annotationOverlayView,
            color: color
        )
    }
}

// MARK: Image Picker
extension PictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let alertController = UIAlertController(title: "Please choose", message: "Photo library or use camera for image", preferredStyle: .alert)
        let library = UIAlertAction(title: "Library", style: .default) { (action) in
            if action.isEnabled == true {
                vc.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(vc, animated: true, completion: nil)
            }
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            if action.isEnabled == true {
                vc.sourceType = UIImagePickerController.SourceType.camera
                self.present(vc, animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(library)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
}
