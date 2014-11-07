对请求的url进行数据缓存

	NSString *requestURL= @"http://www.baidu.com/"; 

	//得到全局缓存对象
    NSURLCache *urlCache = [NSURLCache sharedURLCache]; 

    /* 设置缓存的大小为1M*/
	[urlCache setMemoryCapacity:1*1024*1024]; 

    //创建一个nsurl 
	NSURL *url = [NSURL URLWithString:requestURL]; 

    //创建一个请求 
	NSMutableURLRequest *request = [NSMutableURLRequest
								requestWithURL:url 
								cachePolicy:NSURLRequestUseProtocolCachePolicy
								timeoutInterval:60.0f]; 

	//查询当前NSURLRequest是否已经缓存
	//1) 已经缓存:  直接从当前缓存取出数据
	//2) 没有缓存:  重新发起请求 
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request]; 

    //判断是否有缓存 
    if (response != nil){ 

        //如果有缓存输出，从缓存中获取数据
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad]; 

    } else {

    	//重新发起异步请求

    	//1. NSURLConnection
    	[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //回调代码块
        }];

        //2. NSURLSession
        NSURLSessionConfiguration *sessionCfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionCfg delegate:self delegateQueue:queue];
        //通过session对象操作不同的api函数，进行不同的网络请求操作
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"...."]];

    }