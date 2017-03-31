CALLERID.COM
iOS Etherenet Emulator
-------------------------------------------------------------------------------

macOS Development
 - This app will uses the 'CocoaAsyncSocket' libraries to make UDP coding easier.
 - App targets iPad Pro 9.7 inch
 
Purpose of this app:
 - Test your own software with real packets on your network that are identical to
 the packets that would/will be sent by CallerID.com devices.
 
-------------------------------------------------------------------------------

App Manual:

To generate a call on your network (your testing software must be on this network):

	
	- Select Unit Type: 'Basic' or 'Deluxe'
	- Select 'Inbound' or 'Outbound' using raido buttons to set record type
	- Check 'Detailed' to include 'Ring', 'Off-hooks', and 'On-hooks'
	- Determine which line to send the packet on:
		- Select 'Name' and 'Number' from drop downs
	- Click 'Send'
	
	** This will send a CallerID.com formatted packet that is identical to a hardware
	packet sent from one of our devices. This is used mostly to test your own POS 
	software **


For UDP client help:
https://github.com/robbiehanson/CocoaAsyncSocket
https://github.com/stansidel/udpclient_swift
