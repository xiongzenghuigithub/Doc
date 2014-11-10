-------------------------lldb调试命令--------------------------
1. p 基本数据类型

	> p (CGRect)[[self view] frame]
	> p (CGPoint)[[self view] center]
	> p (int)[[[self view] subviews] count]


2. po 对象
	
	> po self
	> po 自定义对象指针
	> po [[self view] subviews]
	> po jsonDict

3. fr v 显示当前断点所在代码块内的所有信息 (类名、方法名、该方法内所有的变量值)
	> fr v            :  显示断点之前所有的信息
	> fr v 某一个变量   :  显示某一个变量的信息
	> fr info         :  显示当前的断点位置

4. 断点命令
	> br l  			: 列出所有断点位置
	> br del 断点id		: 删除某个断点
	> br del 			: 回车后选择Y ， 删掉所有断点
	> br num
	> c 				: 过掉当前断点
	> s        			: 进入断点处调用的方法内部

5. 

6. 打印当前view的层级结构
	
	> po [[self view] recursiveDescription]
	> po [某一个View recursiveDescription]

7. expr执行代码

	> 指定格式化输出断点之前的多个变量值
		> expr (void)NSLog(@"args1 = %@ , args2 = %@\n" , args1 , args2)

	> 给view添加border , 以便于找到位置
		> expr [某个View.layer setBorderWidth:5]

	> 动态改变变量的值 , 以便测试多种数据
		> expr 变量名 = （ 整数值 / BOOL值 / NSString值 / 对象 ）



-------------------------断点--------------------------

1. 逐行打断点、逐个方法打断点、依次过点断点、fr v

2. 设置全局异常  --》 快速定位错误代码位置

3. 设置条件断点

4. 设置格式化输出断点

-------------------------日志框架--------------------------
1. 使用CocoaLumberjack分级别日志框架



