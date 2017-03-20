//
//  ViewController.swift
//  macOsEthernetEmulator
//
//  Created by mac on 3/20/17.
//  Copyright © 2017 CallerId.com. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket

class ViewController: NSViewController, GCDAsyncUdpSocketDelegate {

    // ----------------------------------
    // Connect UI elements
    //-----------------------------------
    
    @IBOutlet weak var cb_unit_type: NSPopUpButton!
    
    @IBOutlet weak var tb_ip: NSTextField!
    
    @IBOutlet weak var ckb_detailed: NSButton!
    
    @IBOutlet weak var line_1_number: NSPopUpButton!
    @IBOutlet weak var line_2_number: NSPopUpButton!
    @IBOutlet weak var line_3_number: NSPopUpButton!
    @IBOutlet weak var line_4_number: NSPopUpButton!
    
    @IBOutlet weak var line_1_name: NSPopUpButton!
    @IBOutlet weak var line_2_name: NSPopUpButton!
    @IBOutlet weak var line_3_name: NSPopUpButton!
    @IBOutlet weak var line_4_name: NSPopUpButton!
    
    // Radio button group
    @IBAction func rb_inOrOut(_ sender: NSButton) {
        
        switch rb_outbound.state {
        case NSOnState:
            
            line_1_name.isEnabled = false
            line_2_name.isEnabled = false
            line_3_name.isEnabled = false
            line_4_name.isEnabled = false
            
            break
        
        case NSOffState:
            
            line_1_name.isEnabled = true
            line_2_name.isEnabled = true
            line_3_name.isEnabled = true
            line_4_name.isEnabled = true
            
            break
            
        default:
            
            line_1_name.isEnabled = true
            line_2_name.isEnabled = true
            line_3_name.isEnabled = true
            line_4_name.isEnabled = true
            
            break
            
        }
        
    }
    
    @IBOutlet weak var rb_inbound: NSButton!
    @IBOutlet weak var rb_outbound: NSButton!
    
    @IBOutlet weak var btn_line_1_send: NSButton!
    @IBOutlet weak var btn_line_2_send: NSButton!
    @IBOutlet weak var btn_line_3_send: NSButton!
    @IBOutlet weak var btn_line_4_send: NSButton!
    
    @IBOutlet weak var lb_line_1_status: NSTextField!
    @IBOutlet weak var lb_line_2_status: NSTextField!
    @IBOutlet weak var lb_line_3_status: NSTextField!
    @IBOutlet weak var lb_line_4_status: NSTextField!
    
    @IBOutlet weak var lb_ip_status: NSTextField!
    
    //-----------------------------------
    
    //-----------------------------------
    // combo boxes data
    //-----------------------------------
    
    let unitTypes = ["Basic","Deluxe"]
    let possible_numbers = ["800-240-4637","770-263-7111","770-263-7278","OUT-OF-AREA","PRIVATE","No-CallerID"]
    let possible_names = ["CallerID.com","Atlanta, GA","Smith, John","OUT-OF-AREA","PRIVATE"]
    
    
    //-----------------------------------
    // Populate and load
    //-----------------------------------
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Populate UI elements
        
        // - unit types
        cb_unit_type.removeAllItems()
        cb_unit_type.addItems(withTitles: unitTypes)
        cb_unit_type.selectItem(at: 1)
        
        //-- numbers
        line_1_number.removeAllItems()
        line_1_number.addItems(withTitles: possible_numbers)
        line_1_number.selectItem(at: 0)
        
        line_2_number.removeAllItems()
        line_2_number.addItems(withTitles: possible_numbers)
        line_2_number.selectItem(at: 1)
        
        line_3_number.removeAllItems()
        line_3_number.addItems(withTitles: possible_numbers)
        line_3_number.selectItem(at: 2)
        
        line_4_number.removeAllItems()
        line_4_number.addItems(withTitles: possible_numbers)
        line_4_number.selectItem(at: 3)
        
        //-- names
        line_1_name.removeAllItems()
        line_1_name.addItems(withTitles: possible_names)
        line_1_name.selectItem(at: 0)
        
        line_2_name.removeAllItems()
        line_2_name.addItems(withTitles: possible_names)
        line_2_name.selectItem(at: 1)
        
        line_3_name.removeAllItems()
        line_3_name.addItems(withTitles: possible_names)
        line_3_name.selectItem(at: 2)
        
        line_4_name.removeAllItems()
        line_4_name.addItems(withTitles: possible_names)
        line_4_name.selectItem(at: 3)
        
    }

    //-----------------------------------
    
    //-----------------------------------
    // Text changes
    //-----------------------------------
    @IBAction func cb_unit_type_changed(_ sender: NSPopUpButton) {
        
        // Check if basic or deluxe
        var deluxe = false
        if(unitTypes[cb_unit_type.indexOfSelectedItem]=="Deluxe"){
            deluxe = true
        }
        
        if(!deluxe){
            rb_inbound.isEnabled = false
            rb_outbound.isEnabled = false
            ckb_detailed.isEnabled = false
        }
        else{
            rb_inbound.isEnabled = true
            rb_outbound.isEnabled = true
            ckb_detailed.isEnabled = true
        }
        
    }
    //-----------------------------------
    
    //-----------------------------------
    // Clicks
    //-----------------------------------
    @IBAction func btn_line_1_send_click(_ sender: NSClickGestureRecognizer) {
        
        sendCallRecord(line: 1)
        
    }
    
    @IBAction func btn_send_line_2_click(_ sender: NSClickGestureRecognizer) {
        
        sendCallRecord(line: 2)
        
    }
    
    @IBAction func btn_send_line_3_click(_ sender: NSClickGestureRecognizer) {
        
        sendCallRecord(line: 3)
        
    }
    
    
    @IBAction func btn_send_line_4_click(_ sender: NSClickGestureRecognizer) {
        
        sendCallRecord(line: 4)
        
    }
    
    @IBAction func btn_set_to_broadcast(_ sender: NSClickGestureRecognizer) {
    
        // Set to braodcast IP address
        tb_ip.stringValue = "255.255.255.255"
        
        // valid IP address
        lb_ip_status.stringValue = "valid ip"
        lb_ip_status.textColor = #colorLiteral(red: 0, green: 0.6326534748, blue: 0, alpha: 0.85)
    
    }
    
    @IBAction func btn_set_to_local_ip_click(_ sender: NSClickGestureRecognizer) {
        
        // Get computer IP
        var ips = getIFAddresses()
        
        // Set to computer IP
        tb_ip.stringValue = ips[0]
        
        // valid IP address
        lb_ip_status.stringValue = "valid ip"
        lb_ip_status.textColor = #colorLiteral(red: 0, green: 0.6326534748, blue: 0, alpha: 0.85)
        
    }
    
    func sendCallRecord(line:Int){
        
        // -------------------
        // Check for IP format
        // -------------------
        var strIP: String? = tb_ip.stringValue
        let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        let regex = try! NSRegularExpression(pattern: validIpAddressRegex, options: [])
        let matches = regex.matches(in: strIP!, options: [], range: NSRange(location: 0, length: (strIP?.characters.count)!))
        
        if(matches.count<1){
            
            // not a valid IP address
            lb_ip_status.stringValue = "invalid ip"
            lb_ip_status.textColor = #colorLiteral(red: 0.8108969331, green: 0.1193998978, blue: 0.2366783023, alpha: 0.85)
            
        }else{
            
            // valid IP address
            lb_ip_status.stringValue = "valid ip"
            lb_ip_status.textColor = #colorLiteral(red: 0, green: 0.6326534748, blue: 0, alpha: 0.85)
            
        }
        
        // -----------------------
        
        // -----------------------
        // Get date string
        // -----------------------
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let seconds = calendar.component(.second, from: date)
        
        var amPM = "AM"
        var hr = hour
        
        if(hour > 12){
            hr = hour - 12
            amPM = "PM"
        }
        
        // -----------------------
        // Pad if needed
        // -----------------------
        var monthString = String(month)
        if(String(month).characters.count==1){
            monthString = "0\(monthString)"
        }
        
        var dayString = String(day)
        if(String(day).characters.count==1){
            dayString = "0\(dayString)"
        }
        
        var minString = String(minutes)
        if(String(minutes).characters.count==1){
            minString = "0\(minString)"
        }
        
        var hrString = String(hr)
        if(String(hr).characters.count==1){
            hrString = "0\(hrString)"
        }
        
        var hourString = String(hour)
        if(String(hour).characters.count==1){
            hourString = "0\(hourString)"
        }
        
        var secondsString = String(seconds)
        if(String(seconds).characters.count==1){
            secondsString = "0\(secondsString)"
        }
        
        // Make detailed date string
        let detailedDateStr = "\(monthString)/\(dayString) \(hourString):\(minString):\(secondsString)"
        
        // -----------------------
        
        // Make date string
        let dateStr = "\(monthString)/\(dayString) \(hrString):\(minString) \(amPM)"
        
        // Check if basic or deluxe
        var deluxe = false
        if(unitTypes[cb_unit_type.indexOfSelectedItem]=="Deluxe"){
            deluxe = true
        }
        
        if(!deluxe){
            
            // Send only start record
            let basicCallRecord = prepareCallRecord(line: line, iOrO: "I", sOrE: "S", dur: "0000", dateString: dateStr)
            
            // Send call record
            sendPacket(body: basicCallRecord)
            
            // Finished
            return
            
        }
        
        // Prepare outputting of status
        var outputDisplay = lb_line_1_status
        switch line {
            
        case 1:
            
            outputDisplay = lb_line_1_status
            break
            
        case 2:
            
            outputDisplay = lb_line_2_status
            break
            
        case 3:
            
            outputDisplay = lb_line_3_status
            break
            
        case 4:
            
            outputDisplay = lb_line_4_status
            break
            
        default:
            
            outputDisplay = lb_line_1_status
            break
            
        }
        
        // Check if sending detailed records
        var detailed = false
        switch ckb_detailed.state {
        case NSOnState:
            detailed=true
            break
        case NSOffState:
            detailed=false
            break
        default:
            detailed=true
            break
        }
        
        // Check inbound or outbound
        var inOrOut = "I"
        switch rb_inbound.state {
        case NSOnState:
            inOrOut = "I"
            break
        case NSOffState:
            inOrOut = "O"
            break
        default:
            inOrOut = "I"
            break
        }
        
        //------------------------------------
        // If OUTBOUND
        //------------------------------------
        if(inOrOut == "O"){
            
            // If detailed send off hooks
            if(detailed){
                
                let offHookRecord = prepareDetailedRecord(line: line, type: "F", dateStr: detailedDateStr)
                outputDisplay?.stringValue = "OFF-HOOK"
                sendPacket(body: offHookRecord)
                
            }
            
            // Wait 2 seconds
            sleep(2)
            
            // Send start
            let startRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "S", dur: "0000", dateString: dateStr)
            outputDisplay?.stringValue = "START RECORD"
            sendPacket(body: startRecord)

            // Wait 2 seconds
            sleep(2)
            
            // If detailed send on hook
            if(detailed){
                
                let onHookRecord = prepareDetailedRecord(line: line, type: "N", dateStr: detailedDateStr)
                outputDisplay?.stringValue = "ON-HOOK"
                sendPacket(body: onHookRecord)
                
            }
            
            // Wait 2 seconds
            sleep(2)
            
            // Send End record
            let endRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "E", dur: "0120", dateString: dateStr)
            outputDisplay?.stringValue = "END RECORD"
            sendPacket(body: endRecord)
            
            // Wait 2 seconds
            outputDisplay?.stringValue = "Completed"
            
            // End this progress
            return
            
        }
        //------------------------------------
        
        //------------------------------------
        // If INBOUND
        //------------------------------------
        
        // If detailed then send Ring first
        if(detailed){
            
            let ringRecord = prepareDetailedRecord(line: line, type: "R", dateStr: detailedDateStr)
            outputDisplay?.stringValue = "RINGING"
            sendPacket(body: ringRecord)
            
        }
        
        // Wait 2 seconds
        sleep(2)
        
        // Send start
        let startRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "S", dur: "0000", dateString: dateStr)
        outputDisplay?.stringValue = "START RECORD"
        sendPacket(body: startRecord)
        
        // Wait 2 seconds
        sleep(2)
        
        // If detailed send off hooks
        if(detailed){
            
            let offHookRecord = prepareDetailedRecord(line: line, type: "F", dateStr: detailedDateStr)
            outputDisplay?.stringValue = "OFF-HOOK"
            sendPacket(body: offHookRecord)
            
        }
        
        // Wait 2 seconds
        sleep(2)
        
        // If detailed send on hook
        if(detailed){
            
            let onHookRecord = prepareDetailedRecord(line: line, type: "N", dateStr: detailedDateStr)
            outputDisplay?.stringValue = "ON-HOOK"
            sendPacket(body: onHookRecord)
            
        }
        
        // Wait 2 seconds
        sleep(2)
        
        // Send End record
        let endRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "E", dur: "0120", dateString: dateStr)
        outputDisplay?.stringValue = "END RECORD"
        sendPacket(body: endRecord)
        
        // Wait 2 seconds 
        sleep(2)
        
        // Show completion
        outputDisplay?.stringValue = "Complete"
        
    }
    
    //-----------------------------------
    
    //-----------------------------------
    // Prep udp string
    //-----------------------------------
    
    func prepareDetailedRecord(line:Int, type:String, dateStr:String) -> String {
        
        // FORMAT:
        //
        //   ^^<U>000001<S>345678$01 R 03/13 23:25:21
        //
        //
        var lineStr = "01"
        switch line {
            
        case 1:
            
            lineStr="01"
            
            break
            
        case 2:
            
            lineStr="02"
            
            break
            
        case 3:
            
            lineStr="03"
            
            break
            
        case 4:
            
            lineStr="04"
            
            break
            
        default:
            
            lineStr="01"
            
            break
        }
        
        let sendString = "^^<U>000001<S>345678$" + lineStr + " " + type + " " + dateStr
        
        return sendString
        
    }
    
    func prepareCallRecord(line:Int, iOrO:String, sOrE:String, dur:String, dateString:String) -> String{
        
        // FORMAT:
        //    
        //   ^^<U>000001<S>345678$01 I S 0000 G A1 03/13 11:25 AM 800-240-4637   CallerID.com
        //
        //
        
        // Get line number
        var lineStr = "01"
        
        var paddedNumberString = possible_numbers[line_1_number.indexOfSelectedItem]
        var paddedNameString = possible_names[line_1_name.indexOfSelectedItem]
        
        switch line {
            
        case 1:
            
            lineStr="01"
            paddedNumberString = possible_numbers[line_1_number.indexOfSelectedItem]
            paddedNameString = possible_names[line_1_name.indexOfSelectedItem]
            
            break
        
        case 2:
            
            lineStr="02"
            paddedNumberString = possible_numbers[line_2_number.indexOfSelectedItem]
            paddedNameString = possible_names[line_2_name.indexOfSelectedItem]
            
            break
            
        case 3:
            
            lineStr="03"
            paddedNumberString = possible_numbers[line_3_number.indexOfSelectedItem]
            paddedNameString = possible_names[line_3_name.indexOfSelectedItem]
            
            break
            
        case 4:
            
            lineStr="04"
            paddedNumberString = possible_numbers[line_4_number.indexOfSelectedItem]
            paddedNameString = possible_names[line_4_name.indexOfSelectedItem]
            
            break
            
        default:
            
            lineStr="01"
            paddedNumberString = possible_numbers[line_1_number.indexOfSelectedItem]
            paddedNameString = possible_names[line_1_name.indexOfSelectedItem]
            
            break
        }
        
        // Pad to correct lengths
        paddedNumberString = paddedNumberString.padding(toLength: 14, withPad: " ", startingAt: 0)
        paddedNameString = paddedNameString.padding(toLength: 15, withPad: " ", startingAt: 0)
        
        // If outbound then clear name field
        if(iOrO == "O"){
            paddedNameString = ""
        }
        
        // Create call record
        let sendString = "^^<U>000001<S>345678$" + lineStr +
                            " " + iOrO + " " + sOrE + " " +
                            dur + " G A1 " + dateString + " " + paddedNumberString + " " + paddedNameString
        
        // Return created call record
        return sendString
        
    }
    
    //-----------------------------------
    
    //-----------------------------------
    // Low Level UDP code
    //-----------------------------------
    
    var _socket: GCDAsyncUdpSocket?
    var socket: GCDAsyncUdpSocket? {
        get {
            if _socket == nil {
                guard let port = UInt16("3520"), port > 0 else {
                    return nil
                }
                let sock = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
                do {
                    try sock.enableBroadcast(true)
                    //try sock.beginReceiving()
                } catch _ as NSError {
                    sock.close()
                    return nil
                }
                _socket = sock
            }
            return _socket
        }
        set {
            _socket?.close()
            _socket = newValue
        }
    }
    
    deinit {
        socket = nil
    }
    
    func sendPacket(body: String){
        
        let host = tb_ip.stringValue
        let port = UInt16("3520")
        
        guard socket != nil else {
            return
        }
        
        socket?.send(body.data(using: String.Encoding.utf8)!, toHost: host, port: port!, withTimeout: 2, tag: 0)
        
    }
    
    //-----------------------------------
    // Lower level functions
    //-----------------------------------
    
    func getIFAddresses() -> [String] {
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    //-----------------------------------
    // Un-used
    //-----------------------------------
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

