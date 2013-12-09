//
//  PreferencesController.h
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController
{
	BOOL debug;
	__weak NSPopUpButton *_currencies;
	__weak NSTextField *_refreshRate;
}

/*!
 @abstract Act on pushing the save button by making up a notification savePreferences with the given input saved in the userInfo dictionary
 */
- (IBAction)savePrefs:(id)sender;

@property (weak) IBOutlet NSPopUpButton *currencies;
@property (weak) IBOutlet NSTextField *refreshRate;
@end
