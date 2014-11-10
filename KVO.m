KVO :

	1. 监听对象的某个属性
	2. 当这个属性的值发生变化时
	3. 回调指定的函数


eg. Person类:

@interface Person : NSObject 

@property (nonatomic, copy) NSString * name;

@end

//1. 监听Person对象的name属性
Person * p = [[Person alloc] init];

[p  addObserver:类或对象 															//观测属性变化的 类或对象
	forKeyPath:@"监听的属性名字"  													//被观测的属性名字
	   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld		//获取新值和旧值
	   context:NULL];


//2. 使用 setValue:forKey: 设置改变的值 , 并触发回调函数
[p setValue:@"zhangsan" forKey:@"name"];

//3. 触发指定观测的 类或对象的 函数
-(void)observeValueForKeyPath:(NSString *)keyPath 
					 ofObject:(id)object 
					   change:(NSDictionary *)change 
					  context:(void *)context {



}


//5. dealloc中 ， 移除对属性的观测

- dealloc {

	[p removeObserver:self forKeyPath:@"name"];

	[super dealloc];  
}

