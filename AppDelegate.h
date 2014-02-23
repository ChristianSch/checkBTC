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
	BOOL debug;
	NSTimer *theTimer;
	NSRunLoop *runLoop;
	
	__weak NSMenu *_appMenu;
	__weak NSMenuItem *_openAboutItem;
	__weak NSMenuItem *_openPrefItem;
	__weak NSMenuItem *_quit;
	
	/* Settings */
	NSString *currency;
	NSNumber *refreshRate;
	
	/* Controllers */
	IBOutlet PreferencesWindowController *preferencesWindowController;
	DataController *dataController;
	UserDefaultsController *userDefaultsController;
	StatusBarController *statusBarController;
}

/*!
 @abstract Act on exit.
 @param sender TODO
 */
- (IBAction)terminate:(id)sender;

/* Method for showing the about pane */
/*!
 @abstract Show about pane
 */
- (IBAction)showAbout:(id)sender;

/* Methods relevant to showing the preferences pane or saving them */
/*!
 @abstract Open preferences window
 @param sender TODO
 */
- (IBAction)showPreferences:(id)sender;

@property (unsafe_unretained) IBOutlet NSWindow *prefWindow;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *appMenu;
@property (weak) IBOutlet NSMenuItem *openAboutItem;
@property (weak) IBOutlet NSMenuItem *openPrefItem;
@property (weak) IBOutlet NSMenuItem *quit;
@property (weak) NSTimer *repeatingTimer;

@end
