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

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	__weak NSMenu *_appMenu;
	__weak NSMenuItem *_openAboutItem;
	__weak NSMenuItem *_openPrefItem;
	__weak NSMenuItem *_quit;
	
	/* Controllers */
	IBOutlet PreferencesWindowController *preferencesWindowController;
	DataController *dataController;
	UserDefaultsController *userDefaultsController;
	StatusBarController *statusBarController;
}

- (void)applicationWillTerminate:(NSNotification *)notification;

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

@property (unsafe_unretained) IBOutlet NSWindow *prefWindow;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *appMenu;
@property (weak) IBOutlet NSMenuItem *openAboutItem;
@property (weak) IBOutlet NSMenuItem *openPrefItem;
@property (weak) IBOutlet NSMenuItem *quit;

@end
