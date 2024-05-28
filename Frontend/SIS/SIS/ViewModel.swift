//
//  ViewModel.swift
//  Smart Irrigation System
//
//  Created by Ibrahim on 30/10/2023.
//

import Foundation
import SwiftUI

/*
struct Sensor: Hashable, Codable {
    let id: Int
}

class ViewModel: ObservableObject {
    @Published var sensors: [Sensor] = []
    //@Published var sensors: Sensor
    func fetch() {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak
            self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            //convert to json
            do{
                let sensors = try JSONDecoder().decode([Sensor].self,
                    from: data)
                DispatchQueue.main.async {
                    self?.sensors = sensors
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
//ForEach(viewModel.posts, id: \.self){ post in
 
 //                        ForEach(viewModel.sensors, id: \.self){ soil in
 //                            if soil.id == 1{
 //                                Text(String(soil.id))
 //                            }
 //                        }
*/



