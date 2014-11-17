
#import <objc/runtime.h>
-----------------------------------------

//1. 获取方法
SEL sel =  NSSelectorFromString(@"test:args2:args3:");

//2. performSelector方法
[self performSelector:<#(SEL)#> withObject:<#(id)#> withObject:<#(id)#> withObject:<#(id)#>];

//3. self的test方法
- (void)test:(NSString *)xx args2:(NSString *)yy args3:(NSString *)zz{
    
}

//4. 注意: performSelector这个方法后面跟的 withObject:<#(id)#> 个数与 NSSelectorFromString(@"test:args2:args3:");中的方法标签个数有关
	> 这个方法 test:args2:args3:
		> test:
		> args2:
		> args3:

		这三个方法标签，所以需要三个参数

-----------------------------------------

Class class = NSClassFromString(@"类名字符串");

NSString * classString = NSStringFromClass([对象 class]);
NSString * classString = NSStringFromClass([类 class]);

-----------------------------------------
mutaCopy : 拷贝出来的是可变的 数组、字典、字符串 .. 

NSDictionary * dict = @{@"name":@"zhangsan"};
NSMutableDictionary * mutaCopy = [dict mutableCopy];
mutaCopy[@"newKey"] = @"newValue";

-----------------------------------------
获取一个类的所有方法

	u_int count;
    Method* methods= class_copyMethodList([类 class], &count);
    for (int i = 0; i < count ; i++)
    {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name)encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strName);
    }
-----------------------------------------
获取一个类的所有属性

	u_int count;
    objc_property_t *properties=class_copyPropertyList([UIViewControllerclass], &count);
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);//获取属性名字
        NSString *strName = [NSString stringWithCString:propertyNameencoding:NSUTF8StringEncoding];

        
    }

-----------------------------------------
判断类的某个属性的类型






