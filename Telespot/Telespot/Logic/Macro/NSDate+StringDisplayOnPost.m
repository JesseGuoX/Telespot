//
//  NSDate+StringDisplayOnPost.m
//  Wheex
//
//  Created by JG on 3/1/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#import "NSDate+StringDisplayOnPost.h"

@implementation NSDate (StringDisplayOnPost)

-(NSString *)DateStringDisplayOnPost
{
    NSString * dateString = [[NSString alloc] init];
    
    NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *currentCom = [calendar components:(NSCalendarUnitYear | NSCalendarUnitDay) fromDate:nowDate];
    NSDateComponents * postCom = [calendar components:(NSCalendarUnitYear | NSCalendarUnitDay) fromDate:self];
    
    if(currentCom.year == postCom.year)//如果是今年不显示年号
    {
        if(currentCom.day == postCom.day)//如果是今天则不显示日期
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            dateString = [formatter stringFromDate:self];
        }
        else
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            dateString = [formatter stringFromDate:self];
        }
    }
    else{//非今年显示年月日
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateString = [formatter stringFromDate:self];
    }
    
    return dateString;
}

+ (NSString *)NowDateString
{
    NSString * dateString = [[NSString alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];

    
    return dateString;
}
@end
