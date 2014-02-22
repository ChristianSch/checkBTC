//
//  UserDefaultsControllerDelegateProtocol.h
//  CheckBTC
//
//  Created by X on 21.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header DisplayData Callback Protocol
 This is the minimum of selectors to respond to asure proper communication between
 the DataController and the data display delegate that handles the visual presentation.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.1
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

@end
