//
//  SMMapFilterViewController.m
//  Spot Maps
//
//  Created by JG on 4/13/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMMapFilterViewController.h"
#import "SMMapFilterViewCell.h"
#import "SMConstants.h"

@interface SMMapFilterViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString * plistPath;

@end

@implementation SMMapFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.frame = CGRectMake(0, 0, 300, 300);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)plistPath
{
    if(_plistPath == nil)
    {
        //判断应用路径下面是否有plist,没有则拷贝bundle里面的进去，不能直接写bundle里面的东西
        BOOL success;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _plistPath = [documentsDirectory stringByAppendingPathComponent:@"SMFilterProperty.plist"];
        success = [fileManager fileExistsAtPath:_plistPath];
        if (!success)
        {
            NSError *error = [NSError new];
            // The writable database does not exist, so copy the default to the appropriate location.
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SMFilterProperty.plist"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:_plistPath error:&error];
        }
    }
    return _plistPath;
}


- (void) storageFilterSetting
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistPath];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.selectBoxSelected)
    {
        [data setObject:@YES forKey:KTSPParkProperty];
    }
    else
    {
        [data setObject:@NO forKey:KTSPParkProperty];
    }
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectBoxSelected)
    {
        [data setObject:@YES forKey:KTSPPinProperty];
    }
    else
    {
        [data setObject:@NO forKey:KTSPPinProperty];
    }
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectBoxSelected)
    {
        [data setObject:@YES forKey:KTSPSpotProperty];
    }
    else
    {
        [data setObject:@NO forKey:KTSPSpotProperty];
    }
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectBoxSelected)
    {
        [data setObject:@YES forKey:KTSPShopProperty];
    }
    else
    {
        [data setObject:@NO forKey:KTSPShopProperty];
    }

    
    [data writeToFile:self.plistPath atomically:YES];
    
}

- (void)restoreFilterSetting
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistPath];
    if([[data objectForKey:KTSPParkProperty] boolValue])
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = YES;
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = NO;
    }
    
    if([[data objectForKey:KTSPPinProperty] boolValue])
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = YES;
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = NO;
    }
    
    if([[data objectForKey:KTSPSpotProperty] boolValue])
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = YES;
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = NO;
    }
    
    if([[data objectForKey:KTSPShopProperty] boolValue])
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = YES;
    }
    else
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.selectBoxSelected = NO;
    }
    
    
    
}

#pragma mark --TableView source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistPath];
    NSString * key;
    if(indexPath.row == 0)
        key = KTSPParkProperty;
    else if(indexPath.row == 1)
        key = KTSPPinProperty;
    else if(indexPath.row == 2)
        key = KTSPSpotProperty;
    else if(indexPath.row == 3)
        key = KTSPShopProperty;
    
    SMMapFilterViewCell * filterCell = (SMMapFilterViewCell *)cell;
    
    if([[data objectForKey:key] boolValue])
    {
        filterCell.selectBoxSelected = YES;
    }
    else
    {
        filterCell.selectBoxSelected = NO;
        
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMMapFilterViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMMapFilterViewCell" owner:self options:nil] objectAtIndex:0];
    if(indexPath.row == 0)
    {
        cell.lableText.text = @"滑板场";
    }
    else if(indexPath.row == 1)
    {
        cell.lableText.text = @"活动者";
    }
    else if(indexPath.row == 2)
    {
        cell.lableText.text = @"地形";
    }
    else if(indexPath.row == 3)
    {
        cell.lableText.text = @"滑板店";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

#pragma mark --TableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMMapFilterViewCell * cell = (SMMapFilterViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectBoxSelected = !cell.selectBoxSelected;
    
    [self storageFilterSetting];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
