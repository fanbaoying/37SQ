//
//  AddgroupViewController.m
//  37SQ
//
//  Created by administrator on 2016/9/29.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "AddgroupViewController.h"
#import "MyNav.h"
#import "AppDelegate.h"
#import "GiveService.h"
#import "DLTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewmessageViewController.h"
#import "AFNetworking.h"
#import "GroupdetailViewController.h"
//搜索群页
#define SCREEN_WIDHN [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface AddgroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITextField *groupname;
@property(strong,nonatomic)UIButton *searchbtn;
@property(strong,nonatomic)UITableView *mygroup;
@property(strong,nonatomic)NSMutableArray *mygrouArr;
@property(strong,nonatomic)NSMutableArray *HaveGroup;//已拥有的群组
@end

@implementation AddgroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //数组初始化
    self.mygrouArr=[[NSMutableArray alloc]initWithCapacity:0];
    self.HaveGroup=[[NSMutableArray alloc]initWithCapacity:0];
    //搜索结果TABLEVIEW
    self.mygroup=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHN, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    
    self.mygroup.dataSource=self;
    self.mygroup.delegate=self;
    self.mygroup.tableFooterView=[[UIView alloc]init];;
    [self.mygroup setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
//    self.mygroup.backgroundColor=[UIColor redColor];
    [self.view addSubview:_mygroup];
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHN, 15)];
    self.mygroup.tableHeaderView=headview;
    
    //获得自己的群组列表比对
    //取userid
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    GiveService *test=[[GiveService alloc]init];
    NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/index";
    [test searchMessage:squserid andAction:@"group" andUrl:uurl andNum:nil andSuccess:^(NSDictionary *dic) {
        //                NSLog(@"%@",dic);
        self.HaveGroup=[dic objectForKey:@"data"];
    }];
    //查
    [self search];
    
    

    //导航栏
    
    MyNav *nav = [[MyNav alloc]initWithTitle:@"搜索结果" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [  nav.leftBtn  addTarget:self action:@selector(leftaction:) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:nav];
  
    //搜索栏
//    self.groupname=[[UITextField alloc]initWithFrame:CGRectMake(10, 74, SCREEN_WIDHN-20, 40)];
//    self.groupname.placeholder=@"请输入群号或群昵称";
//    self.groupname.textAlignment=NSTextAlignmentCenter;
//    self.groupname.layer.borderWidth=1;
//     self.groupname.layer.borderColor=[UIColor lightGrayColor].CGColor;
//     self.groupname.font=[UIFont systemFontOfSize:13 weight:0.5];
//    [self.view addSubview:_groupname];

//搜索按钮
//    self.searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 124, SCREEN_WIDHN-30, 33)];
// self.searchbtn.backgroundColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1];
//      [self.searchbtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    
//    self.searchbtn.titleLabel.font=[UIFont systemFontOfSize:13 ];
//    [self.searchbtn setTitle:@"我要加入(搜索)" forState:UIControlStateNormal];
//    self.searchbtn.layer.cornerRadius=5;
//    self.searchbtn.clipsToBounds=YES;
//    [self.view addSubview:_searchbtn];
//    [self.searchbtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
}
//搜索事件
-(void)search{
    
    

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];

    [dic setObject:_whatname forKey:@"groupnum"];
  NSString * uurl= @"http://115.159.195.113:8000/37App/index.php/hobby/index/search";
    [manager POST:uurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSDictionary *qqq = responseObject;
      if ([@"200" isEqualToString:[qqq objectForKey:@"code"]]) {
            
            self.mygrouArr=[qqq objectForKey:@"data"];
            [self.mygroup reloadData];
        }else{
             self.mygrouArr=[qqq objectForKey:@"data"];
             [self.mygroup reloadData];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有找到相关群组" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
        }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"shibai");
 
    }];
//    else{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入群名称或群号" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alert addAction:action1];
//        [self  presentViewController:alert animated:YES completion:nil];
//    
//    
//    }


//
}

//键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}


//群组列表
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //行数
    return _mygrouArr.count;
    
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"go"];
    if (cell==nil) {
        cell=[[DLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"go"];
        
    }
    
     [  cell.grouppic sd_setImageWithURL:[_mygrouArr[indexPath.row] objectForKey:@"group_img" ] placeholderImage:[UIImage imageNamed:@"addfinal"]];
    cell.groupnum.backgroundColor=nil;
    cell.groupnum.tag=indexPath.row;
    
    cell.groupname.text=[_mygrouArr[indexPath.row] objectForKey:@"group_name" ];
    [cell.groupnum addTarget:self action:@selector(AddGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(void)AddGroup:(UIButton *)sender{
    
    BOOL can=YES;
    
//判断是否存在
    for (int i=0; i<_HaveGroup.count; i++) {
        if ([[_HaveGroup[i] objectForKey:@"group_id"] isEqualToString:[_mygrouArr[sender.tag] objectForKey:@"group_id" ]] ) {
            //存在不加
            can=NO;
            //已存在群组
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你已经是该群组成员啦" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"纳尼?" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:action1];
            [self  presentViewController:alert animated:YES completion:nil];
            
        }
        
        
    }
    
    if (can) {
        
    
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *squserid = [SQUserid objectForKey:@"userid"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:squserid forKey:@"userid"];
    [dic setObject:[_mygrouArr[sender.tag] objectForKey:@"group_id" ] forKey:@"groupid"];
    [dic setObject:@"0" forKey:@"type"];
    [dic  setObject:[_mygrouArr[sender.tag] objectForKey:@"group_maker" ]  forKey:@"maker"];
    NSString *go=@"http://115.159.195.113:8000/37App/index.php/hobby/friend/addgroup";
    [manager POST:go parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *haha = responseObject;
     
        NSLog(@"%@",haha);
        //        NSLog(@"%@",_homeArr);
  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"(没有返回值)---");
    }];
    
   
    [sender setBackgroundImage:nil forState:0];
    [sender setTitleColor:[UIColor lightGrayColor] forState:0];
    sender.titleLabel.font=[UIFont systemFontOfSize:12];
    [sender setTitle:@"已发送" forState:0];
        sender.enabled=NO;}
    
}

-(void)leftaction:(UIButton * )sender{
    
    [self.navigationController popViewControllerAnimated:YES];
//    //显示下方TARBAR
//    //
//    self.tabBarController.tabBar.hidden=NO;
//    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.mid.hidden = NO;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //快速变色
    GroupdetailViewController *vc=[[GroupdetailViewController alloc]init];
    vc.grid=[_mygrouArr[indexPath.row] objectForKey:@"group_id" ];
    vc.grnum=[_mygrouArr[indexPath.row] objectForKey:@"group_number"];
    vc.grname=[_mygrouArr[indexPath.row] objectForKey:@"group_name" ];
    vc.grsign=[_mygrouArr[indexPath.row] objectForKey:@"group_sign" ];
    vc.Vic=YES;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
