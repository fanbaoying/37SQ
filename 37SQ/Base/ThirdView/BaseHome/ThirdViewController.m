//
//  ThirdViewController.m
//  37shequ
//
//  Created by administrator on 16/9/22.
//  Copyright © 2016年 hjp. All rights reserved.
//

#import "ThirdViewController.h"
#import "MyNav.h"
#import "MyTableViewCell.h"
#import "MyTZViewController.h"
#import "TZCollectViewController.h"
#import "AppDelegate.h"
#import "HomeService.h"
#import "Type_HomeService.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "NoteViewController.h"
#import "FBY-HomeService.h"
#import "SearchResultViewController.h"

#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width


@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic)UIView *tableHead;

@property (strong, nonatomic)UISearchBar *searchBar;

@property (strong, nonatomic)UIScrollView *scroll;

@property (strong, nonatomic)UIPageControl *pageControl;

@property (strong, nonatomic)NSTimer *timer;

@property (strong, nonatomic)UIButton *btn1;
@property (strong, nonatomic)UILabel *lab1;

@property (strong, nonatomic)UIButton *btn2;
@property (strong, nonatomic)UILabel *lab2;

@property (strong, nonatomic)UIButton *btn3;
@property (strong, nonatomic)UILabel *lab3;

@property (strong, nonatomic)UITableView *table;

@property (strong, nonatomic)UILabel *line;

@property (strong, nonatomic)NSMutableArray *mutArr;

@property (assign, nonatomic)NSInteger total;

@property (copy, nonatomic)NSString *type;

@property (assign, nonatomic)NSInteger scrollNum;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mutArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.scrollNum = 0;
    
    
    self.total = 1;
    self.type = nil;
    
    
    //网络请求
    HomeService *service = [[HomeService alloc]init];
    [service searchMessage:@"1" andWithAction:nil andSuccess:^(NSDictionary *dic) {
        
        NSArray *arr =  [dic objectForKey:@"data"];
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:arr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];

    
    //导航栏
    MyNav *nav = [[MyNav alloc]initWithTitle:@"社区" bgImg:nil leftBtn:@"TZCollect" rightBtn:nil];
//    nav.leftBtn
    
    [nav.leftBtn addTarget:self action:@selector(myTZCollect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    
    //tableView的headView
    self.tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 310-64)];
    
    //tableView
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, [UIScreen mainScreen].bounds.size.height-113)];
    self.table.tableHeaderView = _tableHead;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:_table];
    
    //搜索栏
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 40)];
    self.searchBar.delegate=self;
//    self.searchBar.showsCancelButton=YES;
//    self.searchBar.backgroundColor = [UIColor whiteColor];
    [self.tableHead addSubview:_searchBar];
    
    
    //滑动
    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDHN, 120)];
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDHN*3, 120);
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.pagingEnabled = YES;
    self.scroll.bounces = NO;
    self.scroll.delegate = self;
    //
    
    //广告网络请求
    FBY_HomeService *service1 = [[FBY_HomeService alloc]init];
    [service1 searchMessage:@"11" andWithAction:@"type" andUrl:@"http://115.159.195.113:8000/37App/index.php/home/type/adtype" andSuccess:^(NSDictionary *dic) {
        NSArray *nono = [dic objectForKey:@"data"];
         UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 120)];
        [view1 sd_setImageWithURL:[nono[0] objectForKey:@"ad_pic" ] placeholderImage:[UIImage imageNamed:@"load"]];
        
//        view1.backgroundColor = [UIColor redColor];
        
        UIImageView *view2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDHN, 0, SCREEN_WIDHN, 120)];
//        view2.backgroundColor = [UIColor orangeColor];
        [view2 sd_setImageWithURL:[nono[1] objectForKey:@"ad_pic" ] placeholderImage:[UIImage imageNamed:@"load"]];
        UIImageView *view3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDHN*2, 0, SCREEN_WIDHN, 120)];
//        view3.backgroundColor = [UIColor yellowColor];
        [view3 sd_setImageWithURL:[nono[2] objectForKey:@"ad_pic" ] placeholderImage:[UIImage imageNamed:@"load"]];
        [self.scroll addSubview:view1];
        [self.scroll addSubview:view2];
        [self.scroll addSubview:view3];
        
    } andFailure:^(int fail) {
        
    }];

   
    [self.tableHead addSubview:_scroll];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2-20, 140, 40, 20)];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:102/255.0 alpha:1];//选中页码的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];//未选中页码的颜色
    self.pageControl.currentPage = 0;//当前选中页
    self.pageControl.tag = 101;
//    [self.pageControl addTarget:self action:@selector(pageAction:) forControlEvents:(UIControlEventValueChanged)];
    [self.tableHead addSubview:_pageControl];
    
    //开启定时器
    [self starTimer];
    
    //创意分享,游戏杂谈,情感故事
    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(40, 235-64, 44, 44)];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:0];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:1];
    [self.btn1 addTarget:self action:@selector(TZcyfx) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHead addSubview:_btn1];
    
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2-22, 235-64, 44, 44)];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:0];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:1];
    [self.btn2 addTarget:self action:@selector(TZyxzt) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHead addSubview:_btn2];
    
    self.btn3 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDHN-84, 235-64, 44, 44)];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:0];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:1];
    [self.btn3 addTarget:self action:@selector(TZqggs) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHead addSubview:_btn3];
    
    self.lab1 = [[UILabel alloc]initWithFrame:CGRectMake(35, 285-64, 54, 20)];
    self.lab1.text = @"创意分享";
    self.lab1.textColor = [UIColor grayColor];
    self.lab1.font = [UIFont systemFontOfSize:13.0];
    [self.tableHead addSubview:_lab1];
    
    self.lab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN/2-27, 285-64, 54, 20)];
    self.lab2.text = @"游戏杂谈";
    self.lab2.textColor = [UIColor grayColor];
    self.lab2.font = [UIFont systemFontOfSize:13.0];
    [self.tableHead addSubview:_lab2];
    
    self.lab3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDHN-89, 285-64, 54, 20)];
    self.lab3.text = @"情感故事";
    self.lab3.textColor = [UIColor grayColor];
    self.lab3.font = [UIFont systemFontOfSize:13.0];
    [self.tableHead addSubview:_lab3];
    
    //线
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 309.5-64, SCREEN_WIDHN, 0.5)];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self.tableHead addSubview:_line];
    
    
    //MJRefresh上拉刷新
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_footer)];
    
    //MJRefresh下拉刷新
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefresh_header)];
    
    
    
    // Do any additional setup after loading the view.
}
//点击搜索按钮的函数
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    SearchResultViewController *vc=[[SearchResultViewController alloc]init];
    vc.whatname=searchBar.text;
    searchBar.text=nil;
    [searchBar resignFirstResponder];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:0];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:1];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:0];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:1];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:0];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:1];
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
    [cell.headImg sd_setImageWithURL:[_mutArr[indexPath.row] objectForKey:@"user_headimg"] placeholderImage:[UIImage imageNamed:@"load"]];
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
    [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[_mutArr[indexPath.row] objectForKey:@"user_headimg"]]
placeholderImage:[UIImage imageNamed:@"sorryImage"]];
    
    cell.time.text = [self timeD_Value:[_mutArr[indexPath.row] objectForKey:@"allnote_time"]];
    
    return cell;
}


//上拉刷新
- (void)MJRefresh_footer{
    [self.table.mj_footer beginRefreshing];
    
    self.total ++;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    NSLog(@"------type = %@",_type);
//    网络请求
    HomeService *service = [[HomeService alloc]init];
    [service searchMessage:pageNum andWithAction:_type andSuccess:^(NSDictionary *dic) {
        
                NSArray *tempArr = [dic objectForKey:@"data"];
        
//                NSLog(@"%@",tempArr);
        
                [self.mutArr addObjectsFromArray:tempArr];
        
                [self.table reloadData];
        
    } andFailure:^(int fail) {
        
        self.total = self.total - fail;
        
    }];
    
    [self.table.mj_footer endRefreshing];
}


//下拉刷新
- (void)MJRefresh_header{
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:0];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:1];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:0];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:1];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:0];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:1];
    
    [self.table.mj_header beginRefreshing];
    
    self.total = 1;
    self.type = nil;
    NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_total];
    NSLog(@"---page = %@",pageNum);
    NSLog(@"------type = %@",_type);
    //    网络请求
    HomeService *service = [[HomeService alloc]init];
    [service searchMessage:pageNum andWithAction:_type andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
        //                NSLog(@"%@",tempArr);
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
        //弹窗,请检查网络连接
        NSLog(@"----请检查网络连接");
        
    }];
    
    [self.table.mj_header endRefreshing];
}


// scrollview 减速停止(scrollview与pageControl通过tag 搭配使用)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isMemberOfClass:[UITableView class]])
    {
//        NSLog(@"scrollViewDidEndDecelerating %@",scrollView);
    }
    else{
        //scrollView的偏移量，x,y值
        int current = scrollView.contentOffset.x/SCREEN_WIDHN;
        self.pageControl = (UIPageControl *)[self.view viewWithTag:101];  //类型强转，查找
        self.pageControl.currentPage = current;
        //        NSLog(@"scrollViewDidEndDecelerating %@",scrollView);
        NSLog(@"%f",scrollView.contentOffset.x);//打印偏移量值
    }
}

//开始拖拽时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self stopTimer];
    
}

//拖拽结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self starTimer];
}


- (void)change:(NSTimer *)timer{
    self.scrollNum ++;
    
    if (self.scrollNum == _pageControl.numberOfPages) {
        [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        self.pageControl.currentPage = self.scrollNum;
        self.scrollNum = 0;
    }
    self.pageControl.currentPage = _scrollNum;
    [self.scroll setContentOffset:CGPointMake(_scrollNum * SCREEN_WIDHN, 0) animated:YES];
    
}


//type 创意分享
- (void)TZcyfx{
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx_copy"] forState:0];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx_copy"] forState:1];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:0];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:1];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:0];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:1];
    //转变刷新时请求数据的类型
    self.total = 1;
    self.type = @"1";
    
    //    网络请求
    Type_HomeService *service = [[Type_HomeService alloc]init];
    [service searchMessage:@"1" andWithAction:_type andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
//        NSLog(@"%@",tempArr);
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];

}


//type 游戏杂谈
- (void)TZyxzt{
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:0];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:1];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt_copy"] forState:0];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt_copy"] forState:1];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:0];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs"] forState:1];
    //转变刷新时请求数据的类型
    self.total = 1;
    self.type = @"2";
    
    //    网络请求
    Type_HomeService *service = [[Type_HomeService alloc]init];
    [service searchMessage:@"1" andWithAction:_type andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
//        NSLog(@"%@",tempArr);
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];

}


//type 情感故事
- (void)TZqggs{
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:0];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"TZcyfx"] forState:1];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:0];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"TZyxzt"] forState:1];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs_copy"] forState:0];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"TZqggs_copy"] forState:1];
    //转变刷新时请求数据的类型
    self.total = 1;
    self.type = @"3";
    
    //    网络请求
    Type_HomeService *service = [[Type_HomeService alloc]init];
    [service searchMessage:@"1" andWithAction:_type andSuccess:^(NSDictionary *dic) {
        
        NSArray *tempArr = [dic objectForKey:@"data"];
        
//        NSLog(@"%@",tempArr);
        
        [self.mutArr removeAllObjects];
        
        [self.mutArr addObjectsFromArray:tempArr];
        
        [self.table reloadData];
        
    } andFailure:^(int fail) {
        
    }];

}


//帖子详情页面的跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoteViewController *vc = [[NoteViewController alloc]init];
    vc.TZid = [_mutArr[indexPath.row] objectForKey:@"allnote_id"];
    [self.navigationController pushViewController:vc animated:YES];
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
    
//    //隐藏tabbar及中间的加号
//    self.tabBarController.tabBar.hidden = YES;
//    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.mid.hidden = YES;
    
}




//左上角 帖子收藏页跳转
- (void)myTZCollect{
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    if (user_id) {
        
        TZCollectViewController *vc = [[TZCollectViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

//开启定时器
- (void)starTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(change:) userInfo:nil repeats:YES];
    
}

//关闭定时器
- (void)stopTimer{
    
    [self.timer invalidate];
    self.timer = nil;
    
}


//获取数据包里的时间 和 当前本地时间的时间差, 返回 年或月或日或时或分
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
