//
//  TicketDetailsVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 05/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
//import SwiftOCR
import TesseractOCR
import GPUImage
import Vision
import Photos
import ObjectMapper

class TicketDetailsVC: BaseVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate,G8TesseractDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    
    

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageOCR: UIImageView!
    @IBOutlet weak var textOCR: UITextView!
    @IBOutlet weak var completionNotes: UITextView!
    @IBOutlet weak var scroll: UIScrollView!
    
    var identifyLibrary = 0
    
    @IBOutlet weak var imageCollection: UICollectionView!
    var pickedImage = [UIImage]()
    //Native OCR
    //var request = VNRecognizeTextRequest()
    
    var jobDetailObjects: OpenTicketsList!
    var OptionPhotoView: LibraryOptionPopUp!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        completionNotes.text = "Give Completion Notes"
        completionNotes.textColor = UIColor.lightGray
        completionNotes.font = UIFont(name: "NotoSans", size: 13.0)
        self.addDoneButtonOnKeyboard(textView: completionNotes)
        self.addNavigationBarTitleView(title: "TitleView", image: UIImage())
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    
        if textView.text == "Give Completion Notes" {
            
            completionNotes.text = ""
            completionNotes.textColor = UIColor.black
            completionNotes.font = UIFont(name: "NotoSans", size: 13.0)
            
            UIView.animate(withDuration: 0.1) {
                let scrollPoint = CGPoint(x: 0, y: textView.superview!.frame.origin.y)
                self.scroll .setContentOffset(scrollPoint, animated: true)
            }
            
        }else{
            
            UIView.animate(withDuration: 0.1) {
                let scrollPoint = CGPoint(x: 0, y: textView.superview!.frame.origin.y)
                self.scroll .setContentOffset(scrollPoint, animated: true)
            }
            
        }
        
        
        
    }
    
    override func doneButtonAction() {
        if completionNotes.text == "" {
            
            completionNotes.text = "Give Completion Notes"
            completionNotes.textColor = UIColor.lightGray
            completionNotes.font = UIFont(name: "NotoSans", size: 13.0)
        }
        completionNotes.resignFirstResponder()
        UIView.animate(withDuration: 0.1) {
            let scrollPoint = CGPoint(x: 0, y: 0)
            self.scroll .setContentOffset(scrollPoint, animated: true)
        }
        
    }

    @IBAction func takePicAction(sender: UIButton) {
        self.identifyLibrary = 0
        self.OptionPhotoView = self.libraryOptionPopUp(view: self.view)
         self.OptionPhotoView.cameraLibrarybtn.addTarget(self, action: #selector(self.cameraAction(sender:)), for: .touchUpInside)
        self.OptionPhotoView.photoLibrarybtn.addTarget(self, action: #selector(self.photoAction(sender:)), for: .touchUpInside)
        self.OptionPhotoView.cancelbtn.addTarget(self, action: #selector(self.libraryCloseAction(sender:)), for: .touchUpInside)
    }
    
    @IBAction func takePicScannerAction(sender: UIButton) {
        self.identifyLibrary = 1
        self.OptionPhotoView = self.libraryOptionPopUp(view: self.view)
         self.OptionPhotoView.cameraLibrarybtn.addTarget(self, action: #selector(self.cameraAction(sender:)), for: .touchUpInside)
        self.OptionPhotoView.photoLibrarybtn.addTarget(self, action: #selector(self.photoAction(sender:)), for: .touchUpInside)
        self.OptionPhotoView.cancelbtn.addTarget(self, action: #selector(self.libraryCloseAction(sender:)), for: .touchUpInside)
    }
    
    @IBAction func cameraAction(sender: UIButton){
        self.closeSuccessView(sender: OptionPhotoView)
        imagePicker.allowsEditing = true
   // self.pickerReference.cameraViewTransform = CGAffineTransformScale(CGAffineTransformIdentity, zoom, zoom);
        //imagePicker.cameraViewTransform.scaledBy(x: 8.0, y: 8.0)
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func photoAction(sender: UIButton){
        self.closeSuccessView(sender: OptionPhotoView)
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func libraryCloseAction(sender: UIButton){
        self.closeSuccessView(sender: OptionPhotoView)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if self.identifyLibrary == 1 {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                
                if #available(iOS 13.0, *) {
                    var request = VNRecognizeTextRequest()
                    request = VNRecognizeTextRequest { request, error in
                        guard let observations = request.results as? [VNRecognizedTextObservation] else {
                            fatalError("Received invalid observations")
                        }
                        
                        for observation in observations {
                            
                            for value in observation.topCandidates(1) {
                                print("Found this candidate1: \(value.string)")
                            }
                            
                            guard let bestCandidate = observation.topCandidates(1).first else {
                                print("No candidate")
                                continue
                            }
                            DispatchQueue.main.async(execute: {
                                self.textOCR.text = self.textOCR.text! + " " + bestCandidate.string
                            })
                            print("Found this candidate: \(bestCandidate.string)")
                        }
                    }
                    
                } else {
                    
                    //self.picImage(image: pickedImage)
                    let tesseract:G8Tesseract = G8Tesseract(language: "eng")!
                    tesseract.delegate = self
                    let scaledImage = pickedImage.scaledImage(1000) ?? pickedImage
                    let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
                    tesseract.charBlacklist = "`'[]|?%$@!^"
//                    let swiftOCRInstance = SwiftOCR()
//                    swiftOCRInstance.recognize(pickedImage) { recognizedString in
//                        print("vvvvv=",recognizedString)
//                    }
                    //tesseract.engineMode = .tesseractCubeCombined
                    textOCR.text = ""
                    imageOCR.image = pickedImage
                    tesseract.image = pickedImage
                    tesseract.recognize()
                    let recogText = tesseract.recognizedText!
                    let val = recogText.components(separatedBy: "\n")
                    
                    for modelSerial in val {
                        if modelSerial.contains("Model") {
                            
                            if modelSerial.contains(":"){
                                
                                textOCR.text = textOCR.text + "\n" + modelSerial
                                
                            }else{
                                
                                textOCR.text = textOCR.text + "\n" + modelSerial.replacingOccurrences(of: "Model", with: "Model: ")
                                
                            }
                            
                        }else if modelSerial.contains("S/N") || modelSerial.contains("SIN")  {
                            
                            if modelSerial.contains(":"){
                                
                                textOCR.text = textOCR.text + "\n" + modelSerial
                                
                            }else{
                                
                                if modelSerial.contains("S/N"){
                                    
                                    textOCR.text = textOCR.text + "\n" + modelSerial.replacingOccurrences(of: "S/N", with: "S/N: ")
                                    
                                }else if modelSerial.contains("SIN"){
                                    
                                    textOCR.text = textOCR.text + "\n" + modelSerial.replacingOccurrences(of: "SIN", with: "S/N: ")
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                    }
                    
                    print("The 1 text is \(tesseract.recognizedText!)")
                    
                }
                
                //Native OCR Scanner
                //            request = VNRecognizeTextRequest { request, error in
                //                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                //                    fatalError("Received invalid observations")
                //                }
                //
                //                for observation in observations {
                //
                //                    for value in observation.topCandidates(1) {
                //                        print("Found this candidate1: \(value.string)")
                //                    }
                //
                //                    guard let bestCandidate = observation.topCandidates(1).first else {
                //                        print("No candidate")
                //                        continue
                //                    }
                //                    DispatchQueue.main.async(execute: {
                //                        self.textOCR.text = self.textOCR.text! + " " + bestCandidate.string
                //                    })
                //                    print("Found this candidate: \(bestCandidate.string)")
                //                }
                //            }
                
                //Customized third party
                //self.picImage(image: pickedImage)
                //let tesseract:G8Tesseract = G8Tesseract(language: "eng")!
                //tesseract.delegate = self
                //let scaledImage = pickedImage.scaledImage(1000) ?? pickedImage
                //let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
                //tesseract.charBlacklist = "0123456789"
                //let swiftOCRInstance = SwiftOCR()
                //swiftOCRInstance.recognize(pickedImage) { recognizedString in
                //    print("vvvvv=",recognizedString)
                //}
                //imageOCR.image = pickedImage
                //tesseract.image = pickedImage
                //tesseract.recognize()
                //textOCR.text = tesseract.recognizedText!
                //print("The 1 text is \(tesseract.recognizedText!)")
                
            }else {
                
                let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                //let data = UIImagePNGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!)! as NSData
                //let dataaa = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.2)
                
                if #available(iOS 13.0, *) {
                    
                    var request = VNRecognizeTextRequest()
                    request = VNRecognizeTextRequest { request, error in
                        guard let observations = request.results as? [VNRecognizedTextObservation] else {
                            fatalError("Received invalid observations")
                        }
                        
                        for observation in observations {
                            
                            for value in observation.topCandidates(1) {
                                print("Found this candidate1: \(value.string)")
                            }
                            
                            guard let bestCandidate = observation.topCandidates(1).first else {
                                print("No candidate")
                                continue
                            }
                            DispatchQueue.main.async(execute: {
                                self.textOCR.text = self.textOCR.text! + " " + bestCandidate.string
                            })
                            print("Found this candidate: \(bestCandidate.string)")
                        }
                    }
                    
                } else {
                    
                    //self.picImage(image: pickedImage)
                    let tesseract:G8Tesseract = G8Tesseract(language: "eng")!
                    tesseract.delegate = self
                    let scaledImage = pickedImage.scaledImage(1000) ?? pickedImage
                    let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
                    //tesseract.charBlacklist = "0123456789"
                    //                    let swiftOCRInstance = SwiftOCR()
                    //                    swiftOCRInstance.recognize(pickedImage) { recognizedString in
                    //                        print("vvvvv=",recognizedString)
                    //                    }
                    imageOCR.image = pickedImage
                    tesseract.image = pickedImage
                    tesseract.recognize()
                    textOCR.text = tesseract.recognizedText!
                    print("The 1 text is \(tesseract.recognizedText!)")
                    
                }
                
                
            }
            self.imagePicker.dismiss(animated: true, completion: nil)
            
            
        }else {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.pickedImage.append(pickedImage)
            self.imageCollection.reloadData()
            
            //Native OCR Scanner
//            request = VNRecognizeTextRequest { request, error in
//                guard let observations = request.results as? [VNRecognizedTextObservation] else {
//                    fatalError("Received invalid observations")
//                }
//
//                for observation in observations {
//
//                    for value in observation.topCandidates(1) {
//                        print("Found this candidate1: \(value.string)")
//                    }
//
//                    guard let bestCandidate = observation.topCandidates(1).first else {
//                        print("No candidate")
//                        continue
//                    }
//                    DispatchQueue.main.async(execute: {
//                        self.textOCR.text = self.textOCR.text! + " " + bestCandidate.string
//                    })
//                    print("Found this candidate: \(bestCandidate.string)")
//                }
//            }
            
            //Customized third party
            //self.picImage(image: pickedImage)
            //let tesseract:G8Tesseract = G8Tesseract(language: "eng")!
            //tesseract.delegate = self
            //let scaledImage = pickedImage.scaledImage(1000) ?? pickedImage
            //let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
            //tesseract.charBlacklist = "0123456789"
            //let swiftOCRInstance = SwiftOCR()
            //swiftOCRInstance.recognize(pickedImage) { recognizedString in
            //    print("vvvvv=",recognizedString)
            //}
            //imageOCR.image = pickedImage
            //tesseract.image = pickedImage
            //tesseract.recognize()
            //textOCR.text = tesseract.recognizedText!
            //print("The 1 text is \(tesseract.recognizedText!)")
            
        }else {
            
            let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            //let data = UIImagePNGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!)! as NSData
            //let dataaa = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.2)
            self.pickedImage.append(pickedImage)
            self.imageCollection.reloadData()
            
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    }
    
    //Native OCR
    
//    func picImage(image: UIImage) {
//        let requests = [request]
//        request.recognitionLevel = .accurate
//        request.recognitionLanguages = ["en_GB"]
//        request.customWords = ["Login"]
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let img = image.cgImage else {
//                fatalError("Missing image to scan")
//            }
//
//            let handler = VNImageRequestHandler(cgImage: img, options: [:])
//            try? handler.perform(requests)
//        }
//    }
    
//    func detectImageRecognition(image: UIImage) {
//
//        var im = UIImage()
//
//        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [VNImageOption : Any]())
//        let request = VNDetectTextRectanglesRequest.init { (request, error) in
//
//            if error != nil {
//
//            }else {
//               im = self.drawRectangleForTextDetect(image: image, results: request.results as! Array<VNTextObservation>)
//                DispatchQueue.main.async {
//                    self.imageOCR.image = im
//                }
//            }
//        }
//        request.reportCharacterBoxes = true
//
//        do {
//            try handler.perform([request])
//        } catch  {
//            print("Unable to detect text")
//        }
//
//    }
    
//    func drawRectangleForTextDetect(image: UIImage, results: Array<VNTextObservation>) -> UIImage {
//        let renderer = UIGraphicsImageRenderer.init(size: image.size)
//
//        var transform = CGAffineTransform.identity
//
//        transform = transform.scaledBy(x: image.size.width, y: -image.size.height)
//
//        let img = renderer.image { (ctx) in
//            for item in results {
//                ctx.cgContext.setFillColor(UIColor.clear.cgColor)
//                ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
//                ctx.cgContext.setLineWidth(2)
//                ctx.cgContext.addRect(item.boundingBox.applying(transform))
//                ctx.cgContext.drawPath(using: .fillStroke)
//                self.addScreenshotToTextImages(image: image, boundingBox: item.boundingBox.applying(transform))
//            }
//        }
//        return img
//    }
//
//    func addScreenshotToTextImages(image: UIImage, boundingBox: CGRect) {
//        let pct = 0.1 as CGFloat
//        let newRect = boundingBox.insetBy(dx: -boundingBox.width*pct/2, dy: -boundingBox.height*pct/2)
//        let imageRef = image.cgImage?.cropping(to: newRect)
//        let croppedImage = UIImage.init(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
//
//    }
    
    // MARK: UICollection View Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pickedImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : AddPhotoCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickedimage", for: indexPath) as! AddPhotoCVCell
        cell.pickedImage.image = self.pickedImage[indexPath.row]
      return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 109, height: 109)
    }
    
    @IBAction func checkOutAction(sender: UIButton){
        //"Content-Type":"application/json",
        if self.pickedImage.count != 0 {
        let header = ["token": Singleton.sharedInstance.getTechToken()]
        self.showActivityIndicator()
        NetworkManager.sharedInstance.multipleUpload(url: "/tech/uploadjobimages", thumbImageArray: self.pickedImage, header: header, completionNotes: completionNotes.text!,jobid: String(jobDetailObjects.id)) { (response, error) in
            
            //self.hideActivityIndicator()
            
//            DispatchQueue.main.async {
//                //fromCOtoSO
//                self.performSegue(withIdentifier: "fromCOtoSO", sender: self)
//                //self.performSegue(withIdentifier: "fromCTtoQuotation", sender: self)
//            }
            self.getTicketDetails()
            
        }
            
        }else{
            self.showAlertMessage(title: "Alert", message: "Please pick atleast one image") {
                
            }
        }
        
    }
    
    // MARK: - Job Details
    
        func getTicketDetails() {
            
            let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
            //http://192.168.1.179:3030/api/getTechassignedjobs
            
            let param = ["request":["jobid":jobDetailObjects.id]]
            //http://192.168.1.179:3030/api/getTechassignedjobdetail
            NetworkManager.sharedInstance.getTicketDetails(url: "/getTechassignedjobdetail", parameter: param, header: header) { (response) in
                self.hideActivityIndicator()
                switch response.result {
                case .success(_):
                    print("values=",response.result.value!)
                    if let responseValue = response.result.value as? NSDictionary {
                        
                        if let responseCode = responseValue["response"] as? NSDictionary {
                            
                            if let code = responseCode["code"] as? String {
                                
                                if code == "OK" {
                                    
                                    if let responseData = responseCode["data"] as? NSDictionary {
                                        
                                        if let responseResult = responseData["result"] as? NSDictionary {
                                            
                                            if let jobResult = responseResult["jobResult"] as? NSArray {
                                                
                                                if let ticketDetails = jobResult[0] as? [String: AnyObject] {
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                    
                                                        if let ticketDetailObject = Mapper<JobDetails>().map(JSON: ticketDetails) {
                                                            
                                                            self.jobDetailObjects.jobstatusid = ticketDetailObject.jobstatusid
                                                            self.performSegue(withIdentifier: "fromCOtoSO", sender: self)
                                                            
                                                        }
                                                            
                                                        })
                                                    
                                                    
                                                }
                                                
                                            }
                                        
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }else {
                        self.showAlertMessage(title: "Alert", message: "Please enter the correct Username and Password") {
                            
                        }
                    }
                    
                case .failure(_): break
                    
                }
                
            }

            
        }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromCTtoQuotation" {
            let view = segue.destination as! QuotationVC
            view.jobDetailObjects = jobDetailObjects
        }else if segue.identifier == "fromCOtoSO" {
            let view = segue.destination as! SelectCheckOutVC
            view.jobDetailObjects = jobDetailObjects
        }
        
    }

    /*
    // MARK: - Navigation
    // fromCTtoQuotation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
