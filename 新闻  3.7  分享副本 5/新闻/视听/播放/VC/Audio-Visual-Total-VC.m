//
//  Audio-Visual-Total-VC.m
//  新闻
//
//  Created by dllo on 16/2/26.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "Audio-Visual-Total-VC.h"
#import "Video-Total.h"
#import "Audio-Total.h"
#import "Audio-More-VC.h"
#import "Audio-Total-V.h"
#import "Audio-Detail-VC.h"

@interface Audio_Visual_Total_VC ()<UICollectionViewDelegate, UICollectionViewDataSource,moreMideleDelgate>

@property (nonatomic, retain) UIScrollView *scrollV;
@property (nonatomic, retain) NSArray        *array;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) UIButton       *currentButton;
@property (nonatomic, assign) NSInteger      buttonTag;
@property (nonatomic, retain) UIButton       *button;
@end

@implementation Audio_Visual_Total_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatView];
//    [self scrollViewAction];
    
}

#pragma collectionView
-(void)creatView
{
    [self collection];
   
}

-(void)collection
{
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc] init];
    
    flowL.minimumInteritemSpacing = 0;
    flowL.minimumLineSpacing = 0;
    flowL.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    flowL.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // 滚动方向
    flowL.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowL];
    self.collectionV.pagingEnabled = YES;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    [self.view addSubview:self.collectionV];
    
    [self.collectionV registerClass:[Video_Total class] forCellWithReuseIdentifier:@"cell1"];
    [self.collectionV registerClass:[Audio_Total class] forCellWithReuseIdentifier:@"cell2"];
}

// 图片数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return self.arr.count;
    return 2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( 0 == indexPath.row) {
        Video_Total *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        Audio_Total *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    
}





#pragma scrollView
-(void)scrollViewAction
{
    self.array = [NSArray arrayWithObjects:@"视频", @"音频", nil];
    self.scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, 0, 100, self.view.bounds.size.height)];
    self.scrollV.contentSize = CGSizeMake([self widthWithArray:self.array height:30 font:19.0 space:25], 30);
    self.scrollV.showsHorizontalScrollIndicator = NO;
    self.buttonArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i++) {
        //每个按钮的大小
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.tag = i;
        //设置第一个按钮为默认按钮
        if (0 == button.tag) {
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:19.0];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.frame = CGRectMake(i * [self widthWithString:[self.array objectAtIndex:i] height:30 font:19.0] + i * 10, 0, [self widthWithString:[self.array objectAtIndex:i] height:30 font:19.0], 30);
        //        button.frame = CGRectMake(0, 0, 120, 60);
        [button setTitle:[self.array objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self.scrollV addSubview:button];
    }
    
    [self.navigationController.navigationBar addSubview:self.scrollV];
}


//按钮上所有的字的自适应宽度
- (CGFloat)widthWithArray:(NSArray *)array height:(CGFloat)height font:(CGFloat)font space:(CGFloat)space{
    CGFloat width = 0;
    for (NSString *string in array) {
        CGRect subFrame = [string boundingRectWithSize:CGSizeMake(0, height) options:1 attributes:@{[UIFont systemFontOfSize:font]:NSFontAttributeName} context:nil];
        CGFloat widthTemp = subFrame.size.width;
        width += widthTemp + space;
    }
    return width;
}

- (void)buttonAction:(UIButton *)sender {
    //先判点击的按钮是不是第一个按钮,如果不是第一个按钮,把第一个按钮状态变成非选择状态,
    //这么做的原因是因为把第一个按钮设置为默认按钮并没有取消
    //    NSIndexPath *i = [self.subScrollView.contentOffset.x / self.frame.size.width];
    
    
    if (0 != sender.tag) {
        UIButton *button = [self.buttonArray objectAtIndex:0];
        button.selected = NO;
    }
    if (self.currentButton != sender) {
        self.currentButton.selected = NO;
        self.currentButton = sender;
        self.currentButton.selected = YES;
        self.currentButton.titleLabel.font = [UIFont systemFontOfSize:19.0];
        self.buttonTag = sender.tag;
        self.currentButton.tag = self.buttonTag;
        self.currentButton = [self.buttonArray objectAtIndex:sender.tag];
        
        self.collectionV.contentOffset = CGPointMake(self.collectionV.frame.size.width * sender.tag, 0);
    }
    //遍历button,如果button的tag值和刚才的button不同,把按钮字体变小,如果相同变成17号字体
    for (UIButton *button in self.buttonArray) {
        if (button.tag != self.buttonTag) {
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            button.selected = NO;
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:19.0];
            button.selected = YES;
        }
    }
    
}


//按钮上的字自适应宽度
- (CGFloat)widthWithString:(NSString *)string height:(CGFloat)height font:(CGFloat)font {
    self.view.frame = [string boundingRectWithSize:CGSizeMake(0, height) options:1 attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName] context:nil];
    return self.view.frame.size.width;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.collectionV.contentOffset.x / self.collectionV.frame.size.width;
    for (UIButton *button in self.buttonArray) {
        if (button.tag == index) {
            button.selected = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:19.0];
        } else {
            button.selected = NO;
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        }
    }
    
    if (index > 3) {
        self.scrollV.contentOffset = CGPointMake((index - 3) * 48, 0);
    } else {
        self.scrollV.contentOffset = CGPointMake(0, 0);
    }
}


-(void)getchangemoreMiddle:(NSString *)more
{
    Audio_More_VC *detail = [[Audio_More_VC alloc] init];
//    NSLog(@"%@",more);
    detail.moreId = more;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)getchangeIdMiddle:(NSString *)middle
{
    Audio_Detail_VC *detail = [[Audio_Detail_VC alloc] init];
    detail.idTotal = middle;
    [self.navigationController pushViewController:detail animated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //在视图将要出现的时候,创建NC上的导航按钮
    [self scrollViewAction];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //当视图即将消失的时候把装有导航按钮的视图删掉
    [self.scrollV removeFromSuperview];
}

































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
