//
//  StatusBarController.h
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusBarItemController.h"
#import "DisplayDataCallbackProtocol.h"

/*!
 @header StatusBarController
 This controller handles the statusBar menu and statusBarItem.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.2
 @updated 23.02.14
 */
@interface StatusBarController : NSObject <DisplayDataCallbackProtocol>
{
	NSMenu *_appMenu;
	StatusBarItemController *itemController;
	NSNumber *lastUsedValue;
}

- (id)initWithMenu:(NSMenu *)appMenu;

#pragma mark - warnings

- (void)showWarningWithMessage:(NSString *)message;
- (void)clearWarning;

#pragma mark - update contents of the status item

- (void)decreasingAnimationWithText:(NSString *)text;
- (void)increasingAnimationWithText:(NSString *)text;
- (void)text:(NSString *)text;

@end
