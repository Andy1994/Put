//
//  DefaultBehavior.h
//  Put
//
//  Created by 王文博 on 15/5/16.
//  Copyright (c) 2015年 王文博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultBehavior : UIDynamicBehavior
- (void)addItem:(id<UIDynamicItem>)item;
- (void)removeItem:(id<UIDynamicItem>)item;
@end
