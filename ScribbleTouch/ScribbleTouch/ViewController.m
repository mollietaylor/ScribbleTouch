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

@interface ViewController () <ChoiceViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *blendModeButton;
@property (weak, nonatomic) IBOutlet UIButton *shapeTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;

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
    
    selectedFillColor = [UIColor clearColor];
    selectedStrokeColor = [UIColor blackColor];
    selectedStrokeWidth = 10;
    selectedBlendMode = @"Normal";
    selectedShapeType = @"Scribble";
    shapeAlpha = 1;
    counter = 0;

}

- (IBAction)changeStrokeColor:(UIButton *)sender {
    
    selectedStrokeColor = sender.backgroundColor;
    
}

- (IBAction)changeFillColor:(UIButton *)sender {
    
    selectedFillColor = sender.backgroundColor;
    
}

- (IBAction)changeStrokeWidth:(UISlider *)sender {
    
    selectedStrokeWidth = sender.value;
    
}

- (IBAction)changeAlpha:(UISlider *)sender {
    
    shapeAlpha = sender.value;
    
}


- (void)choice:(NSString *)choice forGroup:(NSString *)group {
    
    if ([group isEqualToString:@"BlendMode"]) {
        
        selectedBlendMode = choice;
        [self.blendModeButton setTitle:choice forState:UIControlStateNormal];
        
    }
    
    if ([group isEqualToString:@"ShapeType"]) {
        
        selectedShapeType = choice;
        [self.shapeTypeButton setTitle:choice forState:UIControlStateNormal];
        
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
    
}

- (IBAction)changeShapeType:(id)sender {
    
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

//- (void) drawerPress:(UIButton*)button {
//
//    button.transform = CGAffineTransformMakeRotation(3.14);
//
//}

- (IBAction)showHideDrawer:(UIButton *)sender {
    
    self.drawerLeftConstraint.constant = (self.drawerLeftConstraint.constant == -16) ? -266 : -16;
    
//    [sender addTarget:self action:@selector(drawerPress:) forControlEvents:UIControlEventTouchUpInside];
    
//    [UIView beginAnimations:@"ScaleButton" context:NULL];
//    [UIView setAnimationDuration: 0.5f];
//    sender.transform = CGAffineTransformMakeRotation(3.14);
//    [UIView commitAnimations];
    
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

@end
