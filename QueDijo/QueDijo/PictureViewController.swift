//
//  PictureViewController.swift
//  QueDijo
//
//  Created by Andrea Amezcua Moreno on 12/5/19.
//  Copyright © 2019 Andrea Amezcua Moreno. All rights reserved.
//

import UIKit

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
     @IBOutlet weak var myImage2: UIImageView!
     
     
 // var myImage:UIImage?
     private lazy var vision = Vision.vision()
     private lazy var textRecognizer = vision.onDeviceTextRecognizer()
     
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
 //         let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
          print("Text recognizer failed with error: \(error)")
          return
        }

        let transform = self.transformMatrix()

        // Blocks.
         print("About to draw frames")
 //        var count = 0
        for block in text.blocks {
          drawFrame(block.frame, in: .purple, transform: transform)

          // Lines.
          for line in block.lines {
            drawFrame(line.frame, in: .orange, transform: transform)

            // Elements.
            for element in line.elements {
              drawFrame(element.frame, in: .green, transform: transform)

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
 //                    DispatchQueue.main.sync {
                                             label.text = translatedText
                         label.adjustsFontSizeToFitWidth = true
                          self.annotationOverlayView.addSubview(label)
 //                    }
                     // Translation succeeded.
                 }
             }
             
             
             
 //                label.textColor = .black
 //            label.isHighlighted = false
            }
 //            if count == 5 {
 //                return
 //            }
 //            count += 1
          }
        }
      }
     
     
     
     @IBAction func selectImage(_ sender: Any) {
 //        let vc = UIImagePickerController()
 //        vc.delegate = self
 //        vc.allowsEditing = true
 //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
 //            print("Camera is available 📸")
 //            vc.sourceType = .camera
 //            self.present(vc, animated: true, completion: nil)
 //        } else {
 //            let vc = UIImagePickerController()
 //            vc.delegate = self
 //            vc.allowsEditing = true
 //            vc.sourceType = .photoLibrary
 //            self.present(vc, animated: true, completion: nil)
 //        }
         
     }
     
     
     @IBOutlet weak var UploadImage: UIImageView!
     
     
     
     @IBAction func save(_ sender: Any) {
        // guard let uid = Auth.auth().currentUser?.uid else { return }
         //Implement image download
     }
     
     @IBAction func uploadImage(_ sender: Any) {
         runTextRecognition(with: myImage.image!)
         
     }

 //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
 //        // Get the image captured by the UIImagePickerController
 //        guard let selectedImage = info[.originalImage] as? UIImage else {
 //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
 //        }
 //        // Do something with the images (based on your use case)
 //        UploadImage.image = selectedImage
 //        myImage = selectedImage
 //        // Dismiss UIImagePickerController to go back to your original view controller
 //        dismiss(animated: true, completion: nil)
 //    }
     override func viewDidLoad() {
         super.viewDidLoad()
         myImage2.addSubview(annotationOverlayView)
         NSLayoutConstraint.activate([
           annotationOverlayView.topAnchor.constraint(equalTo: myImage2.topAnchor),
           annotationOverlayView.leadingAnchor.constraint(equalTo: myImage2.leadingAnchor),
           annotationOverlayView.trailingAnchor.constraint(equalTo: myImage2.trailingAnchor),
           annotationOverlayView.bottomAnchor.constraint(equalTo: myImage2.bottomAnchor),
           ])
         // Do any additional setup after loading the view.
     }
     

     /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
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

     private func removeDetectionAnnotations() {
       for annotationView in annotationOverlayView.subviews {
         annotationView.removeFromSuperview()
       }
     }

}
