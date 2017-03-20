CALLERID.COM
iOS Etherenet Emulator
---------------------
spenland@callerid.com
-------------------------------------------------------------------------------

iOS Development
 - This app will uses the 'CocoaAsyncSocket' libraries to make UDP coding easier.
 - App targets iPad Pro 9.7 inch
 
Purpose of this app:
 - Test your own software with real packets on your network that are identical to
 the packets that would/will be sent by CallerID.com devices.
 
-------------------------------------------------------------------------------

App Manual:

To generate a call on your network (your testing software must be on this network):

	- Select Unit Type: Basic or Deluxe
	- Select whether you wish the call to be an inbound or outbound call using raido
	  buttons
	- Check 'Detailed' if you wish to include 'Ring', 'Off-hooks', and 'On-hooks'
	- Determine which line you wish to send packet on:
		- Select 'Name' and 'Number' from drop downs
	- Click 'Send'
	
	** This will send a CallerID.com formatted packet that is identical to a hardware
	packet sent from one of our devices. This is used mostly to test your own POS 
	software **


For UDP client help:
https://github.com/robbiehanson/CocoaAsyncSocket
https://github.com/stansidel/udpclient_swift
