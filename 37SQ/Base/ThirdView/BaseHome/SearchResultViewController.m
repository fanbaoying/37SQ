//
//  SearchResultViewController.m
//  37SQ
//
//  Created by administrator on 2016/11/6.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MyNav.h"
#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TZCollectService.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "NoteViewController.h"
#import "AFNetworking.h"

#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *table;

@property (strong, nonatomic)NSMutableArray *mutArr;

@property (assign, nonatomic)NSInteger total;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //给页面添加手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //向右
    [self.view addGestureRecognizer:swipeGesture];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mutArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.total = 1;

    MyNav *nav = [[MyNav alloc]initWithTitle:@"搜索结果" bgImg:nil leftBtn:@"TZBack" rightBtn:nil];
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
       [self.table.mj_header beginRefreshing];
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
    cell.content.text = note_content;
    
    
    //SDWebImage框架的使用
    [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:[_mutArr[indexPath.row] objectForKey:@"allnote_img"]]
                       placeholderImage:[UIImage imageNamed:@"sorryImage"]];
    
    cell.time.text = [self timeD_Value:[_mutArr[indexPath.row] objectForKey:@"allnote_time"]];
     return cell;
}
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {         
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//帖子详情页面的跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoteViewController *vc = [[NoteViewController alloc]init];
    vc.TZid = [_mutArr[indexPath.row] objectForKey:@"allnote_id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)back {
//    self.tabBarController.tabBar.hidden=NO;
//    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.mid.hidden = NO;
//    appDelegate.mids.hidden=NO;

    [self.navigationController popViewControllerAnimated:YES];
}


//上拉加载
- (void)MJRefresh_footer{
    //    [self.table.mj_footer beginRefreshing];
    
    self.total ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:_whatname forKey:@"name"];
    [dic setObject:[NSString stringWithFormat:@"%lD",(long)_total] forKey:@"page"];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/community/wtf/selectname";
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *qqq = responseObject;
        if ([@"200" isEqualToString:[qqq objectForKey:@"code"]]) {
            NSArray * tempArr=[qqq objectForKey:@"data"];
            [self.mutArr addObjectsFromArray:tempArr];
            [self.table reloadData];
        }else{
//            self.mutArr=[qqq objectForKey:@"data"];
//            [self.table reloadData];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有更多帖子了" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好吧..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         self.total = self.total - 1;
        NSLog(@"%ld",(long)_total);
    }];
//

    [self.table.mj_footer endRefreshing];
}


//下拉刷新
- (void)MJRefresh_header{
    //    [self.table.mj_header beginRefreshing];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    NSLog(@"-----------%@",_whatname);
    [dic setObject:_whatname forKey:@"name"];
    [dic setObject:@"1" forKey:@"page"];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/community/wtf/selectname";
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *qqq = responseObject;
        if ([@"200" isEqualToString:[qqq objectForKey:@"code"]]) {
             [self.mutArr removeAllObjects];
            NSArray *tempArr =[qqq objectForKey:@"data"];
             [self.mutArr addObjectsFromArray:tempArr];
            [self.table reloadData];
        }else{
//            self.mutArr=[qqq objectForKey:@"data"];
//            [self.table reloadData];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有找到相关帖子" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"shibai");
        
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
