import UIKit
import SwiftyJSON
import Alamofire

typealias NetworkStartHandler = ()->()
typealias NetworkErrorHandler = (NSError)->()
typealias NetworkFinishHandler = (Any?)->()

class NetworkLayer: NSObject {
    var start : NetworkStartHandler?
    var error : NetworkErrorHandler?
    var finish : NetworkFinishHandler?
    
    var api: API!
    var parameters: [String : Any]?
    var headers: [String : String]?
    
    var alamofireManager : Alamofire.SessionManager?
    var request : DataRequest?
    
    // 通信開始
    func setStartHandler(_ start: @escaping NetworkStartHandler) {
        self.start = start
    }
    
    // 通信エラー
    func setErrorHandler(_ error: @escaping NetworkErrorHandler) {
        self.error = error
    }
    
    // 通信終了
    func setFinishHandler(_ finish: @escaping NetworkFinishHandler) {
        self.finish = finish
    }
    
    fileprivate func sessionConfiguration() {
        self.alamofireManager = Alamofire.SessionManager.default
    }
    
    func requestApi(api: API, parameters: [String : AnyObject]?, headers: [String: String]?) {
        self.showApiLog(api)
        self.sessionConfiguration()
        
        self.api = api
        self.headers = headers
        if let param = parameters {
            self.parameters = param
        } else {
            self.parameters = nil
        }
        
        self.start?()
        
        self.request = alamofireManager?.request(
            api.path,
            method: self.getMethod(api),
            parameters: self.parameters,
            encoding: JSONEncoding.default
            ).responseJSON { (response: DataResponse<Any>) -> Void in
                switch(response.result) {
                case .success(let json):
                    print(json)
                    let response = JsonParser.sharedInstance.parseJson(api, json: JSON(json))
                    self.finish?(response)
                case .failure(let error):
                    print(error)
                    self.error?(error as NSError)
                }
        }
    }
    
    func getMethod(_ api : API) -> Alamofire.HTTPMethod {
        let requestMethod : Alamofire.HTTPMethod
        switch api.method {
        case "POST":
            requestMethod = .post
            break
        case "PUT":
            requestMethod = .put
            break
        case "DELETE":
            requestMethod = .delete
        case "PATCH":
            requestMethod = .patch
        default:
            requestMethod = .get
            break
        }
        return requestMethod
    }
    
    func showApiLog(_ api: API) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        print("***************************************")
        print("Request_url: \(api.path)")
        print("Date: \(dateString))")
        print("***************************************")
    }
}
