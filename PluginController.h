//
//  PluginController.h
//  CheckBTC
//
//  Created by X on 05.03.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PluginController : NSObject
{
	NSBundle *appBundle;
	NSArray *bundlePaths;
}

- (void)loadBundles;
- (NSArray *)listBundles;

@end
