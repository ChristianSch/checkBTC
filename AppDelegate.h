//
//  AppDelegate.h
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesWindowController.h"
#import "StatusBarController.h"
#import "DataController.h"
#import "UserDefaultsController.h"
#import "PluginController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	IBOutlet NSWindow *prefWindow;
	IBOutlet NSWindow *window;
	IBOutlet NSMenu *appMenu;
	IBOutlet NSMenuItem *openAboutItem;
	IBOutlet NSMenuItem *openPrefItem;
	IBOutlet NSMenuItem *quit;

	/* Controllers */
	IBOutlet PreferencesWindowController *preferencesWindowController;
	DataController *dataController;
	UserDefaultsController *userDefaultsController;
	StatusBarController *statusBarController;
	PluginController *pluginController;
}

/*!
 This called causes the "About CheckBTC" window to be shown.
 
 @param sender Typically the sender of the message.
 */
- (IBAction)showAbout:(id)sender;

/*!
 This called causes the "Preferences" window to be shown. Handling of the window is done by the PreferencesWindowController.

 @param sender Typically the sender of the message.
 */
- (IBAction)showPreferences:(id)sender;

@end
