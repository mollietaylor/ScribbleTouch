//
//  RoundButton.m
//  ScribbleTouch
//
//  Created by Mollie on 1/16/15.
//  Copyright (c) 2015 Jo Albright. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}

@end
