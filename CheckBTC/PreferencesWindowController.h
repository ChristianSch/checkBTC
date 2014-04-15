//
//  PreferencesController.h
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserDefaultsControllerDelegateProtocol.h"
#import "PluginControllerDelegateProtocol.h"
#import "UserDefaultAccessKeys.h"

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
	NSArrayController *_arrayController;
	__weak NSPopUpButton *_currencies;
	__weak NSTextField *_refreshRate;
	__weak NSTextField *_formatting;
	
	id<UserDefaultsControllerDelegateProtocol> userDefaultsDelegate;
	id<PluginControllerDelegateProtocol> pluginControllerDelegate;
	
	NSPopover *_popover;
	NSViewController *_PluginHelpPopover;
}

/*!
 @abstract Act on pushing the save button by making up a notification
 savePreferences with
 the given input saved in the userInfo dictionary
 */
- (IBAction)savePrefs:(id)sender;

/*!
 @abstract Set the delegate to handle changes made to the user defaults
 @param delegate handles the changes
 */
- (void)setUserDefaultsDelegate:(id<UserDefaultsControllerDelegateProtocol>)delegate;

/*!
 @abstract Set the delegate for listing available plugins and setting the plugin
 to use.
 @param delegate
 */
- (void)setPluginControllerDelegate:(id<PluginControllerDelegateProtocol>)delegate;

- (void)windowMakeKeyAndOrderFront:(id)sender;

- (IBAction)showPluginHelp:(id)sender;

- (IBAction)showPluginFolderInFinder:(id)sender;

@property (weak) IBOutlet NSPopUpButton *currencies;
@property (weak) IBOutlet NSTextField *refreshRate;
@property BOOL animatePriceChanges;
@property BOOL startAtLogin;

@property (strong) IBOutlet NSViewController *PluginHelpPopoverController;
@property (strong) IBOutlet NSPopover *popover;
@property (weak) IBOutlet NSPopUpButton *marketplaces;
@property (weak) IBOutlet NSTextField *formatting;
@property (strong) IBOutlet NSArrayController *arrayController;
@end
