//
//  MeViewController.m
//  CSProduct
//
//  Created by zhiwei jiang on 2017/11/28.
//  Copyright © 2017年 zhiwei jiang. All rights reserved.
//

#import "CSMeViewController.h"
#import "CSMeCell.h"
#import "CSMeHeadView.h"
#import "CSMeFootView.h"
#import "CSMeBusinessManage.h"
#import "CSPersonInfoViewController.h"

@interface CSMeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CSMeBusinessManage *busnissManage;
    CSMeHeadView *headView;
    CSPersonInfoModel *selfInfoModel;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *tableViewDataArray;

@end

@implementation CSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewDataArray = [NSArray array];
    [self tableView];
    [self headViewShowWithModel:nil];
    [self footViewShow];
    [self dataLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data Loading
- (void)dataLoading{
    
    busnissManage  = [[CSMeBusinessManage alloc] init];
    busnissManage.userID = [CSDataSave getUserID];
    
    @weakify(self);
    [self.view showHUD];
    [busnissManage getMeViewShowDataWithBlock:^(NSArray *cellDataArray, CSPersonInfoModel *model, NSString *errorStr) {
        @strongify(self);
        [self.view hideHUD];
        if (errorStr.length) {
            [self.view makeToast:errorStr];
        }
        if (model) {
            selfInfoModel = model;
            [self headViewShowWithModel:model];
        }
        if (cellDataArray) {
            self.tableViewDataArray = cellDataArray;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UI Sets
/**
 主视图view
 */
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.bounces = NO;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        // 注册cell
        [_tableView registerClass:[CSMeCell class] forCellReuseIdentifier:kCSMeCell_ID];
        
    }
    return _tableView;
}

#pragma mark - tableview Delegate !
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSDictionary * dictModel = [self.dataArray objectAtIndex:indexPath.section];
    CSMeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCSMeCell_ID];
    if (self.tableViewDataArray.count) {
        [cell setTitleWithStr:self.tableViewDataArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CSPersonInfoViewController *personInfoVC = [[CSPersonInfoViewController alloc] init];
        personInfoVC.personId = [CSDataSave getUserID];
        [self.navigationController pushViewController:personInfoVC animated:YES];
    }
}

#pragma mark - headViewShow
- (void)headViewShowWithModel:(CSPersonInfoModel *)model{
    
    headView = [[CSMeHeadView alloc] initWithFrame:CGRectMake(0, 0, CSScreenWidth, CSScreenWidth*2/3.0)];
    [headView setHeadModel:model];
    [self.tableView setTableHeaderView:headView];
}

#pragma mark - footViewShow
- (void)footViewShow{
    CSMeFootView *footView = [[CSMeFootView alloc] initWithFrame:CGRectMake(0, 0, CSScreenWidth, 100.f)];
    footView.outLoginBlock = ^(BOOL isClick) {
        NSLog(@"点击了退出按钮！！！");
        CSDataSave *info = [[CSDataSave alloc] init];
        info.isLogin = NO;
        [CSDataSave encodeWithModel:info];
        [LoginViewController loginaWithCtl:self];
    };
    [self.tableView setTableFooterView:footView];
}


@end
