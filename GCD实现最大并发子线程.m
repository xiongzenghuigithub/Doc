/** 使用GCD实现多线程并发 */
- (void)work {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("queuename", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10); //信号总数=10 ==> 限制最大并发数=10
    
    for (int i = 0; i < 100; i++) {
        
        //1. 等待是否有信号
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        //2. 等待到信号
        dispatch_group_async(group, queue, ^{
           
            //2.1 do something ...
            
            //2.2 睡眠
            sleep(2);
            
            //2.3 消耗一个信号
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    //等到组内的所有任务完成
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
#if __has_feature(objc_arc)
    group = nil;
    queue = nil;
#else
    dispatch_release(group);
    dispatch_release(queue);
#endif
