//
//  ViewController.swift
//  HomeIOTProject
//
//  Created by Jonathan Deehan on 19/07/2016.
//  Copyright © 2016 jdblogs. All rights reserved.
//

import UIKit
import Firebase
import Charts


/* 
 The HomeIOTProject gets the temperature values from the firebase database
 and presents it in a bar chart format for the day's temperature record.
 
*/

class ViewController: UIViewController {
    
    @IBOutlet weak var currentRoomTemp: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Total temperature record of the day
        var temperatureValues: [Double] = []
        // Time recorded for each temperature
        var timeValues:[String] = []
        // Date formatted correctly for firebase json post
        var currentDate = self.getCurrentDate()
        // firebase URLs for each reference
        let firebaseURL = "yourURL"
        let secondFirebaseURL = "yourURL"
        // Firebase references
        var ref = Firebase(url:firebaseURL)
        var liveRef = Firebase(url: secondFirebaseURL)
        
        // Firebase calls for temperature update each half hour
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            // Temperature Elements
            let temperature = snapshot.value["value"] as? String
            temperatureValues.append(Double(temperature!)!)
            // Time Elements
            let time = snapshot.value["time"] as? String
            timeValues.append(time!)
            self.generateTemperatureGraph(temperatureValues, time: timeValues)
        });
        
        // Firebase calls for live temperature value
        liveRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            // Temperature Elements
            let temperature = snapshot.value["value"] as? String
            // Time Elements
            self.currentRoomTemp.text = "\(temperature!)"
        });
    }
    
    // Generates the bar chart graph using the Charts framework
    func generateTemperatureGraph(temperature: [Double], time: [String]){
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<time.count {
            let dataEntry = BarChartDataEntry(value: temperature[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "temperature")
        let chartData = BarChartData(xVals: time, dataSet: chartDataSet)
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.descriptionText = ""
        barChartView.data = chartData
    }
    
    func getCurrentDate() -> String {
        var currentDate = NSDate()
        var date = NSDateFormatter()
        date.dateFormat = "yyyy/MM/dd"
        return date.stringFromDate(currentDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}