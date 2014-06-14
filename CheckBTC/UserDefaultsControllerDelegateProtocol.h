//
//  UserDefaultsControllerDelegateProtocol.h
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header User Defaults Controller Delegate Protocol
This provides necessary selectors to work with the user default controller
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.3
 @updated 15.04.14
 */
@protocol UserDefaultsControllerDelegateProtocol <NSObject>

/*!
 Set user defaults with values from dictionary
 
 @param dict that holds the new values
 */
- (void)userDefaultsWithDict:(NSDictionary *)dict;

/*!
 Get value set for key `key`.
 
 @param key as specified in `UserDefaultsAccessKeys.h"
 
 @return default value for `key`
 */
- (id)userDefaultForKey:(NSString *)key;

@end
