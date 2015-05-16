//
//  DefaultBehavior.m
//  Put
//
//  Created by 王文博 on 15/5/16.
//  Copyright (c) 2015年 王文博. All rights reserved.
//

#import "DefaultBehavior.h"

@implementation DefaultBehavior
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        UICollisionBehavior *collisionBehavior = [UICollisionBehavior new];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self addChildBehavior:collisionBehavior];
        [self addChildBehavior:[UIGravityBehavior new]];
    }
    return self;
}

- (void)addItem:(id<UIDynamicItem>)item
{
    for(id behavior in self.childBehaviors)
    {
        [behavior addItem:item];
    }
}

- (void)removeItem:(id<UIDynamicItem>)item
{
    for(id behavior in self.childBehaviors)
    {
        [behavior removeItem:item];
    }
}
@end
