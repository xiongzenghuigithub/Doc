> Block中得引发 retain cycle 错误

	> Block是什么？
		> 一个NSObject对象
		> 存在创建，释放等声明周期、
		> 也可以被一个该Block类型的变量所持有
		> 所以，Block就跟一般的对象，没有什么区别，所以也会产生内存不释放的问题


	> eg.1 - 非ARC下
	
	//下面这段代码会造成
		1. manager.complete变量持有Block对象
		2. Block对象又持有Manager对象
			> 相互持有, 形成2个都不能释放
	DoSomethingManager *manager = [[DoSomethingManager alloc] init];  
	manager.complete = ^{  
	    //...complete actions  
	    [manager otherAction];  
	    [manager release];  
	};  

	> 解决: 使Manager对象/Block对象 任一方，取消对另一方的持有

	DoSomethingManager *manager = [[DoSomethingManager alloc] init];  
	manager.complete = ^{  
		
		//1. block执行代码 
	    [manager otherAction];  

	    //2. 业务逻辑执行完后, 让Manager对象, 取消对当前Block对象的引用(持有/指向)
		manager.complete = nil;

		//3. 让Manager对象释放 --> Block对象跟着也会被释放
	    [manager release];  
	};  


	> eg.2 - ARC下

		> 使用 __weak、__block 修饰将要在Block内部使用的变量

		Manager * manager = [[DoSomethingManager alloc] init];  

		//复制一个weak指针指向Manager对象
		weak Manager * weak_manager = manager;

		manager.complete = ^{  

			//Block内部，使用Manager对象的weak指针变量
			[weak_manager otherAction];  
		}
