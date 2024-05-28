//
//  APIFetchHandler.swift
//  Smart Irrigation System
//
//  Created by Ibrahim on 27/10/2023.
//

import Foundation
import Alamofire

class APIFetchHandler {
    static let sharedInstance = APIFetchHandler()
   func fetchAPIData() {
      let url = "http://192.168.0.102:5000/api/soil";
      AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
        .response{ resp in
            switch resp.result{
              case .success(let data):
                do{
                  let jsonData = try JSONDecoder().decode([Model].self, from: data!)
                  print(jsonData)
               } catch {
                  print(error.localizedDescription)
               }
             case .failure(let error):
               print(error.localizedDescription)
             }
        }
   }
}

struct Model:Codable {
   let soil: Int
}
