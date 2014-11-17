//使用runtime查看私有api的所有方法


   1. 要导入#import <objc/runtime.h>
   2. 代码
   NSString *className = NSStringFromClass([UIView class]);
   //这里是uiview，可以改成自己想要的
    
   const char *cClassName = [className UTF8String];
    
   id theClass = objc_getClass(cClassName);
    
   unsigned int outCount;
    
   Method *m =  class_copyMethodList(theClass,&outCount;);
   
   NSLog(@"%d",outCount);
   for (int i = 0; i<outCount; i++) {
       SEL a = method_getName(*(m+i));
       NSString *sn = NSStringFromSelector(a);
       NSLog(@"%@",sn);
 
   }

   //1. 导入 <objc/runtime.h>

//2. 获取Class对象的所有属性(属性的名字、属性的类型)
unsigned int count;
objc_property_t * properties = class_copyPropertyList(cls, &count);

for (int i = 0; i < count; ++i)
{
  objc_property_t property = properties[i];
  const char * propertyName = property_getName(property);
  const char * propertyType = getPropertyType(property);
}

//获取属性的类型
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}