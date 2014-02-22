//
//  DisplayDataCallbackProtocol.h
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
@protocol DisplayDataCallbackProtocol <NSObject>

/*!
 @abstract Display parts, the whole or a sum of the data
 @param text to display
 */
- (void)setText:(NSString *)text;

@optional

/*!
 @abstract Display parts, the whole, or a sum of the data with animation of changes (if any)
 @param text to display
 */
- (void)setTextWithAnimation:(NSString *)text;

/*!
 @abstract Display parts or the whole of the error in case the data could not be obtained
 @param text to display
 */
- (void)setTextFromError:(NSError*)error;

@end
