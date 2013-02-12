//
//  SEBViewController.m
//  Calculator
//
//  Created by Sebs on 1/17/13.
//  Copyright (c) 2013 Sebs. All rights reserved.
//

#import "SEBViewController.h"
#import "SEBCalculatorModel.h"

@interface SEBViewController ()

@property (weak, nonatomic) IBOutlet UITextField *screen;
@property (weak, nonatomic) IBOutlet UILabel *option;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;

@end

@implementation SEBViewController

// Initialize some variables
Boolean *option = NO;
SEBCalculatorModel *model;
NSString *xValue = @"";


- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [[SEBCalculatorModel alloc] init];
    [self updateTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// OPERAND BUTTONS FUNCTIONALITY
- (IBAction)appendOperand:(UIButton *)sender
{
    //Get last character
    NSString *last = [self getLastChar:self.screen.text];

    if (![last isEqualToString:@"π"] && ![last isEqualToString:@"e"]) {
        if ([self.screen.text isEqualToString:@"0"]) {
            self.screen.text = sender.currentTitle;
        } else {
            self.screen.text = [self.screen.text stringByAppendingString:sender.currentTitle];
        }
    }

}


// OPERATOR BUTTONS FUNCTIONALITY
- (IBAction)appendOperator:(UIButton *)sender
{
    // Determine operator to be added
    NSString *operator = sender.currentTitle;
    if (option) {
        if ([sender.currentTitle isEqualToString:@"*"]) {
            operator = @"^";
        }
        [self toggleOption];
    } 
    
    // Get the last character of the screen
    NSString *last = [self getLastChar:self.screen.text];

    // Create a number formatter
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    // If last character is numeric, add operator
    if ([sender.currentTitle isEqualToString:@"."]) {
        if ([f numberFromString:last] != Nil) {
            self.screen.text = [self.screen.text stringByAppendingString:operator]; 
        }
    } else if ([sender.currentTitle isEqualToString:@"-"]) {
        if (![last isEqualToString:@"-"]) {
            self.screen.text = [self.screen.text stringByAppendingString:operator];
        }
    } else {
        if ([f numberFromString:last] != Nil || [last isEqualToString:@"π"] || [last isEqualToString:@"e"] || [last isEqualToString:@"X"]) {
            self.screen.text = [self.screen.text stringByAppendingString:operator];
        }
    }
}


// CONSTANT BUTTON (PI AND E) and Variable X FUNCTIONALITY
- (IBAction)appendConstant:(UIButton *)sender
{
    // Determine operator to be added
    NSString *operator;
    if ([sender.currentTitle isEqualToString:@"π"])
    {
        if (option) {
            operator = @"e";
            [self toggleOption];
        } else {
            operator = @"π";
        }
    } else {
        if (xValue != Nil && ![xValue isEqualToString:@""]) {
            operator = @"X";
        } else {
            return;
        }
    }

    
    // Get the last character of the screen
    NSString *last = [self getLastChar:self.screen.text];
    
    // Create a number formatter
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    // If last character is non-numeric, and not another constant add char
    if (![last isEqualToString:@"e"] && ![last isEqualToString:@"X"] && ![last isEqualToString:@"π"] && [f numberFromString:last] == Nil)
    {
        self.screen.text = [self.screen.text stringByAppendingString:operator];
    }

}

- (IBAction)STR:(UIButton *)sender {
    NSString *last = [self getLastChar:self.screen.text];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];

    if ([f numberFromString:last] != nil || [last isEqualToString:@"π"] || [last isEqualToString:@"e"] || [last isEqualToString:@"X"]) {

        xValue = [model parse:[self.screen.text stringByReplacingOccurrencesOfString:@"X" withString:xValue]];
        self.screen.text = @"X";
    }
}


// INVERT BUTTON FUNCTIONALITY
// only works when no operators are on the screen
- (IBAction)invertNumber:(UIButton *)sender {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];

    if ([f numberFromString:self.screen.text] != Nil)
    {
        if ([[self.screen.text substringToIndex:1] isEqualToString:@"-"])
        {
            self.screen.text = [self.screen.text substringFromIndex:1];
        }
        else
        {
            self.screen.text = [NSString stringWithFormat:@"-%@", self.screen.text];
        }
    }
}


// CLEAR BUTTON FUNCTIONALITY
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


// ALT BUTTON FUNCTIONALITY
- (IBAction)option:(UIButton *)sender {
    [self toggleOption];
}

// ENTER BUTTON FUNCTIONALITY
- (IBAction)compute:(UIButton *)sender {
    NSString *last = [self getLastChar:self.screen.text];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];

    if ([f numberFromString:last] != nil || [last isEqualToString:@"π"] || [last isEqualToString:@"e"] || [last isEqualToString:@"X"]) {

        self.screen.text = [model parse:[self.screen.text stringByReplacingOccurrencesOfString:@"X" withString:xValue]];
    } 
}

// HELPER METHODS

- (IBAction)clickDown:(UIButton *)sender
{
    //clear error
    if ([self.screen.text isEqualToString:@"Error"]) {
        self.screen.text = @"";
    }
    [sender setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3]];
}

- (IBAction)clickUp:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}

- (NSString *)getLastChar:(NSString *)screenText
{
    NSString *last = @"";
    if (self.screen.text != Nil && ![self.screen.text isEqualToString:@""])
    {
        last = [self.screen.text substringFromIndex: [self.screen.text length] - 1];
    }
    return last;
    
}

- (void)toggleOption
{
    option = !option;
    if (option) {
        self.option.text = @"ALT";
    } else {
        self.option.text = @"";
    }
}

- (void)updateTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm"];
    self.timeDisplay.text = [dateFormat stringFromDate:[NSDate date]];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}
@end
