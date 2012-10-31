//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kent Tam on 10/28/12.
//  Copyright (c) 2012 Kent Tam. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredDecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize history;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDecimal;
@synthesize brain = _brain;

-(CalculatorBrain *)brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if ([digit isEqualToString:@"."]){
        if(self.userHasEnteredDecimal){
            return;
        }
        else{
            self.userHasEnteredDecimal = YES;
        }
    }
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [self.history.text stringByAppendingString: [NSString stringWithFormat:@" %@", operation]];
    self.userHasEnteredDecimal = NO;
}
- (IBAction)enterPressed {

    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = [self.history.text stringByAppendingString: [NSString stringWithFormat:@" %@",self.display.text]];
    self.userHasEnteredDecimal = NO;
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.history.text = @"";
    self.userHasEnteredDecimal = NO;
    
}


@end
