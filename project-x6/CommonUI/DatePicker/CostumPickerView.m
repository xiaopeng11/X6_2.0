//
//  CostumPickerView.m
//  project-x6
//
//  Created by Apple on 2016/11/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CostumPickerView.h"
// Identifiers of components
#define FIRST ( 0 )

// Identifies for component views
#define LABEL_TAG 46

@interface CostumPickerView ()

@property(nonatomic,assign)NSInteger rowheight;

@property(nonatomic,strong)NSIndexPath *nowIndexPath;
@property(nonatomic,strong)NSArray *firsts;

@property(nonatomic,copy)NSString *first;


@end
@implementation CostumPickerView

- (instancetype)initWithFrame:(CGRect)frame
                         Date:(NSArray *)data
                     IndexStr:(NSString *)indexStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rowheight = 44;
        
        //年月的集合以及今天的年月
        self.firsts = data;
        
        self.first = indexStr;
        
        self.nowIndexPath = [self nowPathWithfirstStr:self.first];

        
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

    return first;
}

//默认选择位置
- (void)selectDay
{
    
    [self selectRow: self.nowIndexPath.row
        inComponent: FIRST
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
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self bigRowfirstCount];
}





- (NSIndexPath *)nowPathWithfirstStr:(NSString *)firstStr
{
    CGFloat row = 0.f;
    
    //set table on the middle
    for(NSString *first in self.firsts)
    {
        if([first isEqualToString:firstStr])
        {
            row = [self.firsts indexOfObject:first];
            row = row + [self bigRowfirstCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:1];
}


#pragma mark - Util

- (NSInteger)bigRowfirstCount
{
    return self.firsts.count * 100;
}


- (CGFloat)componentWidth
{
    return self.bounds.size.width;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger monthCount = self.firsts.count;
    return [self.firsts objectAtIndex:(row % monthCount)];
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
