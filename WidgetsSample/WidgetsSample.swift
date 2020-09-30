//
//  WidgetsSample.swift
//  WidgetsSample
//
//  Created by Mohammed on 9/30/20.
//

import WidgetKit
import SwiftUI

// model for Widgets
struct WidgetsModel: TimelineEntry {
    var date: Date
    var currentTime: String
}

struct DataProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> WidgetsModel {
        let entry = WidgetsModel(date: Date(), currentTime: "placeholder")
       return entry
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetsModel>) -> ()) {
        // time line updates of data
        let date = Date()
        
        let formater  = DateFormatter()
        formater.dateFormat = "hh:mm:ss a"
        
        let time = formater.string(from: date)
        
        // creating modelData
        let  entryData = WidgetsModel(date: date, currentTime: time)
        
        let refersh = Calendar.current.date(byAdding: .second, value: 5, to: date)!
        
        // never will dont update view until os updates view....
        let timeLine = Timeline(entries: [entryData], policy: .after(refersh))
        
        print("Updated")
        completion(timeLine)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetsModel) -> ()) {
        // data loading for Widget
        
        //simplay updating time...
        
        let date = Date()
        
        let formater  = DateFormatter()
        formater.dateFormat = "hh:mm:ss a"
        
        let time = formater.string(from: date)
        
        // creating modelData
        let  entryData = WidgetsModel(date: date, currentTime: time)
        
        completion(entryData)
    }
    
   
}

//WidgetView

struct WidgetView : View {
    
    var data: DataProvider.Entry
    
    var body: some View{
        VStack{
            
            HStack{
                
                Spacer()
                
                Text("Time")
                
                Spacer()
            }
            .padding(.all)
            .background(Color.yellow)
            
            Spacer()
            
            Text(data.currentTime)
                .padding(.horizontal, 15)
                .foregroundColor(.red)
            
            Spacer()
        }
        .background(Color.white)
    }
    
}

// Setting View
@main
struct Config: Widget {
    
    var body: some WidgetConfiguration {
        // the Widget you created will be kind name
        StaticConfiguration(kind: "Widget", provider: DataProvider()) { data in
            WidgetView(data: data)
        }
        //size of widget
        .supportedFamilies([.systemLarge])
        .description(Text("Current Time"))
    }
}
