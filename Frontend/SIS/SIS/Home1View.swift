//
//  Home1View.swift
//  Smart Irrigation System
//
//  Created by Ibrahim on 29/10/2023.
//

import SwiftUI

struct Humidity: Codable {
    let humidity: Int
    let IP: String
}
enum HMError: Error{
    case invalidURL
    case invalidResponse
    case invalidData
}
struct Response: Codable{
    let humidity: Int
    let IP: String
}

struct Home1View: View {
    @State private var soil: Humidity?
    @ObservedObject private var sharedData = SharedData()
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    HStack(spacing:65){
                        //-----------Humidity Logo-------------//
                        Image(systemName: "drop.degreesign.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 90, weight: .bold))
                        VStack{
                            //-----//Humidity %------//
                            //let cons = viewModel.sensors
                            Text(String(soil?.humidity ?? 0)+"%")
                            //.foregroundColor(.black)
                                .font(.system(size: 60, weight: .bold))
                            Text("Humidity")
                                .foregroundColor(.orange)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }//end hstack
                    .shadow(radius: 10)
                    Gauge(value: Float(soil?.humidity ?? 0), in: 0...100) {
                        //Text("Humidity")
                    }.frame(width: 300)
                        .accentColor(.blue)
         
                        HStack{
                            Button{
                                Task{
                                    soil = try await getHum()
                                }
                                //viewModel.fetch()
                            }label: {
                                Image(systemName: "leaf.arrow.triangle.circlepath")
                                    .frame(width: 18, height: 18)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(.blue)
                                    .cornerRadius(18)
                                    .task {
                                        do{
                                            soil = try await getHum()
                                        }catch HMError.invalidURL{
                                            print("Invaled URL")
                                        }catch HMError.invalidResponse{
                                            print("Invaled Response")
                                        }catch HMError.invalidData{
                                            print("Invaled DATA")
                                        }catch {
                                            print("unxpected Error")
                                        }
                                        sleep(1)
                                    }
                            }.padding(.horizontal)
                            Text(String(soil?.humidity ?? 0))
                                .font(.system(size: 18, weight: .bold))
                            //Text(humidity?.id ?? "data")
                            Spacer()
                            Text(String(soil?.IP ?? "0.0.0.0"))
                                .font(.system(size: 18, weight: .bold))
                                .padding()
                        }.shadow(radius: 10)
                        //end HStack
                        HStack{
                            Spacer()
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.green)
                                .padding(.horizontal)
                        }
                }//End 2st Vstack and Card
                .frame(width: 350, height: 300)
                .background()
                .cornerRadius(24)
                .shadow(radius: 10)
                //----------------------------------------------------------------------------------------//
                //----Button----//
                Button{
                    direct()
                    //postRequest()
                    //print("d")
                }label: {
                    Image(systemName: "switch.programmable")
                        .frame(width: 120, height: 120)
                        .font(.system(size: 65, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                        .cornerRadius(200)
                        .shadow(radius: 10)
                    
                }//End Button
                .padding(85)
                //----------------------------------------------------------------------------------------//
                
            }//end vstak 1
            .navigationTitle("Smart Irrigation")
        }//end zstack
    }//End body View
    
    //----------------------------------------------------------------------------------------//
    func getHum() async throws -> Humidity{
        //let endpoint = "https://api.github.com/users/brhamsalih"
        let endpoint = "http://\(sharedData.storedIP):5000/api/soil"
        
        guard let url = URL(string: endpoint) else {
            throw HMError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw HMError.invalidResponse
        }
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Humidity.self, from: data)
            
        }catch {
            throw HMError.invalidData
        }
    }//end function get
    
    
    func direct(){
        let endpoint = "http://\(sharedData.storedIP):5000/api/run"
        guard let url = URL(string: endpoint) else {
            return
        }
        print("API Request Direct...")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard  error == nil else {
                //print(data)
                return
            }
        }
        task.resume()
    }//end function direct
    
    //----------------------------------------------------------------------------------------//
} //End Home1View View
    
    #Preview {
        Home1View()
    }

