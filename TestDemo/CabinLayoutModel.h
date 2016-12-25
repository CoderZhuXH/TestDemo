//
//  CabinLayoutModel.h
//  TestDemo
//
//  Created by zhuxiaohui on 2016/12/25.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , CabinType) {
    
    CabinTypeOne = 1,
    CabinTypeTwo = 2,
    CabinTypeThree = 3
};

@interface CabinLayoutModel : NSObject

@property(nonatomic,assign)CabinType type;//机舱类型
@property(nonatomic,assign ,readonly)NSInteger row;//行数
@property(nonatomic,assign ,readonly)NSInteger column;//列数
@property(nonatomic,assign ,readonly)NSInteger total;//位子总数

-(instancetype)initWithCabinType:(CabinType)type;

@end


