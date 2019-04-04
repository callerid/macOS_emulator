//
//  objectiveC.m
//  macOsEthernetEmulator
//
//  Created by mac on 3/20/17.
//  Copyright © 2017 CallerId.com. All rights reserved.
//

#include "macOsEthernetEmulator-Bridging-Header.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <AppKit/AppKit.h>

void ShowStartPopup(){
    
    NSString* Title = @"Ethernet Emulator";
    NSString* Text = @"Sending packets via UDP. Focus will return to App after broadcasting is completed.";
    NSWindow* Window = [[NSApplication sharedApplication] mainWindow];
    
    NSAlert* alert = [[NSAlert alloc] init];
    
    NSButton* OkayButton = [alert addButtonWithTitle:@"Okay"];
    [OkayButton setHidden:true];
    [alert setMessageText:Title];
    
    [alert setInformativeText:Text];
    [alert setAlertStyle:NSAlertStyleInformational];
    
    [alert beginSheetModalForWindow:Window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertSecondButtonReturn) {
            NSLog(@"Failed");
            return;
        }
        
        NSLog(@"Success");
    }];
    
    [NSThread sleepForTimeInterval: 3.0f];
    
    [OkayButton performClick:nil];
    
}

void ShowEndPopup(){
    
    NSString* Title = @"Ethernet Emulator";
    NSString* Text = @"All packets have completed.";
    NSWindow* Window = [[NSApplication sharedApplication] mainWindow];
    
    NSAlert* alert = [[NSAlert alloc] init];
    
    NSButton* OkayButton = [alert addButtonWithTitle:@"Okay"];
    [OkayButton setHidden:true];
    [alert setMessageText:Title];
    
    [alert setInformativeText:Text];
    [alert setAlertStyle:NSAlertStyleInformational];
    
    [alert beginSheetModalForWindow:Window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertSecondButtonReturn) {
            NSLog(@"Failed");
            return;
        }
        
        NSLog(@"Success");
    }];
    
    [NSThread sleepForTimeInterval: 2.0f];
    
    [OkayButton performClick:nil];
    
}
