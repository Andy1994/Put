//
//  TearOffBehavior.h
//  Put
//
//  Created by 王文博 on 15/5/16.
//  Copyright (c) 2015年 王文博. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DraggableView;
typedef void(^TearOffHandler) (DraggableView *tornView,DraggableView *newPinView);

@interface TearOffBehavior : UIDynamicBehavior
@property BOOL active;
- (instancetype)initWithDraggableView:(DraggableView *)view
                               anchor:(CGPoint)anchor
                              handler:(TearOffHandler)handler;
@end
