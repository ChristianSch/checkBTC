//
//  AppDelegate.h
//  CheckBTC
//
//  Created by Christian Schulze on 04.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//
#define APP_TITLE @"CheckBTC"
#define VERSION @1.0

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	BOOL debug;
	NSTimer *theTimer;
	NSRunLoop *runLoop;
	
	NSStatusItem *menuItem;
	__weak NSMenu *_appMenu;
	__weak NSMenuItem *_openAboutItem;
	__weak NSMenuItem *_openPrefItem;
	__weak NSMenuItem *_quit;
	
	/* Settings */
	NSString *currency;
	NSNumber *refreshRate;
	
	IBOutlet PreferencesController *preferencesController;
	
	/* Data */
	NSDictionary *trackerData;
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

/*!
 @abstract Handle the savePreferences notification and save the dict to user defaults.
 @param dict NSDictionary to write
 */
- (void)savePreferences:(NSDictionary *)dict;

/* Update relevant methods */
/*!
 @abstract Get the value of one BTC and refresh the menu bar item.
 @discussion This is executed by a NSTimer.
 */
- (void)workerMethod:(NSTimer*)theTimer;

/*!
 @abstract Update the text displayed in the status bar.
 @param newText text to display
 */
- (void)refreshMenuItemText:(NSString *)newText;

/*!
 @abstract Update the timer to the new refresh rate. This is done by invalidating the old timer and installing a new one.
 */
- (void)refreshTimer:(double)rate;

@property (unsafe_unretained) IBOutlet NSWindow *prefWindow;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *appMenu;
@property (weak) IBOutlet NSMenuItem *openAboutItem;
@property (weak) IBOutlet NSMenuItem *openPrefItem;
@property (weak) IBOutlet NSMenuItem *quit;
@property (weak) NSTimer *repeatingTimer;

@end
