//
//  extenstion.swift
//  DemoWeather
//
//  Created by Harshil Kotecha on 26/08/20.
//  Copyright © 2020 Harshil Kotecha. All rights reserved.
//


import Alamofire

class WebServiceManager{
    
    class func api(_ url: String, method: HTTPMethod, parameters: [String:Any]?, headers: HTTPHeaders?, image: UIImage?, arrImages: [UIImage]? = nil, completionHandler: @escaping ([String:Any],Data?) -> Void, failureHandler: @escaping ([String:Any]) -> Void){
        
        
       
        
        let newURL = APIURL.baseURL + url
        if !Connectivity.isConnectedToInternet(){
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                
                
            }
//            return
        }
        
        //without image
        if image == nil && arrImages == nil{
            AF.request(newURL, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
                
                
                
                switch response.result{
                case .success(let data):
                    
                    if let result = data as? [String: Any]{
                        if let isSuccess = result["success"] as? Bool, isSuccess == true{
                            completionHandler(result,response.data)
                        }else{
//                            if let logoutCode = result["code"] as? Int, logoutCode == 101 || logoutCode == 100{
//
//                            }else{
//
////                                if !self.isErrorAvailable(result){
////                                    failureHandler(result)
////                                }else if result["code"] as? Int == 501{
//                                    failureHandler(result)
////                                }else{
////                                    failureHandler([:])
////                                }
//
//                            }
                            completionHandler(result,response.data)
                        }
                    }
                    
                case .failure(let error): break
                    
//                    print(error.localizedDescription)
                 //   failureHandler(["errorMsg": "Something Went Wrong".localized])
                }
            }
        }
        
        //with image
        else if image != nil || arrImages != nil{
            
            AF.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in parameters!{
                    
                    
                    if let str = value as? String, !str.isEmpty{
                        multipartFormData.append(str.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                }
                
                if arrImages == nil{
                    let newImage = image?.jpegData(compressionQuality: 0.5)
                    let timeStamp = NSDate().timeIntervalSince1970
                    multipartFormData.append(newImage!, withName: "image", fileName: "\(timeStamp).jpeg", mimeType: "jpeg/png")
                }else{
                    for img in arrImages!{
                        let newImage = img.jpegData(compressionQuality: 0.5)
                        let timeStamp = NSDate().timeIntervalSince1970
                        multipartFormData.append(newImage!, withName: "image", fileName: "\(timeStamp).jpeg", mimeType: "jpeg/png")
                    }
                }
                
                
            }, to: newURL, usingThreshold: UInt64.init(), method: method, headers: headers).responseJSON { (response) in
                
                switch response.result{
                case .success(let data):
                    if let result = data as? [String: Any]{
                        if let isSuccess = result["success"] as? Bool, isSuccess == true{
                            completionHandler(result,response.data)
                        }else{
                            if let logoutCode = result["code"] as? Int, logoutCode == 101 || logoutCode == 100{
                                
                            }else{
                                failureHandler(result)
                            }
                        }
                    }
                case .failure(_): break
                   // failureHandler(["errorMsg": "Something Went Wrong".localized])
                }
            }
    
        }
        
    }
    
  
     
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
