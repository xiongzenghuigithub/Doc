//假设已经在项目文件中创建了名为Person的对象（实体，Entity）
//首先，需要在使用Person实例类的代码头文件中加入：
 
#import <UIKit/UIKit.h> 
#import <CoreData/CoreData.h> 
#import "Person.h"
 
使用core data的简单代码，创建一个Person实体实例，保存它，然后遍历数据，相当于：select * from persons：
 
//1. 获取Person类的描述
Person *person=(Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[self managedObjectContext]]; 

person.name=@"张三";
 
NSError *error;
 
if (![[self managedObjectContext] save:&error;]) { 
    NSLog(@"error!"); 
}else { 
    NSLog(@"save person ok."); 
}
 
NSFetchRequest *request=[[NSFetchRequest alloc] init]; 
NSEntityDescription *entity=[NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managedObjectContext]]; 
[request setEntity:entity];
 
NSArray *results=[[[self managedObjectContext] executeFetchRequest:request error:&error;] copy];
 
for (Person *p in results) { 
    NSLog(@">> p.id: %i p.name: %@",p.id,p.name); 
}
 
//如果需要删除也很简单：
 
[managedObjectContext deleteObject:person];