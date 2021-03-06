/**< 自定义queue，默认串行： NULL == DISPATCH_QUEUE_SERIAL*/

    dispatch_queue_t queue = dispatch_queue_create("label", NULL);    
    dispatch_async(queue, ^{
        NSLog(@"test");
    });
 
/**< 自定义queue，并行(DISPATCH_QUEUE_CONCURRENT)或串行(或DISPATCH_QUEUE_SERIAL) */
    dispatch_queue_t serial_queue = dispatch_queue_create("标签", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(serial_queue, ^(){

		// 尽管为异步调用且延迟3秒，但如果在serial队列中，block_1仍然先于block_2被打印出来,因为2个block任务都是在串行队列

        sleep(5);
        NSLog(@"block_1"); 
    });
    dispatch_async(serial_queue, ^(){
        NSLog(@"block_2");
    });
     
/**< 延迟执行*/
    /**< (int64_t)(delayInSeconds * NSEC_PER_SEC)：转换成毫秒*/
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"5s delay");
    });
     
/**< 常用的异步并发执行*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{
        sleep(5);//睡眠
        NSLog(@"block_1");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{
        NSLog(@"block_2");
    });
   
/**< 异步并回调主线程，常用ui更新*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT , 0), ^{//自定义队列

		//1. 做下载、存取数据库 ... 耗时代码

		//2. 往主队列异步执行修改UI的Block
        dispatch_async(dispatch_get_main_queue(), ^{
             //修改UI的数据
        });
    });
