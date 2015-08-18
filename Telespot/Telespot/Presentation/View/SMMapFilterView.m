//
//  WXMapFilterView.m
//  Wheelx
//
//  Created by JG on 12/4/14.
//  Copyright (c) 2014 JG. All rights reserved.
//
#import "SMMapFilterView.h"
#import "Masonry.h"
#import "AppMacros.h"
#import "SMMapFilterViewCell.h"
#import "SMConstants.h"

#define SKATEPARK 0
#define POST 1
#define CLOCKPIN 2
#define MYPEEK 3

@interface SMMapFilterView()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString * plistPath;

@end

@implementation SMMapFilterView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

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
    

    
    
    
}

#pragma mark --TableView source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistPath];
    NSString * key;
    if(indexPath.row == 0)
        key = KTSPParkProperty;
    else
        key = KTSPPinProperty;
    
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
        cell.lableText.text = @"Pin";
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
@end





