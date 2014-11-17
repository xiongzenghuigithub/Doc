> 1. 异步执行请求
> 2. 接受回调的代码块-Block
> 3. 在回调的代码块Block中，传递加载到得服务器json


//1. get请求

//参数 1.url ,2.参数 ,3.回调block
- (void)getWithUrl:(NSString *)url 
		paramaters:(NSDictionary *)param 
   completeHandler:(void (^)(NSURLResponse *resp ,NSData *data ,NSError *error))handler {

   		//1.使用缓存 
   			> NSURLCache
   			> json保存到本地
   			> 将加载的数据NSData保存到本地Cache目录文件


   		//2.NSURLConnection sendAsyncChronousRequest
   			> NSOperationQueue 请求队列 - 全局单例存在

        [NSURLConnection sendAsynchronousRequest:request
                               queue:[RequestCenter sharedQueue]
                               completionHandler:^(NSURLResonse *response, NSData *data, NSError *error){
                        
            //mainQueue中，丢更新UI的block代码
            dispatch_async(dispatch_get_main_queue(),^{
                
                    if(handler) {
                        
                        //执行handler - 回调block, 并填充block需要的参数
                        handler(response,data,error);   
                    }
                });
          }];  
   }
