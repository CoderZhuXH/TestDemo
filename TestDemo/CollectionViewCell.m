//
//  CollectionViewCell.m
//  TestDemo
//
//  Created by zhuxiaohui on 2016/12/25.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.layer.borderWidth = 1.0;
    // Initialization code
}

@end
