//
//  DisplayDataCallbackProtocol.h
//  CheckBTC
//
//  Created by Christian Schulze on 21.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header DisplayData Callback Protocol
 This is the minimum of selectors to respond to asure proper communication between
 the DataController and the data display delegate that handles the visual presentation.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.3
 @updated 22.04.14
 */
@protocol DisplayDataCallbackProtocol <NSObject>

/*!
 Display parts, the whole or a sum of the data
 @param text to display
 */
- (void)text:(NSString *)text;

@optional

/*!
 * Set text visualizing that the value decreased
 * @param text to set
 */
- (void)decreasingAnimationWithText:(NSString *)text;
 
/*!
 * Set text visualizing that the value increased
 *
 * @param text to set
 */
- (void)increasingAnimationWithText:(NSString *)text;

/*!
 * Display parts, the whole, or a sum of the data with animation of changes (if any)
 * @param text to display
 */
- (void)animationWithText:(NSString *)text;

/*!
 * Display parts or the whole of the error in case the data could not be obtained
 * @param text to display
 */
- (void)errorWithText:(NSError *)error;

@end
