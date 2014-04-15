//
//  StatusBarController.m
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#define APP_TITLE @"CheckBTC"

#import "StatusBarController.h"

@implementation StatusBarController

- (id)initWithMenu:(NSMenu *)appMenu
{
	self = [super init];
	
	if (self != nil) {
		lastUsedValue = [NSNumber numberWithInt:0];
		_appMenu = appMenu;
		itemController = [[StatusBarItemController alloc] init];
		
		[itemController initStatusBarItemWithNSString:self->_appMenu textToSet:APP_TITLE];
	}
	
	return self;
}

- (void)setTextFromError:(NSError*)error
{
	if ([error code] == NSURLErrorNotConnectedToInternet)
	{
		[self showWarningWithMessage:@"No internet connection"];
		
		// regular
	} else {
		[self showWarningWithMessage:@"Connection failed"];
	}
	
	/*	// debug
	 } else {
		[self showWarningWithMessage:[error localizedDescription]];
	}
	 */
}

- (void)showWarningWithMessage:(NSString *)message
{
	NSMenuItem *item = [_appMenu itemWithTag:1337];
	
	if ([_appMenu itemWithTag:1337] == nil)
	{
		/* Set up the image */
		NSImage *warningImage = [NSImage imageNamed:NSImageNameCaution];
		[warningImage setScalesWhenResized: YES];
		[warningImage setSize: NSMakeSize(16, 16)];
		
		/* add to menu */
		NSMenuItem *warningItem = [[NSMenuItem alloc] init];
		[warningItem setImage:warningImage];
		[warningItem setTitle:message];
		[warningItem setTag:1337];
		
		[_appMenu insertItem:warningItem atIndex:0];
		[_appMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
		
	} else {
		[item setTitle:message];
	}
}

- (void)clearWarning
{
	NSMenuItem *item = [_appMenu itemWithTag:1337];
	[_appMenu removeItem:item];
	
}

#pragma mark - update contents of the status item

- (void)setTextWithDescAnimation:(NSString *)text
{
	[itemController defaultRedToBlackAnimationWithNSString:text];
}

- (void)setTextWithAscAnimation:(NSString *)text
{
	[itemController defaultGreenToBlackAnimationWithNSString:text];
}

- (void)setText:(NSString *)text
{
	[itemController setText:text];
}


@end
