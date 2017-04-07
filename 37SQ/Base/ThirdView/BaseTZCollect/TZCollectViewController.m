//
//  TZCollectViewController.m
//  37SQ
//
//  Created by administrator on 16/9/30.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "TZCollectViewController.h"
#import "MyNav.h"
#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TZCollectService.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "NoteViewController.h"


#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width

@interface TZCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *table;

@property (strong, nonatomic)NSMutableArray *mutArr;

@property (assign, nonatomic)NSInteger total;

@end

@implementation TZCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mutArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.total = 1;
    
    //网络请求
    TZCollectService *service = [[TZCollectService alloc]init];
    [service searchMessage:@"1" andWithAction:user_id andSuccess:^(NSDictionary *dic) {
        
        NSArray *arr =  [dic objectForKey:@"data"];
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:arr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];

    
    MyNav *nav = [[MyNav alloc]initWithTitle:@"我的收藏" bgImg:nil leftBtn:@"TZBack" rightBtn:nil];
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
    [cell.headImg sd_setImageWithURL:[_mutArr[indexPath.row] objectForKey:@"user_headimg"] placeholderImage:[UIImage imageNamed:@"loadhead"]];
    cell.title.text = [_mutArr[indexPath.row] objectForKey:@"allnote_name"];
    cell.commentImg.image = [UIImage imageNamed:@"TZcomment"];
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
    
    cell.time.text = [self timeD_Value:[_mutArr[indexPath.row] objectForKey:@"allnote_time"]];
    

    
    return cell;
}

//帖子详情页面的跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoteViewController *vc = [[NoteViewController alloc]init];
    vc.TZid = [_mutArr[indexPath.row] objectForKey:@"allnote_id"];
    
    
    //隐藏tabbar及中间的加号
    self.tabBarController.tabBar.hidden = YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;

    [self.navigationController pushViewController:vc animated:YES];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


//上拉刷新
- (void)MJRefresh_footer{
//    [self.table.mj_footer beginRefreshing];
    
    self.total ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    //    网络请求
    TZCollectService *service = [[TZCollectService alloc]init];
    [service searchMessage:pageNum andWithAction:user_id andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
        self.total = self.total - fail;
//        [self.table.mj_footer endRefreshing];
    }];
    
    [self.table.mj_footer endRefreshing];
}


//下拉刷新
- (void)MJRefresh_header{
//    [self.table.mj_header beginRefreshing];
    
    self.total = 1;
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    //    网络请求
    TZCollectService *service = [[TZCollectService alloc]init];
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

- (NSString *)timeD_Value:(NSString *)serverMessageTime{
    NSDate *date = [NSDate date];
    
    //将服务器时间string(参数serverMessageTime)转化为NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-d HH:mm:ss"];
    NSDate *note_date = [formatter dateFromString:serverMessageTime];
    //    NSLog(@"%@",note_date);
    
    //获取时间差
    NSUInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unit fromDate:note_date toDate:date options:NSCalendarWrapComponents];
    //        NSLog(@"%ld",(long)components.year);
    //        NSLog(@"%ld",(long)components.month);
    //        NSLog(@"%ld",(long)components.day);
    //        NSLog(@"%ld",(long)components.hour);
    //        NSLog(@"%ld",(long)components.minute);
    //        NSLog(@"%ld",(long)components.second);
    NSString *year = [NSString stringWithFormat:@"%ld%@",(long)components.year,@"年前"];
    NSString *month = [NSString stringWithFormat:@"%ld%@",(long)components.month,@"月前"];
    NSString *day = [NSString stringWithFormat:@"%ld%@",(long)components.day,@"天前"];
    NSString *hour = [NSString stringWithFormat:@"%ld%@",(long)components.hour,@"小时前"];
    NSString *minute = [NSString stringWithFormat:@"%ld%@",(long)components.minute,@"分钟前"];
    //    NSString *second = [NSString stringWithFormat:@"%ld%@",components.second,@"秒前"];
    
    if (components.year > 0) {
        return year;
    }else if (components.month > 0){
        return month;
    }else if (components.day > 0){
        return day;
    }else if (components.hour > 0){
        return hour;
    }else {
        return minute;
    }
    
}
@end
