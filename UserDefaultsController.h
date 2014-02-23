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
 @version 0.1
 @updated 21.02.14
 */

#define currencyKey @"currency"
#define animationKey @"animate"
#define refreshRateKey @"refreshRate"
#define startAtLoginKey @"startAtLogin"

@interface UserDefaultsController : NSObject<UserDefaultsControllerDelegateProtocol>
{
	NSUserDefaults *userDefaults;
	LaunchAtLoginController *launchAtLoginController;
}

- (void)initiateUserDefaultsWithDefaultSettings;

@end
