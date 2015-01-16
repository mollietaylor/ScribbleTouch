//
//  RoundLabel.m
//  ScribbleTouch
//
//  Created by Mollie on 1/16/15.
//  Copyright (c) 2015 Jo Albright. All rights reserved.
//

#import "RoundLabel.h"

@implementation RoundLabel

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

@end
