
* 将所有请求的hosName/path/都封装起来，不像其他类暴露

大体逻辑顺序:

	> MKNetworkEngine维护一个NSOperationQueue(单例+静态)
	> MKNetworkEngine.NSOperationQueue添加多个MKNetWorkOperation操作
	> 一个MKNetWorkOperation操作, 内部又封装了一个NSMutableURLRequest请求对象
	> 将MKNetWorkOperation操作, 加入MKNetworkEngine.NSOperationQueue

1. MKNetworkEngine
	
	1) 一个MKNetworkEngine <--> 一个hostName(主机域名 -- 根路径) 		eg. /192.189.2.1/ 或 www.baidu.com/
		> 封装这个hostName下面所有child path的请求操作

	2) static NSOperationQueue *_sharedNetworkQueue 
			--> 静态单例NSOperationQueue队列 ,包含多个MKNetWorkOperation操作
			--> 一个MKNetworkOperation操作 , 包含一个NSMutableURLRequest请求对象
					(MKNetworkOperation -- 继承NSOperation，实现NSURLConnectionDataDelegate代理)

			
			eg.
				//path - hostName/子路径/
				//params - 访问改请求url，所需要提交的参数
				//httpMethod - Get/Post
				//SSL - 是否使用https:协议
				- (MKNetworkOperation *)oeprationWithPath:(NSString *)path
												   params:(NSDictionary *)dict
											   httpMethod:(NSString *)method 
											   SSL:(bool)ssl{
					//do somegthing

					//1. 构造完整URL
					NSString url = http://hostName/path/参数拼接 或者 https://hostName/path/参数拼接

					//2. 创建当前继承自MKNetWorkOperation子类的对象
					MKNetworkOperation *operation = [[self.customOperationSubclass alloc] initWithURLString:urlString params:body httpMethod:method];

					//2.1 在MKNetWorkOperation的init函数中, 创建了一个NSMutableURLRequest请求对象
					(
						* 在MKNetWorkOperation.initWithURLString:..函数中
						//1. 根据url创建NSMutableURLRequest
						//2. 设置请求get/post
						//3. 设置当前MKNetWorkOperation对象.state = MKNetworkOperationStateReady
					)

					//3. 给每一个MKNetWorkOperation对象, 做缓存 --> 给每一个MKNetWorkOperation对象，分配一个唯一的标示uniqueIdentifier
					(
						//1. 直接从MKNetworkEngine.memoryCache:(NSMutableDictionaet *)中查找 - 根据标示符uniqueIdentifier
						//2. 从本地文件读入,得到cacheData:(NSData *)
					)

					//4. 给MKNetWorkOperation对象, 设置回调代码块block --> 在请求完成/失败时候，回调执行
					(
						[MKNetWorkOperation对象 addCompletionHandler:请求完成执行的代码 errorHandler:请求失败执行的代码];

						//注意: block使用copy
					)

					//5. 把MKNetWorkOperation对象加入到MKNetworkEngine.NSOperationQueue队列中, 等待执行
					[MKNetworkEngine对象  enqueueOperation:op];
					(
						在enqueueOperation方法中

						1. 设置回调的保存缓存的代码块
						[operation setCacheHandler:(^)(MKNetworkOperation* completedCacheableOperation) {
							//将请求完成后的responseData:(NSData *)保存到缓存
							//1. 内存
							//2. 本地文件
						}];

						2.
						[_sharedNetworkQueue addOperation:operation];
					)

				}


	3) dispatch_queue_t backgroundCacheQueue -- 缓存队列

	4) dispatch_queue_t operationQueue -- 请求队列


	2. MKNetworkOperation

		1) 接受回调block
		typedef void (^block类项名字)(NSURLResponse *response, NSData *data, NSError *error);

		2) 在ios sdk的回调代码块中，执行接收的block

		3) 并将接收到的服务器数据，做为blokc的参数




