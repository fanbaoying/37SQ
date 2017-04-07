//
//  MyTZViewController.m
//  37SQ
//
//  Created by administrator on 16/9/30.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "MyTZViewController.h"
#import "MyNav.h"
#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MyTZService.h"
#import "MJRefresh.h"
#import "NoteViewController.h"
#import "AppDelegate.h"


#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width

@interface MyTZViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *table;

@property (strong, nonatomic)NSMutableArray *mutArr;

@property (assign, nonatomic)NSInteger total;

@end

@implementation MyTZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mutArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.total = 1;
    
    //网络请求
    MyTZService *service = [[MyTZService alloc]init];
    [service searchMessage:@"1" andWithAction:user_id andSuccess:^(NSDictionary *dic) {
        
        NSArray *arr =  [dic objectForKey:@"data"];
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:arr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];

    
    MyNav *nav = [[MyNav alloc]initWithTitle:@"我的帖子" bgImg:nil leftBtn:@"TZBack" rightBtn:nil];
    [nav.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
    //tableView
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, [UIScreen mainScreen].bounds.size.height-64)];
    self.table.showsVerticalScrollIndicator = NO;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:_table];
    
    //MJRefresh上拉刷新
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer)];
    
    //MJRefresh下拉刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
    


    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    /*
     @property (strong, nonatomic)UIImageView *headImg;
     @property (strong, nonatomic)UILabel *name;
     @property (strong, nonatomic)UIImageView *commentImg;
     @property (strong, nonatomic)UILabel *commentCount;
     @property (strong, nonatomic)UILabel *title;
     @property (strong, nonatomic)UIImageView *contentImg;
     @property (strong, nonatomic)UILabel *content;
     @property (strong, nonatomic)UILabel *type;
     @property (strong, nonatomic)UILabel *time;
     */
    cell.title.text = [_mutArr[indexPath.row] objectForKey:@"allnote_name"];
    cell.commentImg.image = [UIImage imageNamed:@"allTZcomment"];
    cell.commentCount.text = [_mutArr[indexPath.row] objectForKey:@"allnote_comment"];
    cell.name.text = [_mutArr[indexPath.row] objectForKey:@"user_name"];
    
    //类型解析(创意分享,游戏杂谈,情感故事)
    NSString *note_type;
    if ([[_mutArr[indexPath.row] objectForKey:@"allnote_type"] isEqualToString:@"1"]) {
        note_type = @"创意分享";
    }else if ([[_mutArr[indexPath.row] objectForKey:@"allnote_type"] isEqualToString:@"2"]){
        note_type = @"游戏杂谈";
    }else {
        note_type = @"情感故事";
    }
    cell.type.text = note_type;
    
    //帖子正文文字间距
    NSString *note_content = [_mutArr[indexPath.row] objectForKey:@"allnote_content"];
    //    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:note_content];
    //    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle1 setLineSpacing:30];
    //    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [note_content length])];
    //    [cell.content setAttributedText:attributedString1];
    cell.content.text = note_content;
    
    
    //SDWebImage框架的使用
    [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:[_mutArr[indexPath.row] objectForKey:@"allnote_img"]]
                       placeholderImage:[UIImage imageNamed:@"sorryImage"]];
    
    cell.time.text = [_mutArr[indexPath.row] objectForKey:@"allnote_time"];
    
    return cell;
}

//帖子详情页面的跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoteViewController *vc = [[NoteViewController alloc]init];
    vc.TZid = [_mutArr[indexPath.row] objectForKey:@"allnote_id"];
    [self.navigationController pushViewController:vc animated:YES];
    
    //隐藏tabbar及中间的加号
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//上拉刷新
- (void)MJRefresh_footer{
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    [self.table.mj_footer beginRefreshing];
    
    self.total ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    
    //    网络请求
    MyTZService *service = [[MyTZService alloc]init];
    [service searchMessage:pageNum andWithAction:user_id andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
        NSLog(@"%@",tempArr);
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
        self.total = self.total - fail;
        
    }];
    
    [self.table.mj_footer endRefreshing];
}


//下拉刷新
- (void)MJRefresh_header{
    [self.table.mj_header beginRefreshing];
    
    self.total = 1;
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    //    网络请求
    MyTZService *service = [[MyTZService alloc]init];
    [service searchMessage:pageNum andWithAction:user_id andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
        //弹窗,请检查网络连接
        NSLog(@"----请检查网络连接");
        
    }];
    
    [self.table.mj_header endRefreshing];
}


@end
