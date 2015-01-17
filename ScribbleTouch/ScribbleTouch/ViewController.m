//
//  ViewController.m
//  ScribbleTouch
//
//  Created by Jo Albright on 1/14/15.
//  Copyright (c) 2015 Jo Albright. All rights reserved.
//

#import "ViewController.h"
#import "ScribbleView.h"
#import "ChoiceViewController.h"
#import "RoundLabel.h"

@interface ViewController () <ChoiceViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *blendModeButton;
@property (weak, nonatomic) IBOutlet UIButton *shapeTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;


// drawer icons
@property (weak, nonatomic) IBOutlet UIImageView *strokeColorIcon;
@property (weak, nonatomic) IBOutlet RoundLabel *fillColorIcon;
@property (weak, nonatomic) IBOutlet RoundLabel *strokeWidthIcon;
@property (weak, nonatomic) IBOutlet RoundLabel *alpha1;
@property (weak, nonatomic) IBOutlet RoundLabel *alpha2;
@property (weak, nonatomic) IBOutlet RoundLabel *blend1;
@property (weak, nonatomic) IBOutlet RoundLabel *blend2;
@property (weak, nonatomic) IBOutlet UIImageView *selectedShapeImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drawerLeftConstraint;

@end

@implementation ViewController
{
    NSMutableDictionary * currentScribble;
    UIColor * selectedStrokeColor;
    UIColor *selectedFillColor;
    int selectedStrokeWidth;
    float shapeAlpha;
    NSString *selectedBlendMode;
    NSString *selectedShapeType;
    int counter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedFillColor = [UIColor colorWithRed:0.95 green:0.35 blue:0.12 alpha:1];
    selectedStrokeColor = [UIColor blackColor];
    selectedStrokeWidth = 10;
    selectedBlendMode = @"Normal";
    selectedShapeType = @"Scribble";
    shapeAlpha = 1;
    counter = 0;

}

- (IBAction)changeStrokeColor:(UIButton *)sender {
    
    selectedStrokeColor = sender.backgroundColor;
    
    self.strokeColorIcon.image = [sender backgroundImageForState:UIControlStateNormal];    
    
}

- (IBAction)changeFillColor:(UIButton *)sender {
    
    selectedFillColor = sender.backgroundColor;
    
    // drawer icons
    self.fillColorIcon.backgroundColor = sender.backgroundColor;
#warning Might need to change this one:
    self.strokeWidthIcon.backgroundColor = sender.backgroundColor;
    self.alpha1.backgroundColor = sender.backgroundColor;
    self.alpha2.backgroundColor = sender.backgroundColor;
    self.blend1.backgroundColor = sender.backgroundColor;
    self.blend2.backgroundColor = sender.backgroundColor;
    
}

- (IBAction)changeStrokeWidth:(UISlider *)sender {
    
    selectedStrokeWidth = sender.value;
    
}

- (IBAction)changeAlpha:(UISlider *)sender {
    
    shapeAlpha = sender.value;
    
    // change alpha of icon
    self.alpha1.alpha = sender.value;
    self.alpha2.alpha = sender.value;
    
}


- (void)choice:(NSString *)choice forGroup:(NSString *)group {
    
    if ([group isEqualToString:@"BlendMode"]) {
        
        selectedBlendMode = choice;
        [self.blendModeButton setTitle:choice forState:UIControlStateNormal];
        
    }
    
    if ([group isEqualToString:@"ShapeType"]) {
        
        selectedShapeType = choice;
        [self.shapeTypeButton setTitle:choice forState:UIControlStateNormal];
        
        // change icon
        
        if ([selectedShapeType isEqualToString:@"Scribble"]) {
            self.selectedShapeImage.image = [UIImage imageNamed: @"shape_scribble"];
        } else if ([selectedShapeType isEqualToString:@"Line"]) {
            self.selectedShapeImage.image = [UIImage imageNamed: @"shape_line"];
        } else if ([selectedShapeType isEqualToString:@"Ellipse"]) {
            self.selectedShapeImage.image = [UIImage imageNamed: @"shape_ellipse"];
        } else if ([selectedShapeType isEqualToString:@"Triangle"]) {
            self.selectedShapeImage.image = [UIImage imageNamed: @"shape_triangle"];
        } else if ([selectedShapeType isEqualToString:@"Rectangle"]) {
            self.selectedShapeImage.image = [UIImage imageNamed: @"shape_rectangle"];
        }
        
        [self.view setNeedsDisplay];
        
    }
    
}

- (IBAction)changeBlendMode:(id)sender {
    
    ChoiceViewController *choiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"choiceVC"];
    
    choiceVC.delegate = self;
    choiceVC.group = @"BlendMode";
    choiceVC.choices = @[
                         @"Normal",
                         @"Screen",
                         @"Multiply",
                         @"Overlay",
                         @"Clear"
                         ];
    
    [self presentViewController:choiceVC animated:NO completion:nil];
    
#warning This is where the blend mode of the icon should be set
    
}

- (IBAction)changeShapeType:(UIButton *)sender {
    
    ChoiceViewController *choiceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"choiceVC"];
    
    choiceVC.delegate = self;
    choiceVC.group = @"ShapeType";
    choiceVC.choices = @[
                              @"Scribble",
                              @"Line",
                              @"Ellipse",
                              @"Triangle",
                              @"Rectangle"
                              ];
    
    [self presentViewController:choiceVC animated:NO completion:nil];
    
}

- (IBAction)showHideDrawer:(UIButton *)sender {
    
    self.drawerLeftConstraint.constant = (self.drawerLeftConstraint.constant == -16) ? -266 : -16;
    
    if (counter % 2 == 0) {
        sender.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 180 );
    } else {
        sender.transform = CGAffineTransformMakeRotation(0);
    }
    counter++;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = touches.allObjects.firstObject;
    
    CGPoint location = [touch locationInView:self.view];
    
    
    currentScribble = [@{
                         
                         @"type":selectedShapeType,
                         @"blend":selectedBlendMode,
                         @"fillColor":selectedFillColor,
                         @"strokeColor":selectedStrokeColor,
                         @"strokeWidth":@(selectedStrokeWidth),
                         @"alpha":@(shapeAlpha),
                         @"points":[@[[NSValue valueWithCGPoint:location]] mutableCopy]
                         
                         } mutableCopy];
    
    ScribbleView * sView = (ScribbleView *)self.view;
    [sView.scribbles addObject:currentScribble];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = touches.allObjects.firstObject;
    
    CGPoint location = [touch locationInView:self.view];
    
    if ([selectedShapeType isEqualToString:@"Scribble"]) {
        [currentScribble[@"points"] addObject:[NSValue valueWithCGPoint:location]];
    } else {
        currentScribble[@"points"][1] = [NSValue valueWithCGPoint:location];
    }
  
    
    [self.view setNeedsDisplay];
}

- (IBAction)reset:(id)sender {
    
    ScribbleView *sView = (ScribbleView *) self.view;
    [sView.scribbles removeAllObjects];
    [sView setNeedsDisplay];
    
}

- (IBAction)undo:(id)sender {
    
    ScribbleView *sView = (ScribbleView *) self.view;
    [sView.scribbles removeLastObject];
    [sView setNeedsDisplay];
    
}


@end
