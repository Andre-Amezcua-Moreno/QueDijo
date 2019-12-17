//
//  RealTimeViewController.swift
//  QueDijo
//
//  Created by Andrea Amezcua Moreno on 12/5/19.
//  Copyright © 2019 Andrea Amezcua Moreno. All rights reserved.
//

/*
import UIKit
import AVFoundation
import CoreVideo

import Firebase
import MaterialComponents

let LanguageNames = ["Afrikaans", "Arabic", "Belarusian", "Bulgarian", "Bengali", "Catalan",
"Czech", "Welsh", "Danish", "German", "Greek", "English", "Esperanto",
"Spanish", "Estonian", "Persian", "Finnish", "French", "Irish", "Galician",
"Gujarati", "Hebrew", "Hindi", "Croatian", "Haitian", "Hungarian",
"Indonesian", "Icelandic", "Italian", "Japanese", "Georgian", "Kannada",
"Korean", "Lithuanian", "Latvian", "Macedonian", "Marathi", "Malay", "Maltese",
"Dutch", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Slovak",
"Slovenian", "Albanian", "Swedish", "Swahili", "Tamil", "Telugu", "Thai",
"Tagalog", "Turkish", "Ukranian", "Urdu", "Vietnamese", "Chinese"]

private let kBoxCornerRadius: CGFloat = 12.0
private let kBoxBorderWidth: CGFloat = 2.0
private let kBoxBackgroundAlpha: CGFloat = 0.12
private let boxWidth: CGFloat = 340.0
private let boxHeight: CGFloat = 100.0
private let boxWidthHalf = boxWidth / 2
private let boxHeightHalf = boxHeight / 2
private let hdWidth: CGFloat = 720 // AVCaptureSession.Preset.hd1280x720
private let hdHeight: CGFloat = 1280 // AVCaptureSession.Preset.hd1280x720
private let hdWidthHalf = hdWidth / 2
private let hdHeightHalf = hdHeight / 2
private let defaultMargin: CGFloat = 16
private let chipHeight: CGFloat = 32
private let chipHeightHalf = chipHeight / 2
private let customSelectedColor = UIColor(red:0.10, green:0.45, blue:0.91, alpha:1.0)
private let backgroundColor = UIColor(red:0.91, green:0.94, blue:0.99, alpha:1.0)


@objc(CameraViewController)
class RealTimeViewController: UIViewController {
    
    private func recognizeTextOnDevice(in image: VisionImage) {
    }

    private func identifyLanguage(for text: String) {
    }

    func translate(_ inputText: String) {
    }

    var detectCounts = [String: Int]()
    var detectQueue = [String]()
    var detectedText = ""
    var recentOutputLanguageIndexes = [11, 13] // English, Spanish
    let sizingChip = MDCChipView()
    var selectedItem = 0
    var cropX = 0
    var cropWidth = 0
    var cropY = 0
    var cropHeight = 0
    
    
    @IBOutlet weak var chipCollectionView: UICollectionView!
    
    // keep track of the pending work item as a property
    private var pendingRequestWorkItem: DispatchWorkItem?

    private lazy var shapeGenerator: MDCRectangleShapeGenerator = {
      let gen = MDCRectangleShapeGenerator()
      gen.setCorners(MDCCornerTreatment.corner(withRadius: 4))
      return gen
    }()
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var cameraOverlayView: CameraOverlayView!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private lazy var vision = Vision.vision()
    private lazy var languageId = NaturalLanguage.naturalLanguage().languageIdentification()

    var translator: Translator!
    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var detectedTextLabel: UILabel!
    @IBOutlet weak var detectedLanguageLabel: UILabel!
    @IBOutlet weak var translatedLabel: UILabel!
    let containerScheme = MDCContainerScheme()
    var detectedLanguage = TranslateLanguage.en
    
    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return annotationOverlayView
    }()
    
    
    @IBOutlet weak var previewView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpCameraPreviewLayer()
        sizingChip.mdc_adjustsFontForContentSizeCategory = true
        setUpAnnotationOverlayView()
        chipCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        chipCollectionView.dataSource = self
        chipCollectionView.delegate = self
        chipCollectionView.isScrollEnabled = false

        let ratio = hdWidth / previewView.bounds.width
        cropX = Int(hdHeightHalf - (ratio * boxHeightHalf))
        cropWidth = Int(boxHeight * ratio)
        cropY = Int(hdWidthHalf - (ratio * boxWidthHalf))
        cropHeight = Int(boxWidth * ratio)

        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()

        MDCCornerTreatment.corner(withRadius: 4)
    }
*/

import UIKit

class RealTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func home(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
