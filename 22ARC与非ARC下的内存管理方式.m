ARC下的内存管理:

	1.  __weak 、__block 修饰要在Block中使用的对象指针，不造成对对象的retain操作

	2. 对 对象进行retain ==》增加一个指针（强指针）指向该对象
	3. 对 对象进行release==》将之前增加的指向对象指针 = nil

	4. Block的内存管理
			>  为nil
			>  Block内部使用完外部的对象指针后，需要把指针 = nil，解决Block与对象的循环引用

	5. 使用别人传递过来的某个对象时
			> 先增加新指针指向该对象
			> 使用新指针调用对象的方法
			> 完毕后让 新指针 = nil	

	6. 当前对象将自己的某个对象属性，返回给别的对象使用，需要autorease延迟释放，让接收方释放
			@autorelease {
				//
			}	

	7. dealloc方法
			> 成员变量指针 = nil
			> 增加指针引用的对象指针 = nil
			> 对象.delegate = nil
			> 对象 removeObserver:forKeyPath:


非ARC下的内存管理:

	1.  1)指针 = alloc出对象，2)使用指针，3)[release 指针]
	
	2. setXxx方法:
			>  判断传入的对象是否等于现在持有的对象
					> 不等于:  
							> release 旧的对象指针
							> retian 新传入的对象指针
	
	3. 当前对象将自己的某个对象属性，返回给别的对象使用，需要autorease延迟释放
			> return  [对象 autorelease];

	其他的同ARC:
		> release   ==> 指针 = nil
		> retain 	==>   增加指针指向对象
		> return [obj autorease] ==> @autorelease { … };

	4. 都需要在dealloc方法中释放内存
			> ARC， 不再需要写 [super dealloc]

