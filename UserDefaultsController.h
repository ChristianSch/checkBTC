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

/*!
 @header Control saving and retrieving user defaults
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.2
 @updated 23.02.14
 */

#define currencyKey @"currency"
#define animationKey @"animatePriceChanges"
#define refreshRateKey @"refreshRate"
#define startAtLoginKey @"startAtLogin"

@interface UserDefaultsController : NSObject<UserDefaultsControllerDelegateProtocol>
{
	NSUserDefaults *userDefaults;
	LaunchAtLoginController *launchAtLoginController;
}

/*!
 @abstract Restore defaults user defaults
 */
- (void)initiateUserDefaultsWithDefaultSettings;

/*!
 Validate saved user defaults. If any setting is not valid, the default value will be set.
 */
- (void)validateUserDefaults;

@end
