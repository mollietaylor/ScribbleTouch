//
//  ScribbleView.m
//  ScribbleTouch
//
//  Created by Jo Albright on 1/14/15.
//  Copyright (c) 2015 Jo Albright. All rights reserved.
//

#import "ScribbleView.h"

@implementation ScribbleView

- (NSMutableArray *)scribbles {
    
    if (_scribbles == nil) { _scribbles = [@[] mutableCopy]; }
    return _scribbles;
    
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (NSDictionary * scribble in self.scribbles) {
        
        NSArray *points = scribble[@"points"];
        
        if (points.count < 2) continue;
        
        [self addToContext:context withScribble:scribble andType:@"Fill"];
        [self addToContext:context withScribble:scribble andType:@"Stroke"];
        
    }
    
}

- (void)addToContext:(CGContextRef)context withScribble:(NSDictionary *)scribble andType:(NSString *)type {
    
    NSArray *points = scribble[@"points"];
    
    NSArray *shapeTypes = @[
                                @"Scribble",
                                @"Line",
                                @"Ellipse",
                                @"Triangle",
                                @"Rectangle"
                                ];
    
    NSArray *blendModes = @[
                             @"Normal",
                             @"Screen",
                             @"Multiply",
                             @"Overlay",
                             @"Clear"
                             ];
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, [scribble[@"strokeWidth"] floatValue]);
    
    CGPoint firstPoint = [scribble[@"points"][0] CGPointValue];
    CGPoint secondPoint = [scribble[@"points"][1] CGPointValue];
    
    CGFloat width = secondPoint.x - firstPoint.x;
    CGFloat height = secondPoint.y - firstPoint.y;
    
    CGRect rect = CGRectMake(firstPoint.x, firstPoint.y, width, height);
    
    switch ([shapeTypes indexOfObject:scribble[@"type"]]) {
        case 0 : // Scribble
        case 1 : // Line
            
            CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
            
            for (NSValue * pointValue in scribble[@"points"]) {
                
                CGPoint point = [pointValue CGPointValue];
                CGContextAddLineToPoint(context, point.x, point.y);
                
            }
            
            break;
        
        case 2 : // Ellipse
            
            if (points.count > 1) {
                
                CGContextAddEllipseInRect(context, rect);
            }
            
            break;
            
        case 3 : // Triangle
            
            if (points.count > 1) {
                
                CGContextMoveToPoint(context, firstPoint.x + width / 2, firstPoint.y);
                CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
                CGContextAddLineToPoint(context, firstPoint.x, secondPoint.y);
                CGContextClosePath(context);
                
            }
            
            break;
            
        case 4 : // Rectangle
            
            if (points.count > 1) {
                
                CGContextAddRect(context, rect);
                
            }
            
            break;
            
        default:
            break;
    }

    
    if([type isEqualToString:@"Fill"]) {
        
        UIColor *fillColor = scribble[@"fillColor"];
        [fillColor set];
        CGContextSetAlpha(context, [scribble[@"alpha"] floatValue]);
        
        
# warning Not sure if blend mode is working
        switch ([blendModes indexOfObject:scribble[@"blend"]]) {
            case 0 : // Normal
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                break;
                
            case 1 : // Screen
                CGContextSetBlendMode(context, kCGBlendModeScreen);
                break;
            
            case 2 : // Multiply
                CGContextSetBlendMode(context, kCGBlendModeMultiply);
                break;
                
            case 3 : // Overlay
                CGContextSetBlendMode(context, kCGBlendModeOverlay);
                break;
                
            case 4 : // Clear
                CGContextSetBlendMode(context, kCGBlendModeClear);
                break;
                
            default:
                break;
        }
        
        CGContextFillPath(context);
        
    } else {
        
        UIColor * strokeColor = scribble[@"strokeColor"];
        [strokeColor set];
        CGContextStrokePath(context);
        
    }
    
}

@end
