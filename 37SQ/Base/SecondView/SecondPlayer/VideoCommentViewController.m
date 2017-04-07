//
//  VideoCommentViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/13.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "VideoCommentViewController.h"
#import "VideoCommentTableViewCell.h"
#import "GiveService.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "ReportViewController.h"
#import "AFNetworking.h"
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface VideoCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(strong,nonatomic)UITableView *commentTab;//tableview
@property(strong,nonatomic)NSMutableArray *homeArr;//装结果的数组
@property(assign,nonatomic)CGFloat  height;//行高
@property(strong,nonatomic)UIView *commentView;//评论VIEW
@property(strong,nonatomic)NSMutableArray *heightArr;
@property(assign,nonatomic)BOOL thumbBool;//点赞BOOL


@end

@implementation VideoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightArr = [NSMutableArray arrayWithCapacity:0];
    self.thumbArr=[[NSMutableArray alloc]initWithCapacity:0];
    //准备工作
    self.homeArr=[[NSMutableArray alloc]initWithCapacity:0];
    
    //tableview
    self.commentTab=[[UITableView alloc]initWithFrame:CGRectMake(0 , 0, SCREEN_WIDHN, SCREEN_HEIGHT -SCREEN_WIDHN*9/16.0-80 ) style:UITableViewStylePlain];
    
    self.commentTab.dataSource=self;
    self.commentTab.delegate=self;
    //刷新框架
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
    self.commentTab.mj_header = header;
    [self.commentTab.mj_header beginRefreshing];
    [self.view addSubview:_commentTab];
  
    
}
-(void)loadNewData{
    self.heightArr = [NSMutableArray arrayWithCapacity:0];
     self.homeArr = [NSMutableArray arrayWithCapacity:0];
    //网络请求
    GiveService *tesit=[[GiveService alloc]init];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/videocomment";
    if (_VVideoId.length>0) {
     [tesit searchMessage:_VVideoId andAction:@"videocomment" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
        if (dic.count>0) {
            NSArray *go=[dic objectForKey:@"data"];
            [self.homeArr  addObjectsFromArray:go];
                            NSLog(@"%@",_homeArr);
            [self.commentTab reloadData];
        }}
      ];}

    [self.commentTab.mj_header endRefreshing];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _homeArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
    
    
    if (_homeArr.count>0) {
        self.height=[self getHeightByWidth:SCREEN_WIDHN-100 title:[_homeArr[indexPath.row] objectForKey:@"comment_content"] font:[UIFont systemFontOfSize:12] ];
        
        
        [self.heightArr addObject:[NSString stringWithFormat:@"%f",_height]];
    }
   
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
//    static NSString *str  = @"ttt";
    
    VideoCommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"haha"];
    if (cell==nil) {
        cell=[[VideoCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"haha"];
    }if (_homeArr.count>0) {
        
    
    
    [cell.vipheaderBtn sd_setImageWithURL:[_homeArr[indexPath.row] objectForKey:@"user_headimg"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"load"]];
    
    
    cell.vipturnLab.text=[NSString stringWithFormat:@"#%@",[_homeArr[indexPath.row] objectForKey:@"comment_level"]];
    cell.vipnameLab.text=[_homeArr[indexPath.row] objectForKey:@"user_name"];
    cell.viptimeLab.text=[self timeD_Value:[_homeArr[indexPath.row] objectForKey:@"comment_time"]];
    cell.vipAgreeLab.text=[_homeArr[indexPath.row] objectForKey:@"comment_praise"];
    cell.vipAgreeLab.tag=9000+[[_homeArr[indexPath.row] objectForKey:@"comment_id"]intValue];
    //评论
  cell.vipcontentLab.numberOfLines=0;
    cell.vipcontentLab.font=[UIFont systemFontOfSize:12];
    
//    NSLog(@"-----cell----%f",_height);
    NSLog(@"-------level%@",[_homeArr[indexPath.row] objectForKey:@"comment_level"]);
    
    CGFloat he = [self.heightArr[indexPath.row] floatValue];
    cell.vipcontentLab.frame=CGRectMake(60, 55, SCREEN_WIDHN-100, he);
    [cell.vipDianBtn addTarget:self action:@selector(goreport:) forControlEvents:UIControlEventTouchUpInside];
    cell.vipDianBtn.tag=[[_homeArr[indexPath.row] objectForKey:@"comment_id"]intValue];
    [cell.vipAgreeBtn addTarget:self action:@selector(addsafe:) forControlEvents:UIControlEventTouchUpInside];
    cell.vipAgreeBtn.tag=[[_homeArr[indexPath.row] objectForKey:@"comment_id"]intValue];
        cell.vipcontentLab.text=[_homeArr[indexPath.row] objectForKey:@"comment_content"];}

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

//- (void)gethomemessage{
// self.heightArr = [NSMutableArray arrayWithCapacity:0];
//    //网络请求
//    GiveService *tesit=[[GiveService alloc]init];
//    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/videocomment";
//    [tesit searchMessage:_VVideoId andAction:@"videocomment" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
//        if (dic.count>0) {
//            self.homeArr  =[dic objectForKey:@"data"];
//            //                NSLog(@"%@",_homeArr);
//            [self.commentTab reloadData];
//        }}
//     ];
//
//}

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
