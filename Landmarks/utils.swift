//
//  utils.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 16/02/24.
//

import Foundation
import SwiftUI
import MapKit
import Alamofire

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

struct WheaterTime{
    var time: String
    var tempeture: Int
    var icon: String
    var coordinates: MKCoordinateRegion
}

 let times = [
    WheaterTime(time: "Now", tempeture: 35, icon: "day_cloud", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:-12.121841 ,longitude:-77.033175), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "1:00 am", tempeture: 30, icon: "day_rain", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:-16.405945 ,longitude: -71.536437), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "3:00 am", tempeture: 27, icon: "day_snow", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 4.662650 ,longitude:-74.108508), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "5:00 am", tempeture: 25, icon: "night_moon", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -8.070215 ,longitude:-78.9959303), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "7:00 am", tempeture: 27, icon: "night_rain", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 6.243977 ,longitude:-75.573809), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "9:00 am", tempeture: 25, icon: "night_snow", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.787282 ,longitude:-89.652832), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "11:00 am", tempeture: 27, icon: "night_wind", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.737543, longitude:-119.781792), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "01:00 apm", tempeture: 25, icon: "day_snow", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.387107 ,longitude:2.170466), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
    WheaterTime(time: "03:00 pm", tempeture: 27, icon: "day_storm", coordinates: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507970 ,longitude:-0.207052), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))),
]

var maxTempetureHeight: CGFloat = 100

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                )
    }
}


extension Animation {
    static func ripple() -> Animation {
        Animation.default
    }
}


class LandMarkViewModel: ObservableObject {
    @Published var position = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    @Published var conversation: [ChatResponse] = []
    
    @Published var blockControls =  false
    
    func sendQuestion(question: String, proxy: ScrollViewProxy){
        self.blockControls = true
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.conversation.append(ChatResponse(date: dateFormatter.string(from: currentDate), status:200, message: question, isChatBot: false))
        toTop(proxy:proxy)
        ChatBotDataSource().Post(question: question) {response in
            self.conversation.append(response)
            self.toTop(proxy:proxy)
            self.blockControls = false
        }
    }
    
    func toTop(proxy: ScrollViewProxy){
        if self.conversation.count >= 7 {
            proxy.scrollTo(self.conversation[self.conversation.count-5].date)
        }
    }
}

struct ChatBotQuestion: Encodable {
    let content: String
    let role: String
}

struct ChatBotRequest: Encodable {
    let question: String
    var history: String?
}
 

struct ChatResponse: Decodable {
    let date: String
    let status: Int?
    let message: String
    var isChatBot: Bool? = true
    
}

let decoder = JSONDecoder()

class ChatBotDataSource {
    func Post(question: String,  completion: @escaping (ChatResponse) -> Void){
        // Define the URL for the request
        let url = "https://docscanai.doublecode.site/api/v1/chat/send"

        // Define your token
        let token = "18nojhml3eE0PbvXkmYJUUKLWkCRLxP5FDofedVSx6blOjLkpadg5bHtnqfyppYGkFO3HjNhAafmcGlxcRxCMhz4cFOOUGUDyx1s"
        
        // Define headers
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Token": token
        ]
        
        let parameters = ChatBotRequest(question: question)
        
        AF.request(url, method: .post, parameters: parameters, encoder:  JSONParameterEncoder.default, headers: headers)
            .response { response in
                // Check if there's an error
                if let error = response.error {
                    print("Error: \(error)")
                    return
                }
                
                // Ensure there's data
                guard let data = response.data else {
                    print("No data received")
                    return
                }
                
                // Parse the response data
                do {
                    var chatbotResponse = try decoder.decode(ChatResponse.self, from: data)
                    chatbotResponse.isChatBot =  true
                    completion(chatbotResponse)
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


