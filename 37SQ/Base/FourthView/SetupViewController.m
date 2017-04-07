//
//  SetupViewController.m
//  37SQ
//
//  Created by administrator on 16/10/16.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "SetupViewController.h"
#import "SetupTableViewCell.h"
#import "FBYMyNav.h"
#import <RongIMKit/RongIMKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SetupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView *setupTable;

@property(strong,nonatomic)FBYMyNav *nav;

@property(strong,nonatomic)NSArray *firstArr;

@property(strong,nonatomic)NSArray *secondArr;

@property(strong,nonatomic)NSArray *thirdArr;

@property(strong,nonatomic)NSArray *contentArr;

//清除缓存
@property(strong,nonatomic)NSString *message;

@property(strong,nonatomic)NSString *absolutePath;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.nav = [[FBYMyNav alloc]initWithTitle:@"设置" andWithByImg:@"NAV" andWithLetBtn1:@"backfby" andWithLeftBtn2:nil andWithRightBtn1:nil andWithRightBtn2:nil];
    
    [self.nav.leftBtn1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];

    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    if (userid == nil) {
        self.setupTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 245)];
    }else{
        self.setupTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 285)];
    }

    self.setupTable.backgroundColor = [UIColor whiteColor];
    self.setupTable.delegate = self;
    self.setupTable.dataSource = self;
    
    self.firstArr = @[@"清除缓存"];
    self.secondArr = @[@"联系我们"];
    self.thirdArr = @[@"当前版本",@"核心组件",@"启动组件"];
    self.contentArr = @[@"37SQ1.0",@"6.1.6",@"1783c58ec9364161106"];

    [self.view addSubview:_setupTable];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *userid = [SQUserid objectForKey:@"userid"];
    if (userid == nil) {
        return 3;
    }else{
    return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return _firstArr.count;
    }else if (section == 1){
    
        return _secondArr.count;
    }else if(section == 2){
        
        return _thirdArr.count;
        
    }else{
    
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

//cell 点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
            
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            
            NSLog(@"files :%lu",(unsigned long)[files count]);
            if ((unsigned long)[files count]==0||(unsigned long)[files count]==1) {
                self.message=@"已经清理干净";
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:self.message preferredStyle:(UIAlertControllerStyleAlert)];
                
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
                [alert addAction:cancel];
                [self showDetailViewController:alert sender:nil];
            }
            else{
                self.message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM, 删除缓存", size] : [NSString stringWithFormat:@"缓存%.2fK, 删除缓存", size * 1024.0];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:self.message preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self clearCaches];
                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
                [alert addAction:action];
                [alert addAction:cancel];
                [self showDetailViewController:alert sender:nil];
            }
        }
        
        
    }else if (indexPath.section == 1){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"使用中有任何问题,请发邮件到" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];

        
    }else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {

            NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
            NSString *userid = [SQUserid objectForKey:@"userid"];
        
        if (userid == nil) {
            
            
            
        }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
            [SQUserid setObject:nil forKey:@"userid"];
             [SQUserid setObject:nil forKey:@"usertoken"];
            [SQUserid synchronize];
            [[RCIMClient sharedRCIMClient]logout];
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
        }
        
        }
    }
    
    
    
}

//清除缓存 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            self.absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:_absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)clearCaches{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       
                       for (NSString *p in files) {
                           
                           NSError *error;
                           
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [ self performSelectorOnMainThread : @selector (clearCacheSuccess)  withObject : nil waitUntilDone : YES ];}
                   
                   );
    
}
-(void)clearCacheSuccess{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"清理完成" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
    [alert addAction:action];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[SetupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    if (indexPath.section == 0) {
        cell.setupLab.text = _firstArr[indexPath.row];
        cell.nextImg.image = [UIImage imageNamed:@"next"];
        
        cell.setupLab3.text = nil;
        cell.contentLab3.text = nil;
        cell.leaveLab.text = nil;
    }else if (indexPath.section == 1){
     
        cell.setupLab.text = _secondArr[indexPath.row];
        cell.nextImg.image = [UIImage imageNamed:@"next"];
        
        cell.setupLab3.text = nil;
        cell.contentLab3.text = nil;
        cell.leaveLab.text = nil;
        
    }else if(indexPath.section == 2){
    
        cell.setupLab3.text = _thirdArr[indexPath.row];
        cell.contentLab3.text = _contentArr[indexPath.row];
        
        cell.setupLab.text = nil;
        cell.nextImg.image = nil;
        cell.leaveLab.text = nil;
    }else{
        
        cell.leaveLab.text = @"退出登录";
        
        cell.setupLab3.text = nil;
        cell.contentLab3.text = nil;
        
        cell.setupLab.text = nil;
        cell.nextImg.image = nil;

    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 3) {
        return 0;
    }else if(section == 2){
    
        NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
        NSString *userid = [SQUserid objectForKey:@"userid"];
        if (userid == nil) {
            return 0;
        }else{
            return 15;
        }
        
    }else {
        
    return 15;
        
    }
}

//导航栏返回
- (void)back:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
