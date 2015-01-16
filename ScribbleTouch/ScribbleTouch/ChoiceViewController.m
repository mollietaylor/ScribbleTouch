//
//  ChoiceViewController.m
//  ScribbleTouch
//
//  Created by Mollie on 1/15/15.
//  Copyright (c) 2015 Jo Albright. All rights reserved.
//

#import "ChoiceViewController.h"

@interface ChoiceViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.backgroundView.alpha = 0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.backgroundView.alpha = 0.8;
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.choices.count;

}

- (IBAction)dismiss:(id)sender {
    
    NSString *choice = self.choices[[self.pickerView selectedRowInComponent:0]];
    
    [self.delegate choice:(NSString *)choice forGroup:self.group];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
    

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.choices[row];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
