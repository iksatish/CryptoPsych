//
//  ViewController.swift
//  CryptoPsych
//
//  Created by Satish Kumar R Kancherla on 2/11/18.
//  Copyright © 2018 IK. All rights reserved.
//

import UIKit
import SocketIO
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var test: UITextView!
    var priceArr: [Double] = []
    var months: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.sharedInstant.establishConnection()
        chart.drawGridBackgroundEnabled = false
//        chartView.delegate = self
        
        chart.setViewPortOffsets(left: 0, top: 20, right: 0, bottom: 0)
        chart.backgroundColor = UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1)
        
        chart.dragEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = false
        chart.maxHighlightDistance = 300
        
        chart.xAxis.enabled = false
        
        let yAxis = chart.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .insideChart
        yAxis.axisLineColor = .white
        
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        
//        self.slidersValueChanged(nil)
        
        chart.animate(xAxisDuration: 2, yAxisDuration: 2)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(upd), name: NSNotification.Name(rawValue: "Test"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upd1), name: NSNotification.Name(rawValue: "Test1"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func upd(center: NSNotification ){
//        self.test.text = "\(self.test.text!)\n\(center.userInfo!["price"] as? String ?? "")"
        if let data = center.userInfo, let priceStr = data["price"] as? String, let price = Double(priceStr){
            self.priceArr.append(price)
            self.reloadChart()
        }
    }
    @objc func upd1(center: NSNotification ){
        SocketIOManager.sharedInstant.establishConnection()
    }
    
    func reloadChart(){
        chart.noDataText = "You need to provide data for the chart."
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<self.priceArr.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: priceArr[i])
            dataEntries.append(dataEntry)
        }
        
        let line1 = LineChartDataSet(values: dataEntries, label: "USD")
        line1.mode = .cubicBezier
        line1.drawCirclesEnabled = false
        line1.lineWidth = 1.8
        line1.circleRadius = 4
        line1.setCircleColor(.white)
        line1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        line1.fillColor = .white
        line1.fillAlpha = 1
        line1.drawHorizontalHighlightIndicatorEnabled = false
//        line1.fillFormatter = CubicLineSampleFillFormatter()
        
        line1.colors = [NSUIColor.blue]
        let chartData = LineChartData()
        chartData.addDataSet(line1)
        chart.data = chartData
    }
}


class SocketIOManager :NSObject{
    var data:NSString?
    static let sharedInstant = SocketIOManager()
    var socket = SocketIOClient(socketURL: NSURL(string: "https://streamer.cryptocompare.com")! as URL, config: [.log(true), .forcePolling(true)])
    
    override init() {
        super.init()
        print("init called")
        let dict = [ "subs" : ["5~CCCAGG~ETH~USD"]]
        
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected \(data) \(ack)")
            self.socket.emit("SubAdd", dict)
        }
        
        
        socket.on("m", callback: {data,ack in
            print("M printed")
            print("Mssssss \(data)")
            let myString: String = String(describing: data[0])
            if myString == "3~LOADCOMPLETE"{
                self.socket.emit("SubRemove", dict)
                self.init()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Test1"), object: nil, userInfo: nil)
            }else {
                var myStringArr = myString.components(separatedBy: "~")
            if myStringArr.count > 5 && Double(myStringArr[5])! < 100000{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Test"), object: nil, userInfo: ["price": myStringArr[5]])
                print(myStringArr[5])

            }
            }
            
//            }
            
            
        })
    }
    func establishConnection() {
        socket.connect()
        
    }
    func closeConnection() {
        socket.disconnect()
    }
}

