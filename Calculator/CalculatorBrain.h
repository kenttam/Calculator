//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Kent Tam on 10/28/12.
//  Copyright (c) 2012 Kent Tam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void) pushOperand:(double)operand;
-(void) pushVariable:(NSString *)operand;
-(double) performOperation:(NSString *)operation;
-(void) clear;

@property (nonatomic, readonly) id program;

+(NSString *)descriptionOfProgram:(id)program;
+(double)runProgram:(id)program;
+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;


@end
