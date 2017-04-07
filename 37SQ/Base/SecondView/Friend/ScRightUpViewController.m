//
//  ScRightUpViewController.m
//  37SQ
//
//  Created by administrator on 2016/11/1.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "ScRightUpViewController.h"
#import "MyNav.h"
#import "RightUpTableViewCell.h"
#import "SearchFriendViewController.h"
#import "AddgroupViewController.h"
#import "AppDelegate.h"
#import "NewmessageViewController.h"
#import "MakegroupViewController.h"


#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ScRightUpViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(strong,nonatomic)UITableView *SelectoneTab;
@property(strong,nonatomic)NSArray *NameArr;//组头名字
@property(strong,nonatomic)NSArray *CellNameArr;//每组CELL的名字
@property(strong,nonatomic)NSArray *CellNamePicArr;//每组CELL的解释
@property(strong,nonatomic)MyNav *nav;
@property(strong,nonatomic)UIButton *searchView;//弹出搜索页
@property(strong,nonatomic)UIButton *searchnameBtn;//搜索按钮
@property(strong,nonatomic)UILabel *whatinput;//按钮上的LAB
@property(strong,nonatomic)UISearchBar *aha;//
@property(strong,nonatomic)NSTimer *timer;
@end

@implementation ScRightUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏下方TARBAR
    //
    self.tabBarController.tabBar.hidden=YES;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = YES;
      appDelegate.mids.hidden=YES;
    //导航栏
    self.nav = [[MyNav alloc]initWithTitle:@"添加朋友" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  self.nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:_nav];
    
    //TAB
    self.SelectoneTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDHN , SCREEN_HEIGHT) style:0];
    self.SelectoneTab.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.SelectoneTab.dataSource=self;
    self.SelectoneTab.delegate=self;
    [self.view addSubview:_SelectoneTab];
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 10)];
    footView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.SelectoneTab.tableFooterView=footView;
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.NameArr=@[@"查找好友",@"消息中心",@"创建"];
    self.CellNameArr=@[@"输入好友名精准查询",@"点击查看群组及好友请求",@"创建一个群组"];
    self.CellNamePicArr=@[@"添加朋友dl",@"各种请求dl",@"创建群组dl"];
    UIView *upview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 120)];
    upview.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDHN, 45)];
    UIImageView *search=[[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 45, 45)];
    search.image=[UIImage imageNamed:@"searchpic"];
    [searchBtn addTarget:self action:@selector(searchGroup) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor=[UIColor whiteColor];
    UILabel *searchLab=[[UILabel alloc]initWithFrame:CGRectMake(65, 12.5, SCREEN_WIDHN, 20)];
    searchLab.font=[UIFont systemFontOfSize:14];
    searchLab.textColor=[UIColor lightGrayColor];
    searchLab.text=@"群组名/群组号";
    [searchBtn addSubview:search];
    [searchBtn addSubview:searchLab];
    [upview addSubview:searchBtn];
    self.SelectoneTab.tableHeaderView=upview;
 
    //serachbar
    self.searchView=[[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-64)];
    [self.searchView addTarget:self action:@selector(dismisskey) forControlEvents:UIControlEventTouchUpInside];
    self.searchView.backgroundColor=[UIColor whiteColor];
    self.searchView.alpha=0.97;
    self.searchView.hidden=YES;
    [self.view addSubview:_searchView];
    self.aha=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 64)];
self.aha.placeholder=@"请输入群组名或群组号";
    self.aha.hidden=YES;
    self.aha.delegate=self;
    self.aha.showsCancelButton=YES;
    [self.view addSubview:_aha];
    //搜索按钮
    self.searchnameBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 60)];
    self.searchnameBtn.hidden=YES;
    [self.searchnameBtn addTarget:self action:@selector(gogogo) forControlEvents:UIControlEventTouchUpInside];
    self.whatinput=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, SCREEN_WIDHN-50, 40)];
    self.whatinput.textColor=[UIColor whiteColor];
    [self.searchnameBtn addSubview:_whatinput];
    self.searchnameBtn.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];;
    [self.searchView addSubview:_searchnameBtn];
    //给页面添加手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //向右
    [self.view addGestureRecognizer:swipeGesture];
}
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {  self.tabBarController.tabBar.hidden=NO;
        AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.mid.hidden = NO;
        appDelegate.mids.hidden=NO;
        
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)searchGroup{
  
    [self.aha becomeFirstResponder];

    self.searchView.hidden=NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.nav.frame=CGRectMake(0, -64, SCREEN_WIDHN, 64) ;
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(whatsearch) userInfo:nil repeats:NO];
 
}
- (void)whatsearch{
 self.aha.hidden=NO;
    [self.timer invalidate];
}
//点击搜索按钮的函数
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    AddgroupViewController *vc=[[AddgroupViewController alloc]init];
    vc.whatname=searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)gogogo{
    AddgroupViewController *vc=[[AddgroupViewController alloc]init];
    vc.whatname=self.aha.text;
    NSLog(@"%@-------",vc.whatname);
    [self.navigationController pushViewController:vc animated:YES];

}

//获取serachbar内容
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length>=1){
        self.searchnameBtn.hidden=NO;
        self.whatinput.text=[NSString stringWithFormat:@"搜索:%@",searchText];
    }else{
            self.searchnameBtn.hidden=YES;
        }
    NSLog(@"%@----%lu",searchText,(unsigned long)searchText.length);
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RightUpTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[RightUpTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"go"];
    }
    
    ////    @property(strong,nonatomic)UIImageView *LeftImg;//左边的图
    //    @property(strong,nonatomic)UILabel *UpLab;//上方LAB
    //    @property(strong,nonatomic)UILabel *DownLab;//下方Lab
    //    @property(strong,nonatomic)UIImageView *RightImg;//右边的小箭头
    cell.LeftImg.image=[UIImage imageNamed:_CellNamePicArr[indexPath.row]];
    cell.UpLab.text= _NameArr[indexPath.row];
    cell.DownLab.text=_CellNameArr[indexPath.row];
     return cell;
}
//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        SearchFriendViewController *vc=[[SearchFriendViewController alloc]init];
        vc.whatname=_aha.text;
        [self.navigationController pushViewController:vc animated:YES];
    }if (indexPath.row==1) {
        NewmessageViewController *vc=[[NewmessageViewController alloc]init];
               [self.navigationController pushViewController:vc animated:YES];
    }if (indexPath.row==2) {
    
        MakegroupViewController *vc=[[MakegroupViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return _NameArr[section];
//}
- (void)leftaction:(UIButton *)sender{
    //隐藏下方TARBAR
    //
    self.tabBarController.tabBar.hidden=NO;
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.mid.hidden = NO;
      appDelegate.mids.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];

}
//searchBAR函数

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=nil;
    self.whatinput.text=nil;
    self.searchView.hidden=YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.nav.frame=CGRectMake(0, 0, SCREEN_WIDHN, 64) ;
    }];
    self.aha.hidden=YES;
        [self.view endEditing:YES];
}
//点击屏幕大BUTTON返回
- (void)dismisskey{
    if (_whatinput.hidden==YES) {
        
    
    self.searchView.hidden=YES;
        self.searchnameBtn.hidden=YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.nav.frame=CGRectMake(0, 0, SCREEN_WIDHN, 64) ;
    }];
    self.aha.hidden=YES;
        [self.view endEditing:YES];}
}
@end
