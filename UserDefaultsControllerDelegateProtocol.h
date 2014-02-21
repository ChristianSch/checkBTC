//
//  UserDefaultsControllerDelegateProtocol.h
//  CheckBTC
//
//  Created by X on 21.02.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDefaultsControllerDelegateProtocol <NSObject>

- (double)dataRefreshRate;
- (BOOL)animateVisualRepresentation;

@end
