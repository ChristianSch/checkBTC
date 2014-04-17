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
	if (pluginControllerDelegate)
	{
		NSArray *availableBundles = [pluginControllerDelegate availableBundles];
		
		if ([availableBundles count] > 0)
		{
			[_currencies setEnabled:YES];
			[_bundlePopup setEnabled:YES];
			
			for (int i = 0; i < [availableBundles count]; i++)
			{
				if (![[_arrayController content] containsObject:availableBundles[i]])
				{
					[_arrayController addObject:availableBundles[i]];
				}
			}
			
		} else {
			[_currencies setEnabled:NO];
			[_bundlePopup setEnabled:NO];
		}
		
	} else {
		NSLog(@"no such plugin delegate!");
	}
	
	[[self window] makeKeyAndOrderFront:sender];
}


#pragma mark - API to user defaults

- (IBAction)savePrefs:(id)sender
{
	NSString *oldBundle = [userDefaultsDelegate userDefaultForKey:bundleKey];
	
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
		NSString *newBundle = [[_bundlePopup selectedItem] title];
		[dict setValue:newBundle forKey:bundleKey];
		
		[userDefaultsDelegate userDefaultsWithDict:dict];
		
		if ([pluginControllerDelegate isValidBundle:newBundle]
			 && !([oldBundle isEqualTo:newBundle]))
		{
			[pluginControllerDelegate
			 loadBundleAsPluginWithPath:[pluginControllerDelegate
								 pathForBundleName:newBundle]];
		}
		
	} else {
		NSLog(@"No user defaults delegate! No settings saved.");
	}
	
	/* Hide window */
	[[self window] orderOut:self];
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
