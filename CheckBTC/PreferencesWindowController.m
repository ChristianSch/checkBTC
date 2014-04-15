//
//  PreferencesController.m
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

@synthesize PluginHelpPopoverController;

#pragma mark - Lifecycle
-(id)init
{
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

#pragma mark - delegates
- (void)setUserDefaultsDelegate:(id<UserDefaultsControllerDelegateProtocol>)delegate
{
	userDefaultsDelegate = delegate;
}

- (void)setPluginControllerDelegate:(id<PluginControllerDelegateProtocol>)delegate
{
	pluginControllerDelegate = delegate;
}

#pragma mark - Event handling
- (void)windowMakeKeyAndOrderFront:(id)sender
{
	NSNumber *rate = [userDefaultsDelegate userDefaultForKey:refreshRateKey];
	NSString *curr = [userDefaultsDelegate userDefaultForKey:currencyKey];
	self.startAtLogin = (BOOL) [userDefaultsDelegate userDefaultForKey:startAtLoginKey];
	
	if (rate != nil)
		[_refreshRate setStringValue:[rate stringValue]];
	
	if (curr != nil)
		[_currencies selectItemWithTitle:curr];
	
	/* fill pop up button with available marketplaces */
	NSArray *marketplaces = [pluginControllerDelegate availableBundles];
	
	if (pluginControllerDelegate == nil) NSLog(@"no such plugin delegate!");
	
	for (int i = 0; i < [marketplaces count]; i++)
	{
		[_arrayController addObject:marketplaces[i]];
	}
	
	[[self window] makeKeyAndOrderFront:sender];
}


#pragma mark - API to user defaults

- (IBAction)savePrefs:(id)sender
{
	if (userDefaultsDelegate != nil)
	{
		NSString *currency = [[[self currencies] selectedItem] title];
		NSNumber *rRate = @([[self refreshRate] doubleValue]);
		
		/* Make up the dictionary */
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		
		[dict setValue:currency forKey:currencyKey];
		[dict setValue:rRate forKey:refreshRateKey];
		[dict setValue:[[NSNumber alloc] initWithBool:[self startAtLogin]]
				forKey:startAtLoginKey];
		[dict setValue:[[NSNumber alloc] initWithBool:[self animatePriceChanges]]
				forKey:animationKey];
		
		[userDefaultsDelegate userDefaultsWithDict:dict];
		
	} else {
		NSLog(@"No user defaults delegate! No settings saved.");
	}
	
	/* Hide window */
	[[self window] orderOut:self];
}

// just backup code from appDelegate. ignore
- (void)savePreferences:(NSNotification *)notif
{
	BOOL changed = NO;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *curr = [notif userInfo][@"currency"];
	NSString *rate = [notif userInfo][@"refreshRate"];
	BOOL startAtLogin = [[[notif userInfo] objectForKey:@"startAtLogin"] boolValue];
	
	if (![curr isEqualToString:[defaults stringForKey:@"currency"]])
	{
		[defaults removeObjectForKey:@"currency"];
		[defaults setObject:curr forKey:@"currency"];
		
		changed = YES;
		
	} else if ([rate doubleValue] != [[defaults objectForKey:@"refreshRate"] doubleValue])
	{
		[defaults removeObjectForKey:@"refreshRate"];
		[defaults setObject:rate forKey:@"refreshRate"];
		
		changed = YES;
		
	} else if (startAtLogin) {
		[defaults setBool:YES forKey:@"startAtLogin"];
	}
	
	/* TODO: really save them */
	// placeholder:
	if (changed) NSLog(@"New preferences will be ignored due to missing implementaitons");
}

- (IBAction)showPluginHelp:(id)sender
{
	[[self popover] showRelativeToRect:[sender bounds]
								ofView:sender
						 preferredEdge:NSMaxYEdge];
}

- (IBAction)showPluginFolderInFinder:(id)sender
{
	NSString *pluginDir = [[[NSBundle mainBundle] bundlePath]
						   stringByAppendingString:@"/Contents/Resources/Resources/APIControllerBundles/"];
	
	NSURL * dirURL = [[NSURL alloc] initFileURLWithPath:pluginDir];
	[[NSWorkspace sharedWorkspace] openURL: dirURL];
}
@end
