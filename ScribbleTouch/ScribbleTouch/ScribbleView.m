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
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    for (NSDictionary * scribble in self.scribbles) {
        
        // stroke color & width
        
        CGContextSetLineWidth(context, [scribble[@"strokeWidth"] floatValue]);
        
        UIColor *fillColor = scribble[@"fillColor"];
        [fillColor set];
        
        // stroke path
        
        BOOL typeIsScribble = [scribble[@"type"] isEqualToString:@"Scribble"];
        BOOL typeIsLine = [scribble[@"type"] isEqualToString:@"Line"];
        
        if (typeIsScribble || typeIsLine) {
            
            CGPoint firstPoint = [scribble[@"points"][0] CGPointValue];
            CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
            
            for (NSValue * pointValue in scribble[@"points"]) {
                
                CGPoint point = [pointValue CGPointValue];
                CGContextAddLineToPoint(context, point.x, point.y);
                
            }
            
        }
        
        if ([scribble[@"type"] isEqualToString:@"Rectangle"]) {
            
            CGPoint firstPoint = [scribble[@"points"][0] CGPointValue];
            
            CGPoint secondPoint = [scribble[@"points"][1] CGPointValue];
            
            CGFloat width = secondPoint.x - firstPoint.x;
            CGFloat height = secondPoint.y - firstPoint.y;
            
            CGRect rect = CGRectMake(firstPoint.x, firstPoint.y, width, height);
            
            // fill
            //            CGContextSetBlendMode(context, kCGBlendModeMultiply);
            CGContextSetAlpha(context, [scribble[@"alpha"] floatValue]);
            CGContextFillRect(context, rect);
            
            // stroke?
            UIColor * strokeColor = scribble[@"strokeColor"];
            [strokeColor set];
            CGContextAddRect(context, rect);
            
            
            
        }
        
        if ([scribble[@"type"] isEqualToString:@"Triangle"]) {

            // fill
            UIColor *fillColor = scribble[@"fillColor"];
            [fillColor set];
            
            CGPoint firstPoint = [scribble[@"points"][0] CGPointValue];
            CGPoint secondPoint = [scribble[@"points"][1] CGPointValue];
            
            CGFloat width = secondPoint.x - firstPoint.x;
            
            CGContextSetAlpha(context, [scribble[@"alpha"] floatValue]);
            
            CGContextMoveToPoint(context, firstPoint.x + width / 2, firstPoint.y);
            CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
            CGContextAddLineToPoint(context, firstPoint.x, secondPoint.y);
            CGContextClosePath(context);
            CGContextFillPath(context);
            
            // stroke
            UIColor * strokeColor = scribble[@"strokeColor"];
            [strokeColor set];
            
            CGContextMoveToPoint(context, firstPoint.x + width / 2, firstPoint.y);
            CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
            CGContextAddLineToPoint(context, firstPoint.x, secondPoint.y);
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
        }
        
        if ([scribble[@"type"] isEqualToString:@"Ellipse"]) {
            
            UIColor *fillColor = scribble[@"fillColor"];
            [fillColor set];
            
            CGPoint firstPoint = [scribble[@"points"][0] CGPointValue];
            
            CGPoint secondPoint = [scribble[@"points"][1] CGPointValue];
            
            CGFloat width = secondPoint.x - firstPoint.x;
            CGFloat height = secondPoint.y - firstPoint.y;
            
            CGRect rect = CGRectMake(firstPoint.x, firstPoint.y, width, height);
            
            CGContextSetAlpha(context, [scribble[@"alpha"] floatValue]);
            CGContextFillEllipseInRect(context, rect);
            
            CGContextFillPath(context);
            
            // stroke
            UIColor * strokeColor = scribble[@"strokeColor"];
            [strokeColor set];
            CGContextStrokeEllipseInRect(context, rect);
            
        }
        
        CGContextStrokePath(context);
        
    }
    
}

@end
