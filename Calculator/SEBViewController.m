//
//  SEBViewController.m
//  Calculator
//
//  Created by Sebs on 1/17/13.
//  Copyright (c) 2013 Sebs. All rights reserved.
//

#import "SEBViewController.h"

@interface SEBViewController ()

@property (weak, nonatomic) IBOutlet UITextField *screen;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;
@property (weak, nonatomic) IBOutlet UILabel *option;

@end

@implementation SEBViewController

// Initialize some variables
Boolean *option = NO;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)appendOperand:(UIButton *)sender
{
    self.screen.text = [self.screen.text stringByAppendingString:sender.currentTitle];
//    [self clickUp:sender];
}

- (IBAction)appendOperator:(UIButton *)sender
{
    // Determine operator to be added
    NSString *operator;
    if (option) {
        if ([sender.currentTitle isEqualToString:@"."]) {
            operator = @"^";
            [self toggleOption];
        }
        else if ([sender.currentTitle isEqualToString:@"pi"]) {
            operator = @"e";
            [self toggleOption];
        }
    } else {
        operator = sender.currentTitle;
    }
    
    // Get the last character of the screen
    NSString *last = @"";
    if (self.screen.text != Nil && ![self.screen.text isEqualToString:@""]) {
        last = [self.screen.text substringFromIndex: [self.screen.text length] - 1];
    }

    // Create a number formatter
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    // If last character is numeric, add operator
    if ([f numberFromString:last] != Nil || [last isEqualToString:@"pi"] || [last isEqualToString:@"e"]) {
        self.screen.text = [self.screen.text stringByAppendingString:operator];
    }
}

- (IBAction)appendConstant:(UIButton *)sender
{
    // Determine operator to be added
    NSString *operator;
    if (option) {
        operator = @"e";
    } else {
        operator = @"π";
    }
    
    // Get the last character of the screen
    NSString *last = @"";
    if (self.screen.text != Nil && ![self.screen.text isEqualToString:@""]) {
        last = [self.screen.text substringFromIndex: [self.screen.text length] - 1];
    }
    
    // Create a number formatter
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    // If last character is numeric, add operator
    if (![last isEqualToString:operator] && [f numberFromString:last] == Nil) {
        self.screen.text = [self.screen.text stringByAppendingString:operator];
    }
}

- (IBAction)clear:(UIButton *)sender
{
    // If ALT pressed clear entire screen
    if (option) {
        self.screen.text = @"";
        [self toggleOption];
    } else {
        // Otherwise clear last character
        self.screen.text = [self.screen.text substringToIndex:[self.screen.text length] - 1];
    }
}

- (IBAction)option:(UIButton *)sender {
    [self toggleOption];
}

- (void) toggleOption {
    option = !option;
    if (option) {
        self.option.text = @"ALT";
    } else {
        self.option.text = @"";
    }
}

- (IBAction)clickDown:(UIButton *)sender
{
    sender.alpha = 0.8;
}

- (IBAction)clickUp:(UIButton *)sender
{
    sender.alpha = 0.0;
}

@end
