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

-(void)clearTopOfStack{
    [self.programStack removeLastObject];
}


-(void)setprogramStack:(NSMutableArray *) anArray{
    _programStack = anArray;
}

-(void)pushOperand:(double)operand{
    [[self programStack] addObject:[NSNumber numberWithDouble:operand]];
}

-(void)pushVariable:(NSString *)operand{
    [[self programStack] addObject:operand];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    //NSString *result = [[self class] descriptionOfProgram:self.program];
    return [[self class] runProgram:self.program];
}

+(NSString *)descriptionOfProgram:(id)program{
    NSMutableArray *stack = [program mutableCopy];
    NSMutableString *result = [NSMutableString stringWithCapacity:50];
    Boolean firstTime = YES;
    while ([stack count] != 0){
        if(!firstTime){
            NSMutableString *temp = [NSMutableString stringWithCapacity:50];
            [temp setString:[self descriptionOfTopOfStack:stack]];
            [temp appendString:@", "];
            [temp appendString:result];
            [result setString:temp];
        }
        else{
            [result appendString:[self descriptionOfTopOfStack:stack]];
        }
        firstTime = NO;
    }
    return result;
}


+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack{
    NSMutableString *result = [NSMutableString stringWithCapacity:50];
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        [result appendString:[topOfStack stringValue]];
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        NSSet *twoOperandOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
        NSSet *oneOperandOperations = [NSSet setWithObjects:@"sqrt", @"sin", @"cos", nil];
        NSSet *zeroOperandOperations = [NSSet setWithObject:@"π"];
        if([twoOperandOperations containsObject:operation]){
            NSString *temp = [self descriptionOfTopOfStack:stack];
            NSString *newItem = [self descriptionOfTopOfStack:stack];
            if([[self class] stringIsNumeric:newItem] && ([topOfStack isEqual:@"*"] || [topOfStack isEqual:@"/"])){
                [result appendString:@"("];
                [result appendString:newItem];
                [result appendString:@")"];
            }
            else{
                [result appendString:newItem];
            }
            [result appendString:topOfStack];
            if([[self class] stringIsNumeric:temp] && ([topOfStack isEqual:@"*"] || [topOfStack isEqual:@"/"])){
                [result appendString:@"("];
                [result appendString:temp];
                [result appendString:@")"];
            }
            else{
                [result appendString:temp];
            }
        }else if([oneOperandOperations containsObject:operation]){
            [result appendString:topOfStack];
            [result appendString:@"("];
            [result appendString:[self descriptionOfTopOfStack:stack]];
            [result appendString:@")"];
        }else if([zeroOperandOperations containsObject:operation]){
            [result appendString:topOfStack];
        }
        else{
            [result appendString:topOfStack]; //variables
        }
    }
    return result;

    
}

+(BOOL)stringIsNumeric:(NSString *)str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
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
        }else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"sqrt"]){
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

+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *stack = [program mutableCopy];
    NSUInteger count = [stack count];
    
    for (NSUInteger i = 0; i < count; i++) { //for each item
        id temp = [variableValues objectForKey:[stack objectAtIndex: i]];
        if(temp){  //try to get the equivalent from the dictionary
            [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:[temp doubleValue]]];
        }
    }
    return [self popOperandOffProgramStack:stack];
   
}


@end
