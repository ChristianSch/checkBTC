//
//  UserDefaultsController.h
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultsControllerDelegateProtocol.h"
#import "LaunchAtLoginController.h"
#import "UserDefaultAccessKeys.h"

/*!
 @header Control saving and retrieving user defaults
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.2
 @updated 23.02.14
 */

/*
 * Note: the plugin is not specified because a fallback (means default) will be chosen
 * according to the currency.
 */
#define defaultSettings @{ currencyKey: @"EUR",\
	refreshRateKey: @60,\
	animationKey: @YES,\
	startAtLoginKey: @YES\
}

@interface UserDefaultsController : NSObject<UserDefaultsControllerDelegateProtocol>
{
	NSUserDefaults *userDefaults;
	const NSDictionary *defaultUserDefaults;
	LaunchAtLoginController *launchAtLoginController;
}

/*!
 Validate saved user defaults. If any setting is not valid, the default value will be set.
 */
- (void)validateUserDefaults;

@end
