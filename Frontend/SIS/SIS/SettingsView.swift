//
//  SettingsView.swift
//  Smart Irrigation System
//
//  Created by Ibrahim on 28/10/2023.
//

import SwiftUI
import Combine
import NetworkExtension
import Network


class SharedData: ObservableObject {
//    @Published var IP: String = ""
    @AppStorage("storedIP") var storedIP: String = ""
}
struct SettingsView: View{
    @State private var isToggled = false
    @State private var value = 2
    @State private var sliderValue: Double = 2
    @State private var ipAddress = "Fetching IP Address..."
    //@State private var inputIP: String = "192.168.4.1"
    @ObservedObject private var sharedData = SharedData()
    @State private var ssid: String = ""
    @State private var password: String = ""
    var body: some View {
        NavigationView {
            List{
                VStack(spacing: 20) {
                    TextField("SSID", text: $ssid)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        // Perform action with ssid and password
                        print("SSID: \(ssid), Password: \(password)")
                        postRequest(key:"ssid",value: ssid, key2: "pwd", value2: password)
                    }) {
                        Text("Connect to Wi-Fi")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(5)
                //end con wifi
                HStack{
                    HStack{
                        Image(systemName: "network")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(.orange)
                            .cornerRadius(10)
                            .font(.system(size: 24, weight: .bold))
                        Text("Set IP Address")
                    }
                    HStack{
                        TextField("192.168.44.1", text: $sharedData.storedIP)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 135)
                            .padding(5)
                    }
                }//End stack IP
                HStack{
                    HStack{
                        Image(systemName: "autostartstop")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(.green)
                            .cornerRadius(10)
                            .font(.system(size: 24, weight: .bold))
                        Text("Auto")
                    }
                    HStack{
                        Toggle("", isOn: $isToggled)
//                        Text(" \(isToggled ? "On" : "Off")")
//                        if isToggled{
//                            postRequest(key:"auto",value: true)
//                        }
//                        
                    }
                }//End stack auto
                HStack{
                    HStack{
                        Image(systemName: "timer")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(.red)
                            .cornerRadius(10)
                            .font(.system(size: 24, weight: .bold))
                    }
                    HStack{
                        Stepper(value: $value, in: 1...100) {
                            Text("Timer: \(value)")
                        }.font(.title3)
                        Button{
                            postRequest(key:"timer",value: value)
                        }label: {
                            Text("Set")
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                            //.font(.headline)
                        }
                    }
                }//End stack timer
                HStack{
                    VStack{
                        HStack{
                            HStack{
                                Image(systemName: "humidity.fill")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(.blue)
                                    .cornerRadius(10)
                                    .font(.system(size: 24, weight: .bold))
                                Text("Humidity: \(sliderValue, specifier: "%.f")")
                                    .font(.title3)
                            }
                            Spacer()
                            HStack{
                                Button{
                                    postRequest(key:"humidity",value: Int(sliderValue))
                                }label: {
                                    Text("Set")
                                        .padding(10)
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                    //.font(.headline)
                                }//end button
                            }
                        }//end hstack
                        Slider(value: $sliderValue, in: 1...100)
                    }//end vstack
                    //
                }//End hstack timer
            }//End List
            .navigationTitle("Settings")
        }
    }
    
    
    func postRequest(key:String, value:Any, key2:String = "", value2:Any = "") {
        let endpoint = "http://\(sharedData.storedIP):5000/api/pin"
        guard let url = URL(string: endpoint) else {
            return
        }
        print("API Request...")
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "POST"
        //request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            key:value,
            key2:value2
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        //make Request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                print("SUCCESS: \(response)")
            }catch{
                print(error)
            }
        }
        task.resume()
    }//end function post
    
}
    
    #Preview {
        SettingsView()
    }
