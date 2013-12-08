//
//  Preferences.h
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Preferences:
 
 {
	"refreshRate"	: NSNumber,
	"currency"		: NSString
 }
 */

@interface UserDefs : NSObject
{
	NSMutableDictionary * defaultPrefs;
	NSUserDefaults * prefs;
}

/*!
 @abstract initiate attributes and set default properties
 @return self
 */
- (id)init;

/*!
 @abstract initiate with default preferences
 @param dict default preferences
 @return self
 */
- (id)initWithDefaultPreferences:(NSDictionary *)dict;

/*!
 @abstract set user defaults to default properties
 */
- (void)setDefaultPreferences;

/*!
 @abstract set user defaults to given dictionary <dict>
 @param dict user defaults to set
 */
- (void)setPreferences:(NSDictionary *)dict;

/*!
 @abstract return properties
 @return properties
 */
- (NSDictionary *)getPreferences;

/*!
 @abstract return property of key if it exists. otherwise nil will be returned.
 @param key key for value retrievement
 @return value for given key
 */
- (id)getPreferencesForKey:(NSString *)key;
@end
