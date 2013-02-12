//
//  SEBCalculatorModel.m
//  Calculator
//
//  Created by Sebs on 2/11/13.
//  Copyright (c) 2013 Sebs. All rights reserved.
//

#import "SEBCalculatorModel.h"

@implementation SEBCalculatorModel



-(NSString *)parse:(NSString *)calcScreen
{
    NSString *finalResult;

    finalResult = [calcScreen stringByReplacingOccurrencesOfString:@"π" withString:@"3.14159265"];
    finalResult = [finalResult stringByReplacingOccurrencesOfString:@"e" withString:@"2.718281828"];

    finalResult = [self compute:finalResult];

    return finalResult;
}

-(NSString *)compute:(NSString *)calcScreen
{
    // Initialize data structures and necessary objects
    NSMutableArray *operators = [[NSMutableArray alloc] init];
    NSMutableArray *operands = [[NSMutableArray alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    int beginning = 0;

    // Place characters into data structures
    for (int i = 0; i<[calcScreen length]; i++)
    {
        NSString *current = [calcScreen substringWithRange:NSMakeRange(i,1)];
        if (([f numberFromString:current] == Nil && ![current isEqualToString:@"."] && ![current isEqualToString:@"-"]) || ([current isEqualToString:@"-"] && i != 0 && [f numberFromString:[calcScreen substringWithRange:NSMakeRange(i-1,1)]]))
        {
            [operands addObject:[f numberFromString:[calcScreen substringWithRange:NSMakeRange(beginning, i-beginning)]]];
            [operators addObject:current];
            beginning = i+1;
        }
        if (i+1 == [calcScreen length]) {
            [operands addObject:[f numberFromString:[calcScreen substringFromIndex:beginning]]];
        }
    }

    double result = 0;

    // Exit if there is nothing to compute
    if ([operators count] == 0) {
        return calcScreen;
    }

    Boolean containsExponents = YES;
    while (containsExponents)
    {
        containsExponents = NO;
        for (int j = 0; j<[operators count]; j++)
        {
            if ([[operators objectAtIndex:j] isEqualToString:@"^"])
            {
                result = pow([[operands objectAtIndex:j] doubleValue], [[operands objectAtIndex:j+1] doubleValue]);
                containsExponents = YES;
                [operands removeObjectAtIndex:j+1];
                [operands replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:result]];
                [operators removeObjectAtIndex:j];
                break;
            }
        }
    }

    Boolean containsMulDiv = YES;
    while (containsMulDiv)
    {
        containsMulDiv = NO;
        for (int j = 0; j<[operators count]; j++)
        {
            if ([[operators objectAtIndex:j] isEqualToString:@"*"])
            {
                result = [[operands objectAtIndex:j] doubleValue] * [[operands objectAtIndex:j+1] doubleValue];
                containsMulDiv = YES;
            }
            else if ([[operators objectAtIndex:j] isEqualToString:@"/"])
            {
                if ([[operands objectAtIndex:j+1] doubleValue] != 0) {
                    result = [[operands objectAtIndex:j] doubleValue] / [[operands objectAtIndex:j+1] doubleValue];
                    containsMulDiv = YES;
                } else {
                    return @"Error";
                }
            }

            if (containsMulDiv) {
                [operands removeObjectAtIndex:j+1];
                [operands replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:result]];
                [operators removeObjectAtIndex:j];
                break;
            }

        }
    }

    Boolean containsAddSub = YES;
    while (containsAddSub)
    {
        containsAddSub = NO;
        for (int j = 0; j<[operators count]; j++)
        {
            if ([[operators objectAtIndex:j] isEqualToString:@"+"])
            {
                result = [[operands objectAtIndex:j] doubleValue] + [[operands objectAtIndex:j+1] doubleValue];
                containsAddSub = YES;
            }
            else if ([[operators objectAtIndex:j] isEqualToString:@"-"])
            {
                result = [[operands objectAtIndex:j] doubleValue] - [[operands objectAtIndex:j+1] doubleValue];
                containsAddSub = YES;
            }

            if (containsAddSub) {
                [operands removeObjectAtIndex:j+1];
                [operands replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:result]];
                [operators removeObjectAtIndex:j];
                break;
            }

        }
    }

    return [NSString stringWithFormat:@"%g", result];
}


@end