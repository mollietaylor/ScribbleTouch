//
//  GoldButtons.m
//  ScribbleTouch
//
//  Created by Mollie on 1/16/15.
//  Copyright (c) 2015 Jo Albright. All rights reserved.
//

#import "GoldButtons.h"

@implementation GoldButtons

- (void)drawRect:(CGRect)rect {
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[UIColor colorWithRed:161.0/255.0 green:153.0/255.0 blue:81.0/255.0 alpha:1.0].CGColor];
}


@end