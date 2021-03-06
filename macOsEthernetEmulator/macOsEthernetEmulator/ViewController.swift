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
    
    @IBOutlet weak var line_1_number: NSComboBox!
    @IBOutlet weak var line_2_number: NSComboBox!
    @IBOutlet weak var line_3_number: NSComboBox!
    @IBOutlet weak var line_4_number: NSComboBox!
    
    @IBOutlet weak var line_1_name: NSComboBox!
    @IBOutlet weak var line_2_name: NSComboBox!
    @IBOutlet weak var line_3_name: NSComboBox!
    @IBOutlet weak var line_4_name: NSComboBox!    
    
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
        cb_unit_type.selectItem(at: 0)
        
        //-- numbers
        line_1_number.removeAllItems()
        line_1_number.addItems(withObjectValues: possible_numbers)
        line_1_number.selectItem(at: 0)
        
        line_2_number.removeAllItems()
        line_2_number.addItems(withObjectValues: possible_numbers)
        line_2_number.selectItem(at: 1)
        
        line_3_number.removeAllItems()
        line_3_number.addItems(withObjectValues: possible_numbers)
        line_3_number.selectItem(at: 2)
        
        line_4_number.removeAllItems()
        line_4_number.addItems(withObjectValues: possible_numbers)
        line_4_number.selectItem(at: 3)
        
        //-- names
        line_1_name.removeAllItems()
        line_1_name.addItems(withObjectValues: possible_names)
        line_1_name.selectItem(at: 0)
        
        line_2_name.removeAllItems()
        line_2_name.addItems(withObjectValues: possible_names)
        line_2_name.selectItem(at: 1)
        
        line_3_name.removeAllItems()
        line_3_name.addItems(withObjectValues: possible_names)
        line_3_name.selectItem(at: 2)
        
        line_4_name.removeAllItems()
        line_4_name.addItems(withObjectValues: possible_names)
        line_4_name.selectItem(at: 3)
        
        ckb_detailed.isEnabled = false
        rb_inbound.isEnabled = false
        rb_outbound.isEnabled = false
        
        line_1_number.stringValue = ""
        line_1_name.stringValue = ""
        line_2_number.stringValue = ""
        line_2_name.stringValue = ""
        line_3_number.stringValue = ""
        line_3_name.stringValue = ""
        line_4_number.stringValue = ""
        line_4_name.stringValue = ""
        
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
            
            rb_inbound.state = NSOnState
            rb_outbound.state = NSOffState
            
            ckb_detailed.state = NSOffState
            
            line_1_name.isEnabled = true
            line_2_name.isEnabled = true
            line_3_name.isEnabled = true
            line_4_name.isEnabled = true
            
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
    
    func showSending() {
        
        let unit_type = cb_unit_type.indexOfSelectedItem
        if unit_type == 1 { // 1 = deluxe
            ShowStartPopup();
        }
        
    }
    
    func showComplete(){
        
        ShowEndPopup();
        
    }
    
    func showFormatError(text:String) {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "Unsupported Format"
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.informational
        myPopup.runModal()
    }
    
    //-----------------------------------
    // Clicks
    //-----------------------------------
    
    // Check name and number
    func CheckFormatting(line:Int) -> Bool{
        
        if(line == 1){
            
            let num = line_1_number.stringValue.replacingOccurrences(of: "-", with: "")
            let name = line_1_name.stringValue
            
            if num.count > 14 || num.count < 1{
                
                showFormatError(text: "Line \(line) - Number cannot be empty or longer than 14 digits.")
                return false
                
            }
            
            if num.isNumeric == false {
                
                showFormatError(text: "Line \(line) - Number not valid. Only digits allowed.")
                return false
                
            }
            
            if name.count > 15 {
                
                showFormatError(text: "Line \(line) - Name cannot be longer than 15 characters.")
                return false
                
            }
            
            return true
            
        }
        else if(line==2){
            
            let num = line_2_number.stringValue.replacingOccurrences(of: "-", with: "")
            let name = line_2_name.stringValue
            
            if num.count > 14 || num.count < 1{
                
                showFormatError(text: "Line \(line) - Number cannot be empty or longer than 14 digits.")
                return false
                
            }
            
            if num.isNumeric == false {
                
                showFormatError(text: "Line \(line) - Number not valid. Only digits allowed.")
                return false
                
            }
            
            if name.count > 15 {
                
                showFormatError(text: "Line \(line) - Name cannot be longer than 15 characters.")
                return false
                
            }
            
            return true
            
        }
        else if(line == 3){
            
            let num = line_3_number.stringValue.replacingOccurrences(of: "-", with: "")
            let name = line_3_name.stringValue
            
            if num.count > 14 || num.count < 1{
                
                showFormatError(text: "Line \(line) - Number cannot be empty or longer than 14 digits.")
                return false
                
            }
            
            if num.isNumeric == false {
                
                showFormatError(text: "Line \(line) - Number not valid. Only digits allowed.")
                return false
                
            }
            
            if name.count > 15 {
                
                showFormatError(text: "Line \(line) - Name cannot be longer than 15 characters.")
                return false
                
            }
            
            return true
            
        }
        else if(line == 4){
            
            let num = line_4_number.stringValue.replacingOccurrences(of: "-", with: "")
            let name = line_4_name.stringValue
            
            if num.count > 14 || num.count < 1{
                
                showFormatError(text: "Line \(line) - Number cannot be empty or longer than 14 digits.")
                return false
                
            }
            
            if num.isNumeric == false {
                
                showFormatError(text: "Line \(line) - Number not valid. Only digits allowed.")
                return false
                
            }
            
            if name.count > 15 {
                
                showFormatError(text: "Line \(line) - Name cannot be longer than 15 characters.")
                return false
                
            }
            
            return true
            
        }
        
        return false
        
    }
    
    //-----------
    @IBAction func btn_line_1_send_click(_ sender: NSClickGestureRecognizer) {
        
        if CheckFormatting(line: 1) {
        
            lb_line_1_status.stringValue = "sending"
            showSending()
            sendCallRecord(line: 1)
            showComplete()
            
        }
        
    }
    
    @IBAction func btn_send_line_2_click(_ sender: NSClickGestureRecognizer) {
        
        if CheckFormatting(line: 2){
            
            lb_line_2_status.stringValue = "sending"
            showSending()
            sendCallRecord(line: 2)
            showComplete()
            
        }
        
    }
    
    @IBAction func btn_send_line_3_click(_ sender: NSClickGestureRecognizer) {
        
        if CheckFormatting(line: 3){
            
            lb_line_3_status.stringValue = "sending"
            showSending()
            sendCallRecord(line: 3)
            showComplete()
            
        }
        
    }
    
    
    @IBAction func btn_send_line_4_click(_ sender: NSClickGestureRecognizer) {
        
        if CheckFormatting(line: 4){
            
            lb_line_4_status.stringValue = "sending"
            showSending()
            sendCallRecord(line: 4)
            showComplete()
            
        }
        
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
        let ip = getIFAddresses()
        
        // Set to computer IP
        tb_ip.stringValue = ip
        
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
        
        if(matches.count < 1){
            
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
        else if(hour == 12){
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
        
        if(!deluxe){
            
            // Send only start record
            let basicCallRecord = prepareCallRecord(line: line, iOrO: "I", sOrE: "S", dur: "0000", dateString: dateStr)
            
            // Send call record
            sendPacket(body: basicCallRecord)
            
            // Show completion
            outputDisplay?.stringValue = "Complete"
            
            // Finished
            return
            
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
                sendPacket(body: offHookRecord)
                
            }
            
            // Wait 2 seconds
            sleep(2)
            
            // Send start
            let startRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "S", dur: "0000", dateString: dateStr)
            sendPacket(body: startRecord)

            // Wait 2 seconds
            sleep(2)
            
            // If detailed send on hook
            if(detailed){
                
                let onHookRecord = prepareDetailedRecord(line: line, type: "N", dateStr: detailedDateStr)
                sendPacket(body: onHookRecord)
                
            }
            
            // Wait 2 seconds
            sleep(2)
            
            // Send End record
            let endRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "E", dur: "0002", dateString: dateStr)
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
            sendPacket(body: ringRecord)
            
        }
        
        // Wait 2 seconds
        sleep(2)
        
        // Send start
        let startRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "S", dur: "0000", dateString: dateStr)
        sendPacket(body: startRecord)
        
        // Wait 2 seconds
        sleep(1)
        
        // If detailed send off hooks
        if(detailed){
            
            let offHookRecord = prepareDetailedRecord(line: line, type: "F", dateStr: detailedDateStr)
            sendPacket(body: offHookRecord)
            
        }
        
        // Wait 2 seconds
        sleep(3)
        
        // If detailed send on hook
        if(detailed){
            
            let onHookRecord = prepareDetailedRecord(line: line, type: "N", dateStr: detailedDateStr)
            sendPacket(body: onHookRecord)
            
        }
        
        // Send End record
        let endRecord = prepareCallRecord(line: line, iOrO: inOrOut, sOrE: "E", dur: "0003", dateString: dateStr)
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
        
        let sendString = "^^<U>000001<S>345678$" + lineStr + " " + type + "             " + dateStr
        
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
        
        var num_string = line_1_number.stringValue
        var name_string = line_1_name.stringValue
        
        switch line {
            
        case 1:
            
            lineStr="01"
            num_string = line_1_number.stringValue
            name_string = line_1_name.stringValue
            
            break
        
        case 2:
            
            lineStr="02"
            num_string = line_2_number.stringValue
            name_string = line_2_name.stringValue
            
            break
            
        case 3:
            
            lineStr="03"
            num_string = line_3_number.stringValue
            name_string = line_3_name.stringValue
            
            break
            
        case 4:
            
            lineStr="04"
            num_string = line_4_number.stringValue
            name_string = line_4_name.stringValue
            
            break
            
        default:
            
            lineStr="01"
            num_string = line_1_number.stringValue
            name_string = line_1_name.stringValue
            
            break
        }
        
        // Pad to correct lengths
        let padded_number = num_string.padding(toLength: 14, withPad: " ", startingAt: 0)
        let padded_name = name_string.padding(toLength: 15, withPad: " ", startingAt: 0)
        
        // Create call record
        let sendString = "^^<U>\u{0}\u{0}\u{0}\u{0}\u{0}\u{1}<S>345678$" + lineStr +
                            " " + iOrO + " " + sOrE + " " +
                            dur + " G A1 " + dateString + " " + padded_number + " " + padded_name
        
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
    
    func getIFAddresses() -> String {
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "unknown" }
        guard let firstAddr = ifaddr else { return "unknown" }
        
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
        
        for address in addresses {
            
            let ipPattern = "\\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}\\b"
            let ipRegex = try! NSRegularExpression(pattern: ipPattern, options: [])
            let ipMatches = ipRegex.matches(in: address, options: [], range: NSRange(location: 0, length: address.characters.count))
            
            if(ipMatches.count>0){
                return address
            }
        }
        
        return "unknown"
        
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

extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}

