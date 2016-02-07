//
//  List.m
//  Placescope
//
//  Created by Yongyang Nie on 1/9/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "List.h"

@interface List ()

@end

@implementation List

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [result count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];

    UILabel *name = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *location = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *type = (UILabel *)[cell.contentView viewWithTag:3];
    UserList *list = [result objectAtIndex:indexPath.row];
    name.text = list.name;
    location.text = list.location;
    type.text = list.type;
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.dataSource = self;
    self.table.delegate = self;
    result = [UserList allObjects];
    [self.table reloadData];
    NSLog(@"all objects %@", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
