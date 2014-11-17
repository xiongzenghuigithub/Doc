

//1. SCNetworkReachabilityRef
NSString * hostName = @"www.baidu.com";
SCNetworkReachabilityRef * reachibilityRef = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String])
if (!reachibilityRef)
{
    //主机不可达，连接失败
    return;
}

//2. 开启监听
SCNetworkReachabilityContext ctx = {0 ,NULL, NULL, NULL, NULL};
ctx.info = (__brige void*)self;
dispatch_queue_t queue = dispatch_queue_create("queue" , NULL);
SCNetworkReachabilitySetCallback(reachibilityRef , 回调函数 , &ctx);
SCNetworkReachabilitySetDispatchQueue(reachibilityRef , queue);


------------------------------------------------------------------------------------------------

//3. 回调函数 - 接受网络连接状态改变

void 回调函数 (SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) 
{
    //target: 网络连接
    //info: Reachabbility对象
    //依次判断参数flags，得到当前连接状态 , 封装到Reachability.reachabilityRef变量的值

     if(!(flags & kSCNetworkReachabilityFlagsReachable)) 不可达;

     if(flags & kSCNetworkReachabilityFlagsIsWWAN) 连接通过3G网;

     if(flags & kSCNetworkReachabilityFlagsIsWWAN) 连接通过WiFi;

     //发送通知告诉监听的对象做出回调处理
     [[NSNOtificationCenter defaultCenter] postNotificationName:@"通知名" object:info] ;
}

------------------------------------------------------------------------------------------------

//4. 接收到通知 - 从通知中取出Reachability对象

根据Reachabbility对象.保存的当前网络可达情况，做出不同的处理