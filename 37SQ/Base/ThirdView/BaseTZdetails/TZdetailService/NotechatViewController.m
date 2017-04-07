//
//  NotechatViewController.m
//  37SQ
//
//  Created by administrator on 2016/11/4.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "NotechatViewController.h"

#import "VideoCommentTableViewCell.h"
#import "GiveService.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "ReportViewController.h"
#import "AFNetworking.h"
#import "MyNav.h"
#import "AddNoteViewController.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface NotechatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(strong,nonatomic)UITableView *commentTab;//tableview
@property(strong,nonatomic)NSMutableArray *homeArr;//装结果的数组
@property(assign,nonatomic)CGFloat  height;//行高
@property(strong,nonatomic)UIView *commentView;//评论VIEW
@property(strong,nonatomic)NSMutableArray *heightArr;
@property(assign,nonatomic)BOOL thumbBool;//点赞BOOL
@property(strong,nonatomic)NSMutableArray *thumbArr;//点赞数组

@end

@implementation NotechatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.heightArr = [NSMutableArray arrayWithCapacity:0];
    self.thumbArr=[[NSMutableArray alloc]initWithCapacity:0];
    //准备工作
    self.homeArr=[[NSMutableArray alloc]initWithCapacity:0];
    
    //tableview
    self.commentTab=[[UITableView alloc]initWithFrame:CGRectMake(0 , 64, SCREEN_WIDHN, SCREEN_HEIGHT-64-30 ) style:UITableViewStylePlain];
    
    self.commentTab.dataSource=self;
    self.commentTab.delegate=self;
    //导航栏
   
    MyNav *nav = [[MyNav alloc]initWithTitle:@"评论列表" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    //刷新框架
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
  
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.commentTab.mj_header = header;
    
    [self.view addSubview:_commentTab];
    //
    UIButton *gonext=[[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, SCREEN_WIDHN, 30)];
    [gonext setTitle:@"发表评论" forState:0];
    [gonext setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:0];
    gonext.titleLabel.font=[UIFont systemFontOfSize:13];
    gonext.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [gonext addTarget:self action:@selector(gocomment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gonext];
    [self.commentTab.mj_header beginRefreshing];
    
}
//去写评论
- (void)gocomment{
    //获取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    if (squserid) {
    AddNoteViewController *vc=[[AddNoteViewController alloc ]init];
    vc.noteid=_Whatid;
        [self presentViewController:vc animated:YES completion:nil];}
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好好好,这就去." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self  presentViewController:alert animated:YES completion:nil];
}
}
//返回并点赞
- (void)leftaction{
    if (_thumbArr.count>0) {
        //发送点赞
        NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/test/thumb";
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:_thumbArr forKey:@"comment_id"];
        
        [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"(没有返回值)---");
        }];}
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)loadNewData{
   
    [self gethomemessage];
    [self.commentTab.mj_header endRefreshing];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _homeArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     self.height=[self getHeightByWidth:SCREEN_WIDHN-100 title:[_homeArr[indexPath.row] objectForKey:@"comment_content"] font:[UIFont systemFontOfSize:12] ];
    // NSLog(@"hight----%f==",_height);
    
    [self.heightArr addObject:[NSString stringWithFormat:@"%f",_height]];
    //    NSLog(@"%@",_heightArr);
    return 70 +_height;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    @property(strong,nonatomic)uibutton *vipheaderImg;//评论人头像
    //    @property(strong,nonatomic)UILabel *vipnameLab;//名字
    //    @property(strong,nonatomic)UILabel *vipturnLab;//楼层
    //    @property(strong,nonatomic)UILabel *viptimeLab;//时间
    //    @property(strong,nonatomic)UIButton *vipAgreeBtn;//点赞图标
    //    @property(strong,nonatomic)UILabel *vipAgreeLab;//点赞数
    //    //@property(strong,nonatomic)UIImageView *vipxxxx //预留楼中楼
    //    @property(strong,nonatomic)UILabel *vipcontentLab;//评论正文
    static NSString *str  = @"ttt";
    
    VideoCommentTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell=[[VideoCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    [cell.vipheaderBtn sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"load"]];
    
    
    cell.vipturnLab.text=[NSString stringWithFormat:@"#%@",[_homeArr[indexPath.row] objectForKey:@"comment_level"]];
    cell.vipnameLab.text=[_homeArr[indexPath.row] objectForKey:@"user_name"];
    cell.viptimeLab.text=[self timeD_Value:[_homeArr[indexPath.row] objectForKey:@"comment_time"]];
    cell.vipAgreeLab.text=[_homeArr[indexPath.row] objectForKey:@"comment_praise"];
    cell.vipAgreeLab.tag=9000+[[_homeArr[indexPath.row] objectForKey:@"comment_id"]intValue];
    //评论
    cell.vipcontentLab.numberOfLines=0;
    cell.vipcontentLab.font=[UIFont systemFontOfSize:12];
    //----------
//    cell.backgroundColor=[UIColor redColor];
    //    NSLog(@"-----cell----%f",_height);
    NSLog(@"%@",[_homeArr[indexPath.row] objectForKey:@"comment_level"]);
    
    NSString *he = self.heightArr[indexPath.row];
    cell.vipcontentLab.frame=CGRectMake(60, 55, SCREEN_WIDHN-100, he.floatValue);
    [cell.vipDianBtn addTarget:self action:@selector(goreport:) forControlEvents:UIControlEventTouchUpInside];
    cell.vipDianBtn.tag=[[_homeArr[indexPath.row] objectForKey:@"comment_id"]intValue];
    [cell.vipAgreeBtn addTarget:self action:@selector(addsafe:) forControlEvents:UIControlEventTouchUpInside];
    cell.vipAgreeBtn.tag=[[_homeArr[indexPath.row] objectForKey:@"comment_id"]intValue];
    cell.vipcontentLab.text=[_homeArr[indexPath.row] objectForKey:@"comment_content"];
    
    return cell;
    
}
- (void)goreport:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"举报" style:2 handler:^(UIAlertAction * _Nonnull action) {ReportViewController *vc=[[ReportViewController alloc]init];
        vc.Whatid=[NSString stringWithFormat:@"%ld",(long)sender.tag];
        vc.Whattype=@"2";
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self  presentViewController:alert animated:YES completion:nil];
    
}

- (void)gethomemessage{
    self.heightArr = [NSMutableArray arrayWithCapacity:0];

    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/notecomment";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_Whatid forKey:@"noteid"];
  [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.homeArr  =[responseObject objectForKey:@"data"];
    
        [self.commentTab reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
////评论正文高度自适应
- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
//点赞的函数
//点赞

-(void)addsafe:(UIButton *)sender{
    NSString *name=[NSString stringWithFormat:@"%lD",(long)sender.tag];
    NSLog(@"%lD",(long)sender.tag);
    bool what=0;
    if (_thumbArr.count==0) {
        NSDictionary *dic=@{@"name":name};
        [self.thumbArr addObject:dic];
        UILabel *haha=[self.view viewWithTag:9000+sender.tag];
        int a=[haha.text intValue];
        haha.text=[NSString stringWithFormat:@"%d",a+1];
        [sender setImage:[UIImage imageNamed:@"thumbreddl"] forState:0];}
    else{
        for (int i=0; i<_thumbArr.count; i++) {
            if ([[_thumbArr[i] objectForKey:@"name" ]isEqualToString:name]) {
                [sender setImage:[UIImage imageNamed:@"thumbdl"] forState:0];
                [self.thumbArr removeObjectAtIndex:i];
                UILabel *hah=[self.view viewWithTag:9000+sender.tag];
                int a=[hah.text intValue];
                hah.text=[NSString stringWithFormat:@"%d",a-1];
                what =1;
                break;
            }}
        if (what==0) {
            NSDictionary *dic=@{@"name":name};
            [self.thumbArr addObject:dic];
            [sender setImage:[UIImage imageNamed:@"thumbreddl"] forState:0];
            UILabel *haha=[self.view viewWithTag:9000+sender.tag];
            int a=[haha.text intValue];
            haha.text=[NSString stringWithFormat:@"%d",a+1];
        }
        
        
        
    }
    
    NSLog(@"%@",_thumbArr);
   
}



- (NSString *)timeD_Value:(NSString *)serverMessageTime{
    //获取系统时间(GMT（格林威治标准时间),按时区转化成本地时间
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
