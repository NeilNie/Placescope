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
    
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
        
    }
    UserList *list = [result objectAtIndex:indexPath.row];
    cell.name.text = list.name;
    cell.location.text = list.location;
    
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table.dataSource = self;
    self.table.delegate = self;
    result = [UserList allObjects];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
