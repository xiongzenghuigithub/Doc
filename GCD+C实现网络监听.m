//.h ----------------------------------------------------------------------------------
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@class Reachability;

extern NSString * const kReachabilityNotifiation;

//-------------------使用宏判断是否ARC OR 非ARC-----------------------
//1.
#if TARGET_OS_IPHONE
	#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
		#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 6000 //iOS system version >= 6.0 支持自动释放内存
			#define NEED_DISPATCH_RETAIN_RELEASE 0
		#else
			#define NEED_DISPATCH_RETAIN_RELEASE 1
		#endif
	#endif
#endif

//2.
#if __has_feature(objc_arc)
	//ARC
#else
	//非ARC
#endif
//------------------------------------------------------------------

typedef void (^ReachableCompletion)(Reachability * reachability);
typedef void (^UnReachableCompletion)(Reachability * reachability);

typedef enum ReachState {
	UnReachable = 0,																//不可到达测试服务器域名 or IP地址
	ReachableViaWWAN,																//可到达测试服务器域名 or IP地址， 并且通过3G网络
	ReachableViaWiFi																//可到达测试服务器域名 or IP地址， 并且通过WiFi网络
}ReachdState;

@interface Reachability :  NSObject {
	
@property (nonatomic, assign) ReachdState 			   currntReachable;				//当前reachable
@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;				//根据传入的HostName或IP地址，获取到得网络连接


@property (nonatomic, copy) ReachableCompletion reachableComplet;
@property (nonatomic, copy) UnReachableCompletion notReachableComplet;

//-------------Reachability对象包含一个 SCNetworkReachabilityRef 对象 ------------
- (void)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

/** 测试是否到达的主机域名 , 返回封装了 SCNetworkReachabilityRef 对象得 Reachability 对象 */
- (Reachability)reachabilityWithHostname:(NSString *)hostName 
		 ReachableCompletion:(ReachableCompletion)reachable 
	   UnReachableCompletion:(UnReachableCompletion)unReachable;
}

/** 测试是否到达的主机IP , 返回封装了 SCNetworkReachabilityRef 对象得 Reachability 对象 */
- (Reachability)reachabilityWithIPAddress:(const struct sockaddr_in *)addr 
		 ReachableCompletion:(ReachableCompletion)reachable 
	   UnReachableCompletion:(UnReachableCompletion)unReachable;
}

/** 异步 开启针对某一个网络连接的状态变化监听 (需要传入一个SCNetworkReachabilityRef 对象) */
- (void)startObserveAtReachability;

/** 异步 关闭针对某一个网络连接的状态变化监听 */
- (void)stopObserveAtReachability;

@end

//.m ----------------------------------------------------------------------------------

NSString * const kReachabilityNotifiation = @"kReachabilityNotifiation";

@interface Reachability () {

//---------------- ARC: strong+weak , 非ARC:retain+assign-------------------
	#if NEED_DISPATCH_RETAIN_RELEASE 
		@property (nonatomic, assign) dsipatch_queue_t reachabilityQueue;
		@property (nonatomic, assign) dispatch_group_t group;
	#else
		@property (nonatomic, strong) dsipatch_queue_t reachabilityQueue;
		@property (nonatomic, strong) dispatch_group_t group;
	#endif
//--------------------------------------------------------------------------

		@property (nonatomic, strong) Reachability * reachabilityOBJ;
}

@end

@implementation

//------------------------dealloc方法释放所有对象指针--------------------------
- (void)dealloc {
	self.reachableComplet = nil;
	self.notReachableComplet = nil;

	#if NEED_DISPATCH_RETAIN_RELEASE
		dispatch_release(self.reachabilityQueue);
		dispatch_release(self.group);
	#else
		self.reachabilityQueue = nil;
		self.group = nil;
	#endif

	self.reachabilityOBJ = nil;
}

- (void)initWithReachabilityRef:(SCNetworkReachabilityRef)ref {
	if (self = [super init])
	{
		self.reachability = [[Reachability alloc] initWithReachabilityRef:ref];
		return self;
	}
	return nil;
}

+ (Reachability)reachabilityWithHostname:(NSString *)hostName 
			 ReachableCompletion:(ReachableCompletion)reachable 
		   UnReachableCompletion:(UnReachableCompletion)unReachable 
{
	//1. 获取网络连接
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL , [hostName UTF8String]);

	//2. 将网络连接保存到一个创建的Reachability对象
	if (reachabilityRef != NULL)
	{
		Reachability * reachability = [[Reachability alloc] initWithReachabilityRef:reachabilityRef];
		reachability.reachableComplet = [reachable copy];
		reachability.notReachableComplet = [unReachable copy];
	}
	return nil;
}

- (Reachability)reachabilityWithIPAddress:(const struct sockaddr_in *)addr  
		 ReachableCompletion:(ReachableCompletion)reachable 
	   UnReachableCompletion:(UnReachableCompletion)unReachable 
{
	//1. 获取网络连接
	SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, const struct sockaddr *)addr);
	
	//2. 将网络连接保存到一个创建的Reachability对象
	if (reachability != NULL)
	{
		Reachability * reachability = [Reachability alloc] ]initWithReachabilityRef:reachabilityRef;
		reachability.reachableComplet = [reachable copy];
		reachability.notReachableComplet = [unReachable copy];
	}
	return nil;
}

//异步开启监听 --> 先将要监测的连接放入队列排队
- (void)startObserveAtReachability {

	//1. retain一次self
	self.reachabilityOBJ = self;
	
	//2. context
	SCNetworkReachabilityContext ctx = {0, NULL, NULL, NULL};
	ctx.info = (__bridge void*)self.reachabilityOBJ;

	//3. if not reachable
	if (self.reachabilityRef == NULL)
	{	
		self.reachabilityOBJ = nil;//release一次reachabilityOBJ指针
	}

	//4. init group and queue
	if (self.group == nil)
	{
		self.group = dispatch_group_create();
	}

	if (self.reachabilityQueue == nil) {
		self.reachabilityQueue = dsipatch_queue_create("ReachabilityQueue" , NULL);//串行队列
	}

	//5. setting calBack (连接的状态改变是异步接收的)
	//args1:监听的网络连接
	//args2:连接的状态改变时的回调函数
	//args3:回调函数所在的对象
	if ( !SCNetworkReachabilitySetCallback(self.reachabilityRef, didGetConnecionChanged , &ctx) ) {
		self.reachabilityOBJ = nil;
	}

	//6. 异步开启 监听网络连接 -- 将要监听的连接放入队列，等待执行监听
	SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilityQueue);//该方法会对self.reachabilityQueue指针进行retain

	//7. release之前被retain的指针
	self.reachabilityOBJ = nil;
}

//异步关闭监听 --> 先将要关闭监测的连接放入队列排队
- (void)stopObserveAtReachability {

	//1. call back
	SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);

	//2. init reachabilitRef queue
	if (self.reachabilityQueue == nil)
	{
		self.reachabilityQueue = dsipatch_queue_create("reachabilityQueue", NULL);
	}

	//3. 将要关闭的监听的连接放入队列等待
	if ( !SCNetworkReachabilitySetDispatchQueue(self.reachabilitRef , self.reachabilityQueue) ) {//失败
		self.reachabilityOBJ = nil;
	}

	//4. release被retain的指针
	self.reachabilityOBJ = nil;
}

//--------------------监听的网络连接状态改变时的回调函数------------------------
//args1:传入的发生状态改变的网络连接
//args2:保存网络连接的结果数据
//args3:回调函数所在的对象
void didGetConnecionChanged(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) 
{
#pragma unused(target)//不产生未使用的警告信息

	//对回调函数中得值，自动释放让其延迟释放
	#if NEED_DISPATCH_RETAIN_RELEASE 
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			Reachability * reachability = (__bridge Reachability*)info;
			[reachability reachabilityRefChanged:flags];
		[pool rlease];
	#else
		@autorelease {
			Reachability * reachability = (__bridge Reachability*)info;
			[reachability reachabilityRefChanged:flags];	//执行回调函数
		}
	#endif
}	

//状态改变后回调
- (void)reachabilityRefChanged:(SCNetworkReachabilityFlags)flags {

	//1. 执行Block代码，并填充参数值
	if ([self isReachableWithFlags:flags]) {
		self.reachableComplet(self);
	}
	else {
		self.notReachableComplet(self);
	}

	//2. 发送通知告诉app，网络状态已经发送变化 
	dispatch_async(dispatch_get_main_queue(), ^() {
		NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
		[center postNotificationName:kReachabilityNotifiation object:self];
	});
}




@end