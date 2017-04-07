//
//  GroupChooseViewController.m
//  37SQ
//
//  Created by administrator on 2016/10/30.
//  Copyright © 2016年 practice. All rights reserved.
//

#import "GroupChooseViewController.h"
#import "MyNav.h"
#import "ActionTableViewCell.h"
#import "GroupLIst_Service.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface GroupChooseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)MyNav *nav;

@property (strong, nonatomic)UITableView *myTableView;

@property (strong, nonatomic)UIView *myView;

@property (strong, nonatomic)UIButton *selectBtn;

@property (strong, nonatomic)UIButton *deleteBtn;

@property (assign, nonatomic)BOOL isEdit;

@property (strong, nonatomic)NSMutableArray *dataSource;

@property (strong, nonatomic)NSMutableArray *contacts;

@property (strong, nonatomic)NSMutableArray *groupListArr;

@property (strong, nonatomic)NSString *group_id;

@property (strong, nonatomic)NSMutableArray *groupSign;

@end

@implementation GroupChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isEdit = YES;
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.contacts = [NSMutableArray arrayWithCapacity:0];
    self.groupListArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.groupSign = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    NSUserDefaults *SQUserid = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [SQUserid objectForKey:@"userid"];
    
    //网络请求
    GroupLIst_Service *service = [[GroupLIst_Service alloc]init];
    [service searchMessage:user_id andWithAction:nil andSuccess:^(NSDictionary *dic) {
        
        NSArray *arr =  [dic objectForKey:@"data"];
        
        [self.groupListArr addObjectsFromArray:arr];
        
        NSLog(@"%@",_groupListArr);
        
        [self.myTableView reloadData];
        
    } andFailure:^(int fail) {
        
    }];

    
    self.nav = [[MyNav alloc]initWithTitle:@"选择群组" bgImg:nil leftBtn:@"backfinal" rightBtn:nil];
    [self.nav.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
    
    self.myView.backgroundColor = [UIColor whiteColor];
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 33)];
    self.myView.hidden = YES;
    
    
    self.selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2-15, 33)];
//    self.selectBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    self.selectBtn.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    self.selectBtn.layer.borderWidth=1;
    self.selectBtn.titleLabel.font=[UIFont systemFontOfSize:13 weight:0.5];
    self.selectBtn.layer.cornerRadius=5;
    self.selectBtn.clipsToBounds=YES;
    [self.selectBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 0, SCREEN_WIDTH/2-15, 33)];
//    self.deleteBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:204/255.0 blue:102/255.0 alpha:1];
    [self.deleteBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    self.deleteBtn.layer.borderColor=[UIColor colorWithRed:51/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    self.deleteBtn.layer.borderWidth=1;
    self.deleteBtn.titleLabel.font=[UIFont systemFontOfSize:13 weight:0.5];
    self.deleteBtn.layer.cornerRadius=5;
    self.deleteBtn.clipsToBounds=YES;
    [self.deleteBtn addTarget:self action:@selector(get:) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < 15; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [self.contacts addObject:dic];
        [self.dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-33) style:UITableViewStyleGrouped];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myTableView];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.view addSubview:_myView];
    [self.view addSubview:_nav];
    [self.myView addSubview:_selectBtn];
    [self.myView addSubview:_deleteBtn];
    
    [self edit];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)allSelect:(UIButton *)sender{
    
    //获取所有可用的indexPaths
    NSArray *anArrOfIndexPath = [NSArray arrayWithArray:[_myTableView indexPathsForVisibleRows]];
    //遍历indexPaths
    for (int i = 0; i < anArrOfIndexPath.count; i++) {
        NSIndexPath *indexPath = [anArrOfIndexPath objectAtIndex:i];
        //取出每个indexPaths对应的cell
        ActionTableViewCell *cell = (ActionTableViewCell*)[_myTableView cellForRowAtIndexPath:indexPath];
        NSUInteger row = [indexPath row];
        //除去每个indexPaths所对应的标识
        NSMutableDictionary *dic = [_contacts objectAtIndex:row];
        //如果点击的是全选
        if ([sender.titleLabel.text isEqualToString:@"全选"]) {
            [dic setObject:@"YES" forKey:@"checked"];//把标识改为yes
            [cell setChecked:YES];//更改cell的图片
        }else{
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
        }
    }
    //对button的标题进行更改 并把所有的标识更改 （上面更改的只是显示部分的而不是所有的）
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        for (NSDictionary *dic in _contacts) {
            [dic setValue:@"YES" forKey:@"checked"];
        }
        [sender setTitle:@"取消" forState:UIControlStateNormal];
    }else{
        for(NSDictionary *dic in _contacts){
            [dic setValue:@"NO" forKey:@"checked"];
        }
        [sender setTitle:@"全选" forState:UIControlStateNormal];
    }
    
}

- (void)edit{
    
    if (self.isEdit == YES) {
        self.isEdit = NO;
        self.myView.hidden = NO;
    }else{
        self.isEdit = YES;
        self.myView.hidden = YES;
    }
    [self.myTableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

//cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

//cell几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groupListArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ActionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.headImage sd_setImageWithURL:[_groupListArr[indexPath.row] objectForKey:@"group_img"]];
    cell.titleLabel.text = [_groupListArr[indexPath.row] objectForKey:@"group_name"];
//    cell.timesLabel.text = @"1分钟30次";
//    cell.timeLabel.text = @"1分钟";
    
    
    if (_isEdit == NO) {
        cell.confirmBtn.hidden = NO;
        NSMutableDictionary *dic = [_contacts objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
        }else{
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }
    }else{
        cell.confirmBtn.hidden = YES;
        NSMutableDictionary *dic = [_contacts objectAtIndex:indexPath.row];
        [dic setObject:@"NO" forKey:@"checked"];
        [cell setChecked:NO];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isEdit == NO) {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        //获取点击的cell
        ActionTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        
        NSUInteger row =[indexPath row];
        //获取点击cell的标识
        NSMutableDictionary *dic = [self.contacts objectAtIndex:row];
        //如果是选中改为未选中，如果是未选中改为选中
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
        }else{
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
        }
    }
    
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (void)get:(UIButton *)sender{
    
    NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:0];
    //遍历选中的数据源的index并添加到set里面
    for (int i = 0; i < _contacts.count; i++) {
        if ([self.contacts[i][@"checked"] isEqualToString:@"YES"]) {
            [indexs addIndex:i];
           
        }
    }
    //删除选中数据源 并更新tableview
    [self.dataSource removeObjectsAtIndexes:indexs];
    [self.contacts removeObjectsAtIndexes:indexs];
    
    for (int i = 0; i < indexs.count; i++) {
        [self.groupSign addObject:[_groupListArr[i] objectForKey:@"group_id"]];
    }
    
    NSArray *temp = _groupSign;
    if (_delegate!=nil&&[_delegate respondsToSelector:@selector(givemeSelectGroup:)] ) {
                [_delegate givemeSelectGroup:temp];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
