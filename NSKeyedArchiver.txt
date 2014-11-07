把一个对象数组，归档存储到本地文件

Person * p1 = [[Person alloc] init]; 
NSArray *Array = [NSArray arrayWithObjects:str, astr, nil];  
       
//保存数据  
NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; NSString *filename = [Path stringByAppendingPathComponent:@"test.plist"];  
[NSKeyedArchiver archiveRootObject:Array toFile:filename];  
       
str = @"a";  
astr = @"";  
       
//加载数据  
NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];  
str = [arr objectAtIndex:0];  
astr =  [arr objectAtIndex:1]; 