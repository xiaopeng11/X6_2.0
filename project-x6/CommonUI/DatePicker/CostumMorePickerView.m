//
//  CostumMorePickerView.m
//  XPDatePicker
//
//  Created by Apple on 2016/11/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CostumMorePickerView.h"
// Identifiers of components
#define FIRST ( 0 )
#define SECOND ( 1 )


// Identifies for component views
#define LABEL_TAG 45

@interface CostumMorePickerView ()

@property(nonatomic,assign)NSInteger rowheight;

@property(nonatomic,strong)NSIndexPath *nowIndexPath;
@property(nonatomic,strong)NSArray *firsts;
@property(nonatomic,strong)NSArray *seconds;

@property(nonatomic,copy)NSString *first;
@property(nonatomic,copy)NSString *second;

@property(nonatomic,copy)NSString *key;

@end


@implementation CostumMorePickerView

const NSInteger bigRowCount = 100;
const NSInteger numberOfComponents = 2;

- (instancetype)initWithFrame:(CGRect)frame
                         Date:(NSArray *)data
                     IndexStr:(NSString *)indexStr
                          Key:(NSString *)key
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rowheight = 44;
        
        //年月的集合以及今天的年月
        self.firsts = data[0];
        self.seconds = data[1];
        
        self.key = key;
        NSArray *keys = [indexStr componentsSeparatedByString:self.key];
        self.first = keys[0];
        self.second = keys[1];
        
        self.nowIndexPath = [self nowPathWithfirstStr:self.first SecondStr:self.second];
        
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - Open methods
//返回的数据
- (NSString *)dateStr
{
    NSInteger firstCount = self.firsts.count;
    NSString *first = [self.firsts objectAtIndex:([self selectedRowInComponent:FIRST] % firstCount)];
    
    NSInteger secondCount = self.seconds.count;
    NSString *second = [self.seconds objectAtIndex:([self selectedRowInComponent:SECOND] % secondCount)];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@%@%@",first,self.key,second];
    return dateStr;
}

//默认选择位置
- (void)selectDay
{
    
    [self selectRow: self.nowIndexPath.section
        inComponent: FIRST
           animated: NO];
    
    [self selectRow: self.nowIndexPath.row
        inComponent: SECOND
           animated: NO];
}

#pragma mark - UIPickerViewDelegate
//宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

- (UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == FIRST)
    {
        NSInteger firstCount = self.firsts.count;
        NSString *firstName = [self.firsts objectAtIndex:(row % firstCount)];
        NSString *currentfirstName = self.first;
        if([firstName isEqualToString:currentfirstName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger secondCount = self.seconds.count;
        NSString *secondName = [self.seconds objectAtIndex:(row % secondCount)];
        NSString *currenrsecondName  = self.second;
        if([secondName isEqualToString:currenrsecondName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowheight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == FIRST)
    {
        return [self bigRowfirstCount];
    }
    return [self bigRowsecondCount];
}





- (NSIndexPath *)nowPathWithfirstStr:(NSString *)firstStr SecondStr:(NSString *)secondStr
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    //set table on the middle
    for(NSString *first in self.firsts)
    {
        if([first isEqualToString:firstStr])
        {
            section = [self.firsts indexOfObject:first];
            section = section + [self bigRowfirstCount] / 2;
            break;
        }
    }
    
    for(NSString *cellYear in self.seconds)
    {
        if([cellYear isEqualToString:secondStr])
        {
            row = [self.seconds indexOfObject:cellYear];
            row = row + [self bigRowsecondCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}


#pragma mark - Util

- (NSInteger)bigRowfirstCount
{
    return self.firsts.count  * bigRowCount;
}

- (NSInteger)bigRowsecondCount
{
    return self.seconds.count  * bigRowCount;
}

- (CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == FIRST)
    {
        NSInteger monthCount = self.firsts.count;
        return [self.firsts objectAtIndex:(row % monthCount)];
    }
    NSInteger yearCount = self.seconds.count;
    return [self.seconds objectAtIndex:(row % yearCount)];
}

- (UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowheight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}



@end
