//
//  PreferencesController.m
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

#pragma mark - Lifecycle
-(id)init
{
	debug = YES;
	
	self = [super initWithWindowNibName:@"Preferences"];
	if (self) {
		[self loadWindow];
	}
	
	return (self);
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
	
    if (self) {
        [self loadWindow];
    }
	
    return self;
}

#pragma mark - Event handling
- (void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *rate = [defaults objectForKey:@"refreshRate"];
	NSString *curr = [defaults stringForKey:@"currency"];
	self.startAtLogin = [defaults boolForKey:@"startAtLogin"];
	
	if (rate != nil) {
		if (debug) NSLog(@"rate to set: %f", [rate doubleValue]);
		[_refreshRate setStringValue:[rate stringValue]];
	}
	
	if (curr != nil) {
		if (debug) NSLog(@"curr to set: %@", curr);
		[_currencies selectItemWithTitle:curr];
	}
}

#pragma mark - API to preferences

- (IBAction)savePrefs:(id)sender
{
	/*
	 TODO:
	 * get preferences and set TextField and PopUpButton accordingly
	 */
	
	NSString *currency = [[[self currencies] selectedItem] title];
	NSNumber *rRate = @([[self refreshRate] doubleValue]);
	
	/* Check refresh rate for validity. */
	if ([rRate doubleValue] < 10.0) {
		if (debug) NSLog(@"Setting refresh rate to 10.0 because of invalid input.");
		rRate = @10.0;
	}
	
	/* Make up the dictionary */
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:currency forKey:@"currency"];
	[dict setValue:rRate forKey:@"refreshRate"];
	[dict setValue:[[NSNumber alloc] initWithBool:[self startAtLogin]] forKey:@"startAtLogin"];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL oldStatus = [defaults boolForKey:@"startAtLogin"];
	
	if (debug) NSLog(@"oldStatus: %hhd", oldStatus);
	if (debug) NSLog(@"startAtLogin: %hhd", self.startAtLogin);
	
	if (oldStatus != self.startAtLogin) {
		if (self.startAtLogin) {
			NSString *appPath = [[NSBundle mainBundle] bundlePath];
			
			[self enableLoginItemWithURL:appPath];
		} else {
			NSString *appPath = [[NSBundle mainBundle] bundlePath];
			[self disableLoginItemWithURL:appPath];
		}
	}
	
	/* Send notification to all objects listening to the savePreferences method (That'd be only the AppDelegate) for saving. */
	[[NSNotificationCenter defaultCenter] postNotificationName:@"savePreferences"
														object:self
													  userInfo:dict];
	/* Hide window */
	[[self window] orderOut:self];
}

#pragma mark - Login item management

- (void)enableLoginItemWithURL:(NSString *)itemURL
{
	if (debug) NSLog(@"add login item");
	/* Code by: http://cocoatutorial.grapewave.com/2010/02/creating-andor-removing-a-login-item/ */
	
	
	/* Retrieve app url.
	 
	 CFBridgingRetain: Cast an Objective-C pointer to a Core Foundation pointer and also transfers ownership to the caller. Needed to manage the lifetime of the object. */
	CFURLRef url = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:itemURL]);
	
	/* Add the login item to the current users login */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
															kLSSharedFileListSessionLoginItems,
															NULL);
	if (loginItems) {
		//Insert an item to the list.
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
																	 kLSSharedFileListItemLast,
																	 NULL,
																	 NULL,
																	 url,
																	 NULL,
																	 NULL);
		if (item){
			CFRelease(item);
		}
	}
	
	/* Release core foundations objects */
	CFRelease(url);
	CFRelease(loginItems);
}

- (void) disableLoginItemWithURL:(NSString *)itemURL
{
	if (debug) NSLog(@"remove login item");
	/* Code by: http://cocoatutorial.grapewave.com/2010/02/creating-andor-removing-a-login-item/ */
	
	
	/* Retrieve app url.
	 
	 CFBridgingRetain: Cast an Objective-C pointer to a Core Foundation pointer and also transfers ownership to the caller. Needed to manage the lifetime of the object. */
	CFURLRef url = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:itemURL]);
	
	/* Add the login item to the current users login */
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
															kLSSharedFileListSessionLoginItems,
															NULL);
	
	if (loginItems) {
		UInt32 seedValue;
		// Retrieve the list of Login Items and cast them to
		// a NSArray so that it will be easier to iterate.
		NSArray  *loginItemsArray = (NSArray *)CFBridgingRelease(LSSharedFileListCopySnapshot(loginItems, &seedValue));
		int i;
		for(i = 0 ; i< [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)CFBridgingRetain([loginItemsArray
																						 objectAtIndex:i]);
			// Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(NSURL*)CFBridgingRelease(url) path];
				if ([urlPath isEqualToString:itemURL]){
					LSSharedFileListItemRemove(loginItems,itemRef);
				}
			}
		}
	}
	
	/* release core foundation object */
	CFRelease(url);
}
@end
