//
//  ContentView.swift
//  Smart Irrigation System
//
//  Created by Ibrahim on 27/10/2023.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        ZStack{
            TabView {
                Home1View()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                }
            }
           //.accentColor(.orange)
        }
    }
}
#Preview {
    ContentView()
}


/*
 
 label: {
     Image(systemName: "power")
         .frame(width: 300, height: 15)
         .font(.title)
         .foregroundColor(.white)
         .padding()
         .background(Color.blue)
         .cornerRadius(24)
         .shadow(radius: 10)
 }//End Button
 
 */
