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
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize history;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDecimal;
@synthesize brain = _brain;
@synthesize dictionary = _dictionary;

-(NSDictionary *)dictionary{
    if(!_dictionary) _dictionary = [[NSDictionary alloc] init];
    return _dictionary;
}

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
    self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    self.userHasEnteredDecimal = NO;
}
- (IBAction)enterPressed {
    if(!isnumber([self.display.text characterAtIndex:0])){
        [self.brain pushVariable:self.display.text];
    }
    else{
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
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

- (IBAction)testPressed:(id)sender {
    NSString *name = [sender currentTitle];
    if([name isEqualToString:@"Test 1"]){
        self.dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"3", @"a", @"4", @"b", nil];
        self.display.text = [NSString stringWithFormat:@"%g",[[self.brain class]runProgram:self.brain.program
                  usingVariableValues:self.dictionary]];
        NSMutableString *tempString = [NSMutableString stringWithCapacity:30];
        [tempString setString:@""];
        NSUInteger count = [self.brain.program count];
        for (NSUInteger i = 0; i < count; i++) { //for each item
            id temp = [self.dictionary objectForKey:[self.brain.program objectAtIndex: i]];
            if(temp){  //try to get the equivalent from the dictionary
                [tempString appendString:[self.brain.program objectAtIndex:i]];
                [tempString appendString:@"= "];
                [tempString appendString:temp];
                [tempString appendString:@"  "];
            }
        }
        self.variables.text = tempString;
    }
}
- (IBAction)undoPressed:(id)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        if([self.display.text length] > 1){
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }
        else{
            self.display.text = @"";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
    else{
        [self.brain clearTopOfStack];
        self.history.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    }
}

@end
