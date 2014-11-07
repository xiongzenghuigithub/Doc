第一步：创建本地推送  

// 创建一个本地推送  
UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];  

//设置10秒之后  
NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];  

if (notification != nil) {  
   
    // 设置推送时间  
    notification.fireDate = pushDate;  
    // 设置时区  
    notification.timeZone = [NSTimeZone defaultTimeZone];  
    // 设置重复间隔  
    notification.repeatInterval = kCFCalendarUnitDay;  
    // 推送声音  
    notification.soundName = UILocalNotificationDefaultSoundName;  
    // 推送内容  
    notification.alertBody = @"推送内容";  
    //显示在icon上的红色圈中的数子  
    notification.applicationIconBadgeNumber = 1;  
    //设置userinfo 方便在之后需要撤销的时候使用  
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];  
    notification.userInfo = info;  
    //添加推送到UIApplication         
    UIApplication *app = [UIApplication sharedApplication];  
    [app scheduleLocalNotification:notification];   
      
}  
   
第二步：接收本地推送  
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iWeibo" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];  
    [alert show];  
    // 图标上的数字减1  
    application.applicationIconBadgeNumber -= 1;  
}  
   
第三步：解除本地推送  
// 获得 UIApplication  
UIApplication *app = [UIApplication sharedApplication];  

//获取本地推送数组  
NSArray *localArray = [app scheduledLocalNotifications];  

//声明本地通知对象  
UILocalNotification *localNotification;  
if (localArray) {  
    for (UILocalNotification *noti in localArray) {  
        NSDictionary *dict = noti.userInfo;  
        if (dict) {  
            NSString *inKey = [dict objectForKey:@"key"];  
            if ([inKey isEqualToString:@"对应的key值"]) {  
                if (localNotification){  
                    [localNotification release];  
                    localNotification = nil;  
                }  
                localNotification = [noti retain];  
                break;  
            }  
        }  
    }  
      
    //判断是否找到已经存在的相同key的推送  
    if (!localNotification) {  
        //不存在初始化  
        localNotification = [[UILocalNotification alloc] init];  
    }  
      
    if (localNotification) {  
        //不推送 取消推送  
        [app cancelLocalNotification:localNotification];  
        [localNotification release];  
        return;  
    }  
}