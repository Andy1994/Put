//
//  ViewController.m
//  Put
//
//  Created by 王文博 on 15/5/16.
//  Copyright (c) 2015年 王文博. All rights reserved.
//

#import "ViewController.h"
#import "DefaultBehavior.h"
#import "TearOffBehavior.h"
#import "DraggableView.h"

const CGFloat kShapeDimension = 50.0;
const NSUInteger kSliceCount = 6;

@interface ViewController ()
@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) DefaultBehavior *defaultBehavior;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    CGRect frame = CGRectMake(0, 0, kShapeDimension, kShapeDimension);
    DraggableView *dragView = [[DraggableView alloc] initWithFrame:frame animator:self.animator];
    dragView.center = CGPointMake(self.view.center.x/4, self.view.center.y/4);
    dragView.alpha = 0.5;
    [self.view addSubview:dragView];
    
    DefaultBehavior *defaultBehavior = [DefaultBehavior new];
    [self.animator addBehavior:defaultBehavior];
    self.defaultBehavior = defaultBehavior;
    
    TearOffBehavior *tearOffBehavior = [[TearOffBehavior alloc] initWithDraggableView:dragView
                                                                               anchor:dragView.center
                                                                              handler:^(DraggableView *tornView,DraggableView *newPinView){
                                                                                  tornView.alpha = 1;
                                                                                  [defaultBehavior addItem:tornView];
                                                                                  
                                                                                  //双击粉碎
                                                                                  UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trash:)];
                                                                                  t.numberOfTapsRequired = 2;
                                                                                  [tornView addGestureRecognizer:t];
                                                                              }];
    [self.animator addBehavior:tearOffBehavior];
}

- (void)trash:(UIGestureRecognizer *)g
{
    UIView *view = g.view;
    // Calculate the new views.
    NSArray *subviews = [self sliceView:view
                               intoRows:kSliceCount
                                columns:kSliceCount];
    
    // Create a new animator
    UIDynamicAnimator *
    trashAnimator = [[UIDynamicAnimator alloc]
                     initWithReferenceView:self.view];
    
    // Create a new default behavior
    DefaultBehavior *defaultBehavior = [DefaultBehavior new];
    
    for (UIView *subview in subviews) {
        // Add the new "exploded" view to the hierarchy
        [self.view addSubview:subview];
        [defaultBehavior addItem:subview];
        
        // Create a push animation for each
        UIPushBehavior *
        push = [[UIPushBehavior alloc]
                initWithItems:@[subview]
                mode:UIPushBehaviorModeInstantaneous];
        [push setPushDirection:CGVectorMake((float)rand()/RAND_MAX - .5,
                                            (float)rand()/RAND_MAX - .5)];
        [trashAnimator addBehavior:push];
        
        // Fade out the pieces as they fly around.
        // At the end, remove them. Referencing trashAnimator here
        // also allows ARC to keep it around without an ivar.
        [UIView animateWithDuration:1
                         animations:^{
                             subview.alpha = 0;
                         }
                         completion:^(BOOL didComplete){
                             [subview removeFromSuperview];
                             [trashAnimator removeBehavior:push];
                         }];
    }
    
    // Remove the old view
    [self.defaultBehavior removeItem:view];
    [view removeFromSuperview];
}

- (NSArray *)sliceView:(UIView *)view intoRows:(NSUInteger)rows columns:(NSInteger)columns {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    CGImageRef image = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    
    NSMutableArray *views = [NSMutableArray new];
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    for (NSUInteger row = 0; row < rows; ++row) {
        for (NSUInteger column = 0; column < columns; ++column) {
            CGRect rect = CGRectMake(column * (width / columns),
                                     row * (height / rows),
                                     width / columns,
                                     height / rows);
            CGImageRef subimage = CGImageCreateWithImageInRect(image, rect);
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithCGImage:subimage]];
            CGImageRelease(subimage); subimage = NULL;
            
            imageView.frame = CGRectOffset(rect,
                                           CGRectGetMinX(view.frame),
                                           CGRectGetMinY(view.frame));
            [views addObject:imageView];
        }
    }
    
    return views;
}


@end
