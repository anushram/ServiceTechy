//
//  NetworkManager.swift
//  Technician
//
//  Created by K Saravana Kumar on 26/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class NetworkManager {
    internal typealias CompletionHandler = (_ response: Alamofire.DataResponse<Any>) -> Void
    internal typealias CompletionHandlerString = (_ response: Alamofire.DataResponse<String>) -> Void
    internal typealias CompletionHandlerObject = (_ response: [String: Any]?,_ error: String?) -> Void
    static let sharedInstance = NetworkManager()
    
    
    
    func constructUrl(endPoint: String) -> URLComponents {
        let endPointString = kBaseUrl + endPoint
        print("\(endPointString)")
        //        let url = NSURL(string: endPointString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        // let url = NSURL(string: endPointString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        let urlStr  = endPointString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let searchURL = URL(string: urlStr as String)!
        // let url = NSURL(string: endPointString.addingPercentEncoding(withAllowedCharacters: ))
        //let url = NSURL(string: endPointString)
        
        //let url = NSURL(string: endPointString.addingPercentEscapes(using: String.Encoding.utf8)!)
        
        //print("urlB=",url)
        //return NSURLComponents(URL: url! as NSURL, resolvingAgainstBaseURL: true)!
        return URLComponents(url: searchURL as URL, resolvingAgainstBaseURL: true)!
    }
    
    func postLogin(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func postAcceptTicket(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func getOpenTicket(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    // MARK:- Notification List
    
    func getNotificationList(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    //MARK: Select Option Status
    
    func getSelectOptions(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    //MARK: Check Out
    
    func postCheckOut(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    // MARK:- getAcceptNotificationList
    
    func getAcceptNotificationList(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    //http://192.168.1.229:3030/api/searchMaterial
    func getSearchMaterial(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func getTicketDetails(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func getScheduledJobs(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func getJobListOfDate(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func postScheduleJob(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func postJobEditDetails(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    //MARK:- image Upload
    func multipleUpload(url: String, thumbImageArray: [UIImage],header: [String:String],completionNotes: String, jobid: String,completionHandler: @escaping CompletionHandlerObject){
        let locationURL = self.constructUrl(endPoint: url)
        //let filename = "\(String(describing: userID!))_\(arc4random()%1000).png"
        //var multiformHeader: HTTPHeaders?
        
        //  let headers2: HTTPHeaders = ["token": CurrentUserManager.shared.jwtAuthToken,"Content-type": "multipart/form-data"]
        //print("url=\(locationURL)/file/upload")
        //print(multiformHeader!)
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            //let filename = "\(String(arc4random()) % 100)\(".png")"
            

            
            var imageData = [Any]()
            
            let filename = "images"
            for i in 0..<thumbImageArray.count {

                //  if self.isThumbImageComplete[i] as! Bool == true{
                //                let filename = "\(String(arc4random()))\(".png"))"
                

//                let imageData1 = thumbImageArray[i].jpegData(compressionQuality: 0.85)!
                let imageData1 = thumbImageArray[i].pngData()
                
                //var imageData = thumbImageArray[i].pngData()
                
//                let dat:MultipartFormData?
//                dat?.app
                //imageData.append(imageData1!)
                //MultipartFormData

                multipartFormData.append(imageData1!, withName: "images", fileName:"images"+String(format:"%d",i)+".png", mimeType:"image/png")
                //                print("offerImageName == ",filename+String(format:"%d",i))
                //print("offerImageName ",self.filenameArray[i])
                // }
            }
            
            multipartFormData.append(completionNotes.data(using: .utf8)!, withName: "notes")
            multipartFormData.append(jobid.data(using: .utf8)!, withName: "jobid")
            //multipartFormData.append(jobStatus.data(using: .utf8)!, withName: "jobstatusid")
            //jobstatusid
//            do {
//                let data = try JSONSerialization.data(withJSONObject: imageData, options: [])
//
//                multipartFormData.append(data, withName: filename, fileName:"image11", mimeType:"image/png")
//
//            }catch let error as NSError {
//                print(error)
//            }
//
            
            
           // multipartFormData.append((thumbImageArray.first?.jpegData(compressionQuality: 0.5))!, withName: "images", fileName:"Images", mimeType:"image/png")
            
        },usingThreshold: 0, to: (locationURL), method: .post, headers: header) { (result) in
            switch result{
                
            case .success(let upload,_,_):
                
                upload.response{(response) in
                    let returnData = String(data: response.data!, encoding: .utf8)
                    print("Response=",returnData!)
                    
                    if response.response?.statusCode == 200 {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any]
                            print(json)
                            let res = json["response"] as! [String:Any]
                            let data = res["data"] as! [String:Any]
                            completionHandler(json, nil)
                            //let fileuploadValue = Mapper<FileUploadResponse>().map(JSON: data)
                            //Completion?(fileuploadValue, nil)
                            
                        } catch let error as NSError {
                            print(error)
                        }
                        
                    }else{
                        completionHandler(nil,"fail")
                    }
                    
                }
                //                upload.responseObject { (response: DataResponse<FileUploadResponse>) in
                //
                //                    let returnData = String(data: response.data!, encoding: .utf8)
                //                    print("uploadfile=", returnData!)
                //                    //                    print("error=", response.error!)
                //                    print("status code",response.response?.statusCode as Any)
                //
                //                    if response.response?.statusCode == 200 {
                //                        Completion?(response.value,nil)
                //
                //                    }else{
                //                        Completion?(nil,response.error)
                //
                //                    }
                //
            //                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //onError?(error)
            }
        }
        
    }
    
    func postQuotations(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
        
    }
    
    func getQuotationsList(url: String, parameter: [String: Any],header: [String:String] ,completionHandler: @escaping CompletionHandler) {
        let locationURL = self.constructUrl(endPoint: url)
        Alamofire.request(locationURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            completionHandler(response)
            
        }
    }
}
