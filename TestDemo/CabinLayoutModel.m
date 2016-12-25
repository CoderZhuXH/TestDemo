//
//  CabinLayoutModel.m
//  TestDemo
//
//  Created by zhuxiaohui on 2016/12/25.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import "CabinLayoutModel.h"

@implementation CabinLayoutModel

- (instancetype)initWithCabinType:(CabinType)type

{
    self = [super init];
    if (self) {
       
        self.type = type;
    }
    return self;
}

-(void)setType:(CabinType)type
{
    _type = type;
    switch (type) {
        case CabinTypeOne:
            
            _column = 4;
            
            break;
        case CabinTypeTwo:
            
            _column = 6;
            
            break;
        case CabinTypeThree:
            
            _column = 9;
            
            break;
            
        default:
            break;
    }
    
    _row = 9;
    _total = _row * _column;
}
@end
