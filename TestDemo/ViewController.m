//
//  ViewController.m
//  TestDemo
//
//  Created by zhuxiaohui on 2016/12/23.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import "ViewController.h"
#import "CabinLayoutModel.h"
#import "CollectionViewCell.h"

#define MWIDTH [UIScreen mainScreen].bounds.size.width
#define MHEIGHT [UIScreen mainScreen].bounds.size.height

static NSString *const cellId = @"CollectionViewCell";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property(nonatomic,strong) CabinLayoutModel *model;
@property(nonatomic,assign) NSInteger typeIndex;
@property(nonatomic,strong) NSArray *firstSeatArray;
@property(nonatomic,assign) NSInteger passengerNum;//乘客数
@property(nonatomic,assign) NSInteger madmanIndex;//瞎子位置

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _typeIndex = 1;
    
    [_collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    
    [self refreshUI];
    
}
#pragma mark - UI
-(void)refreshUI{
    
    //1.按顺序切换机舱
    _typeIndex +=1;
    if(_typeIndex==4) _typeIndex = 1;
    self.model.type = (CabinType)_typeIndex;
    
    //2.生成随机乘客数(25人以上)
    _passengerNum = [self getRandomNumberForm:25 to:self.model.total-1];
    
    //3.生成随机疯子位置
    _madmanIndex = arc4random()%self.model.total+1;
    
    self.titleLab.text = [NSString stringWithFormat:@"机舱-%ld,乘客数-%ld,疯子位置-%ld",_typeIndex,_passengerNum,_madmanIndex];
    
    NSArray * firstSeats = [self firstSeats];
    _firstSeatArray = [firstSeats subarrayWithRange:NSMakeRange(0, _passengerNum)];
    
    if([_firstSeatArray containsObject:@(_madmanIndex)])
    {
        _firstSeatArray = [firstSeats subarrayWithRange:NSMakeRange(0, _passengerNum+1)];
    }
    
    [self.collectionView reloadData];
    
    [self setupAisle];
    
}

-(void)setupAisle
{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj isKindOfClass:[UILabel class]]) [obj removeFromSuperview];
        
    }];
    
    CGFloat aisleWidth = 10;
    CGFloat height = MWIDTH/(float)self.model.column *self.model.row;
    if(self.model.type == CabinTypeOne)
    {
        UILabel *line = [self createLine];
        line.frame = CGRectMake(MWIDTH/2-aisleWidth/2.0, 64, aisleWidth, MHEIGHT - 64);
        [self.view addSubview:line];
    }
    else
    {
        for(int i=0;i<2;i++)
        {
            UILabel *line = [self createLine];
            line.frame = CGRectMake((MWIDTH/3-aisleWidth/2.0)*(i+1), 64, aisleWidth,height);
            [self.view addSubview:line];
        }
        
    }
}
-(UILabel *)createLine
{
    UILabel *line = [UILabel new];
    line.font = [UIFont systemFontOfSize:10];
    line.numberOfLines = 0;
    line.text = @"过道";
    line.backgroundColor = [UIColor yellowColor];
    return line;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.total;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSInteger index = indexPath.item +1;//座位号
    cell.titleLab.text  = [NSString stringWithFormat:@"%ld",index];
    if([_firstSeatArray containsObject:@(index)])
    {
        cell.backgroundColor = [UIColor greenColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if(index==_madmanIndex)
    {
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = MWIDTH/(float)self.model.column;
    return CGSizeMake(size, size);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (IBAction)randomAction:(id)sender {
    
    [self refreshUI];
}

#pragma mark - other

-(int)getRandomNumberForm:(NSInteger)from to:(NSInteger)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
/**
 *  优先座位数组
 */
-(NSArray *)firstSeats
{
    NSArray * aisleColumn;
    if(self.model.type == CabinTypeTwo)//机舱2
    {
        aisleColumn =@[@(2),@(3),@(4),@(5)];
        
    }
    else if (self.model.type==CabinTypeThree)//机舱3
    {
        aisleColumn =@[@(3),@(4),@(6),@(7)];
    }
    else//机舱1
    {
        aisleColumn =@[@(2),@(3)];
    }
    NSArray *array =  [self firstSeatWithAisleColumn:aisleColumn];
    return array;
}

/**
 根据靠过道列数获取优先座位数组
 */
-(NSArray *)firstSeatWithAisleColumn:(NSArray *)aisleColumn
{
    //过道
    NSMutableArray *array0 = [NSMutableArray new];
    for(int i=1;i<=self.model.column;i++)
    {
        if([aisleColumn containsObject:@(i)])
        {
            [array0 addObjectsFromArray:[self columnNumArrayWithColumn:i]];
        }
    }
    //排序
    NSArray *sortedArray0 = [self sortedArray:array0];
    
    //非过道
    NSMutableArray *array1 = [NSMutableArray new];
    for(int i=1;i<=self.model.column;i++)
    {
        if(![aisleColumn containsObject:@(i)])
        {
            [array1 addObjectsFromArray:[self columnNumArrayWithColumn:i]];
        }
    }
    //排序
    NSArray *sortedArray1 = [self sortedArray:array1];
    
    NSMutableArray *dataArray = [NSMutableArray new];
    [dataArray addObjectsFromArray:sortedArray0];
    [dataArray addObjectsFromArray:sortedArray1];
    return dataArray;
}

/**
 *  根据列,获取该列座位号
 */
-(NSArray *)columnNumArrayWithColumn:(NSInteger)column
{
    NSMutableArray *array = [NSMutableArray new];
    for(int i=0;i<self.model.row;i++)
    {
        NSInteger tempColumn = column + i*self.model.column;
        [array addObject:@(tempColumn)];
    }
    
    return array;
}

-(NSArray *)sortedArray:(NSArray *)array{
    
    NSArray * sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if ([obj1 intValue] < [obj2 intValue])
        {
            return  NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    return sortedArray;
}

#pragma makr - Lazy
-(CabinLayoutModel *)model
{
    if(_model==nil)
    {
        _model = [[CabinLayoutModel alloc] initWithCabinType:CabinTypeOne];
    }
    return _model;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
