//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kent Tam on 10/28/12.
//  Copyright (c) 2012 Kent Tam. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray * programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(NSMutableArray *)programStack{
    if(_programStack == nil){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(id)program{
    return [self.programStack copy];
}

+(NSString *)descriptionOfProgram:(id)program{
    return @" ";
}

-(void)setprogramStack:(NSMutableArray *) anArray{
    _programStack = anArray;
}

-(void)pushOperand:(double)operand{
    [[self programStack] addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+(double)popOperandOffProgramStack:(NSMutableArray *)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        }else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        }else if([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        }else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }else if([operation isEqualToString:@"Sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"Cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"Sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"π"]){
            result = M_PI;
        }
    }

    return result;
}

-(void)clear{
    [self.programStack removeAllObjects];
}

+(double)runProgram:(id)program{
    //return [[[self class] popOperandOffProgramStack:[[self class]programStack]];
    NSMutableArray *stack= [program mutableCopy];
    
    return [self popOperandOffProgramStack:stack];
}

@end
