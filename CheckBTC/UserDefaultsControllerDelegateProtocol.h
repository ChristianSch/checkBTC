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
 @version 0.2
 @updated 21.02.14
 */
@protocol UserDefaultsControllerDelegateProtocol <NSObject>

/*!
 @abstract At which refresh rate data should be retrieved.
 */
- (double)dataRefreshRate;

/*!
 @abstract Whether displaying of the data be animated or not.
 */
- (BOOL)animateVisualRepresentation;

/*!
 @abstract The currency the user wants to be used.+
 */
- (NSString*)currency;

/*!
 @abstract Set user defaults with values from dictionary
 @param dict that holds the new values
 */
- (void)setUserDefaultsWithDict:(NSDictionary*)dict;

@end