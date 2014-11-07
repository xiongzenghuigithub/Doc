
判断是否开启定位服务

if ([CLLocationManager locationServicesEnabled] &&  
                ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized  
                || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {  
                //定位功能可用，开始定位  
                _locationManger = [[CLLocationManager alloc] init];  
                locationManger.delegate = self;  
                [locationManger startUpdatingLocation];  
            }  
            else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){  
        NSlog("定位功能不可用，提示用户或忽略");   
}
