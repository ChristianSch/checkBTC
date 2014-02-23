//
//  PreferencesController.h
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserDefaultsControllerDelegateProtocol.h"

/*!
 @header PreferencesWindowController
 This controller handles the preferences window nib
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.4
 @updated 23.02.14
 */
@interface PreferencesWindowController : NSWindowController
{
	BOOL debug;
	__weak NSPopUpButton *_currencies;
	__weak NSTextField *_refreshRate;
	id<UserDefaultsControllerDelegateProtocol> userDefaultsDelegate;
}

/*!
 @abstract Act on pushing the save button by making up a notification
 savePreferences with
 the given input saved in the userInfo dictionary
 */
- (IBAction) savePrefs:(id)sender;

/*!
 @abstract Set the delegate to handle changes made to the user defaults
 @param delegate handles the changes
 */
- (void)setUserDefaultsDelegate:(id<UserDefaultsControllerDelegateProtocol>)delegate;

@property (weak) IBOutlet NSPopUpButton *currencies;
@property (weak) IBOutlet NSTextField *refreshRate;
@property BOOL startAtLogin;

@end
