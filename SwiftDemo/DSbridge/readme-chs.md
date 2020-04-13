# DSBridge  for  IOS

> 三端易用的现代跨平台 Javascript bridge， 通过它，你可以在Javascript和原生之间同步或异步的调用彼此的函数.
![github](https://github.com/wendux/DSBridge-IOS)

## 特性

1. Android、IOS、Javascript 三端易用，轻量且强大、安全且健壮。
2. 同时支持同步调用和异步调用
3. 支持以类的方式集中统一管理API
4. 支持API命名空间
5. 支持调试模式
6. 支持API存在性检测
7. 支持进度回调：一次调用，多次返回
8. 支持Javascript关闭页面事件回调
9. 支持Javascript 模态/非模态对话框
10. Android端支持腾讯X5内核

## 安装

```shell
pod "dsBridge"
```

## 使用

1. 新建一个类，实现API  JS调用原生方法

   ```objective-c
   #import "dsbridge.h" 
   ...
   @implementation JsApiTest
   //同步API 
   - (NSString *) testSyn:(NSString *) msg
   {
       return [msg stringByAppendingString:@"[ syn call]"];
   }
   //异步API
   - (void) testAsyn:(NSString *) msg :(JSCallback)completionHandler
   {
       completionHandler([msg stringByAppendingString:@" [ asyn call]"],YES);
   }
   @end 
   ```
   
   ```swift
   
   // MARK: - 测试同步方法
   //MUST use "_" to ignore the first argument name explicitly。
   @objc func testSyn( _ arg:String) -> String {
        print("js调用了原生的testSyn方法")
        return String(format:"%@[Swift sync call:%@]", arg, "test")
   }
   // MARK: - 测试异步有回调
   @objc func testAsyn( _ arg:String, handler: JSCallback) {
        print("js调用了原生的testAsyn方法")
        handler(String(format:"%@[Swift async call:%@]", arg, "test"), true)
   }
   
   ```
   
   可以看到，DSBridge正式通过API类的方式集中、统一地管理API。

2. 添加API类实例到 DWKWebView 

   ```objective-c
   DWKWebView * dwebview=[[DWKWebView alloc] initWithFrame:bounds];
   // register api object without namespace
   [dwebview addJavascriptObject:[[JsApiTest alloc] init] namespace:nil];
   ```
   
   ```swift
    //添加原生方法类
    webview.addJavascriptObject(JsApiTestSwift.init(), namespace: nil)
    webview.addJavascriptObject(JsApiTestSwift.init(), namespace: "swift")//增加命名空间, JS在调用的时候可以用 swift.methodName 方便管理功能模块可增强阅读
   ```
   

3. 在Javascript中调用原生 (Java/Object-c/swift) API ,并注册一个 javascript API供原生调用.

   - 初始化 dsBridge

     ```javascript
     //cdn方式引入初始化代码(中国地区慢，建议下载到本地工程)
     //<script src="https://cdn.jsdelivr.net/npm/dsbridge@3.1.4/dist/dsbridge.js"> //</script>
     //npm方式安装初始化代码
     //npm install dsbridge@3.1.4
     var dsBridge=require("dsbridge")
     ```

   - 调用原生API ,并注册一个 javascript API供原生调用.

     ```javascript

     //同步调用
     var str=dsBridge.call("testSyn","testSyn");

     //异步调用
     dsBridge.call("testAsyn","testAsyn", function (v) {
       alert(v);
     })

     //注册 javascript API 
      dsBridge.register('addValue',function(l,r){
          return l+r;
      })
     ```

4. 调用Javascript API 

    ```objective-c
       [dwebview callHandler:@"addValue" arguments:@[@3,@4] completionHandler:^(NSNumber* value){
              NSLog(@"%@",value);
       }];
    ```

    ```swift
        //原生调用js的addValue方法, 参数是[3, 4], 返回值是value
        webview.callHandler("addValue", arguments: [3, 4]) { (value) in
        print(value ?? "")
    }
    ```



## 在Swift中使用

在 Swift中，你应该按照如下方式声明APIs:

```swift
//必须给第一个参数前添加下划线"_"来显式忽略参数名。
@objc func testSyn( _ arg:String) -> String {
	return String(format:"%@[Swift sync call:%@]", arg, "test")
}

@objc func testAsyn( _ arg:String, handler: (String, Bool)->Void) {
	handler(String(format:"%@[Swift async call:%@]", arg, "test"), true)
}
```

有两点必须注意:

- 必须给Swift API添加 "@objc" 标注。
- 必须给第一个参数前添加下划线"_"来显式忽略参数名

完整的示例在 [这里](https://github.com/wendux/DSBridge-IOS/blob/master/dsbridgedemo/JsApiTestSwift.swift) .

## 命名空间

命名空间可以帮助你更好的管理API，这在API数量多的时候非常实用，比如在混合应用中。DSBridge (>= v3.0.0) 支持你通过命名空间将API分类管理，并且命名空间支持多级的，不同级之间只需用'.' 分隔即可。


## 调试模式

在调试模式时，发生一些错误时，将会以弹窗形式提示，并且原生API如果触发异常将不会被自动捕获，因为在调试阶段应该将问题暴露出来。如果调试模式关闭，错误将不会弹窗，并且会自动捕获API触发的异常，防止crash。强烈建议在开发阶段开启调试模式，可以通过如下代码开启调试模式：

```objective-c
// open debug mode
[dwebview setDebugMode:true];
```



## 进度回调

通常情况下，调用一个方法结束后会返回一个结果，是一一对应的。但是有时会遇到一次调用需要多次返回的场景，比如在javascript钟调用端上的一个下载文件功能，端上在下载过程中会多次通知javascript进度, 然后javascript将进度信息展示在h5页面上，这是一个典型的一次调用，多次返回的场景，如果使用其它Javascript bridge,  你将会发现要实现这个功能会比较麻烦，而DSBridge本省支持进度回调，你可以非常简单方便的实现一次调用需要多次返回的场景，下面我们实现一个倒计时的例子：

In Object-c

```objective-c
- ( void )callProgress:(NSDictionary *) args :(JSCallback)completionHandler
{
    value=10;
    hanlder=completionHandler;
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:YES];
}
-(void)onTimer:t{
    if(value!=-1){
        hanlder([NSNumber numberWithInt:value--],NO);
    }else{
        hanlder(@"",YES);
        [timer invalidate];
    }
}
```

In javascript

```javascript
dsBridge.call("callProgress", function (value) {
	document.getElementById("progress").innerText = value
})
```

完整的示例代码请参考demo工程。



## Javascript 弹出框

DSBridge已经实现了 Javascript的弹出框函数(alert/confirm/prompt)，这些对话框按钮、标签文字默认都是中文的，如果你想自定义这些文本可以参考 `customJavascriptDialogLabelTitles` API，如果你不想使用DSBridge实现的对话框，你可以通过设置`DSUIDelegate` 属性（是WKUIDelegate的代理属性）完全自定义。

另外注意，DSBridge实现的弹出框都是模态的，这会阻塞UI线程，如果你需要非模态的对话框，请参考`disableJavascriptDialogBlock` API.



# WKUIDelegate

在 `DWKWebView ` 中，请使用` DSUIDelegate` 代替 `UIDelegate` , 因为在`DWKWebView ` 内部 `UIDelegate`已经设置过了，而 `DSUIDelegate` 正是  `UIDelegate` 的一个代理。



## API 列表

### Object-C API

在Object-c中我们把实现了供 javascript调用的 API类的实例 成为 **Object-c API object**.

##### `addJavascriptObject:(id) object namespace:(NSString *) namespace`

添加一个 Object-c API object 到DWKWebView，并为它指定一个命名空间. 然后，在 javascript 中就可以通过`bridge.call("namespace.api",...)`来调用Object-c API object中的原生API了。

如果命名空间是空(nil或空字符串）, 那么这个添加的  Object-c API object就没有命名空间。在 javascript 通过 `bridge.call("api",...)`调用。

示例:

**In Object-c**

```objective-c
@implementation JsEchoApi
- (id) syn:(id) arg
{
    return arg;
}
- (void) asyn: (id) arg :(JSCallback)completionHandler
{
    completionHandler(arg,YES);
}
@end
// register api object with namespace "echo"
[dwebview addJavascriptObject:[[JsEchoApi alloc] init] namespace:@"echo"];
```

**In Javascript**

```javascript
// call echo.syn
var ret=dsBridge.call("echo.syn",{msg:" I am echoSyn call", tag:1})
alert(JSON.stringify(ret))  
// call echo.asyn
dsBridge.call("echo.asyn",{msg:" I am echoAsyn call",tag:2},function (ret) {
      alert(JSON.stringify(ret));
})
```



##### `removeJavascriptObject:(NSString *) namespace`

通过命名空间名称移除相应的  Object-c API object.



##### `callHandler:(NSString *) methodName  arguments:(NSArray *) args`

##### `callHandler:(NSString *) methodName  completionHandler:(void (^)(id value))completionHandler`

##### `callHandler:(NSString *) methodName  arguments:(NSArray *) args completionHandler:(void (^ )(id value))completionHandler`

调用 javascript API.`methodName`  为javascript API 的名称，可以包含命名空间；参数以数组传递，`argumentss`数组中的元素依次对应javascript API的形参；  `completionHandler` 用于接收javascript API的返回值，**注意： `completionHandler`将在主线程中被执行**。

示例:

```objective-c
[dwebview callHandler:@"append" arguments:@[@"I",@"love",@"you"]
  completionHandler:^(NSString * _Nullable value) {
       NSLog(@"call succeed, append string is: %@",value);
}];
// call with namespace 'syn', More details to see the Demo project                    
[dwebview callHandler:@"syn.getInfo" completionHandler:^(NSDictionary * _Nullable value) {
        NSLog(@"Namespace syn.getInfo: %@",value);
}];
```



##### `disableJavascriptDialogBlock:(bool) disable`

**小心使用**. 如果你再javascript中调用弹窗函数(`alert`,` confirm`, 或 `prompt`)， 那么APP将会挂起，因为这些弹窗都是**模态**的，会阻塞APP主线程，此时javascript执行流也会阻塞。如果你想避免阻塞，可以通过此API禁止，禁止后，一旦 javascript中调用了这些弹窗函数，APP将弹出**非模态**对话框，并立即返回，(  `confirm` 会返回 `true`,  `prompt` 返回空字符串)。

如:

```objective-c
[dwebview disableJavascriptDialogBlock: true]
```

如果你想恢复**模态**对话框，传 `false` 调用即可.



##### `setJavascriptCloseWindowListener:(void(^_Nullable)(void))callback`

当 Javascript中调用`window.close`时，DWKWebView会触发此监听器:

Example:

```objective-c
[dwebview setJavascriptCloseWindowListener:^{
        NSLog(@"window.close called");
}];
```



##### `hasJavascriptMethod:(NSString*) handlerName methodExistCallback:(void(^)(bool exist))callback`

检测是否存在指定的 javascript API，`handlerName`可以包含命名空间.

Example:

```objective-c
// test if javascript method exists.
[dwebview hasJavascriptMethod:@"addValue" methodExistCallback:^(bool exist) {
      NSLog(@"method 'addValue' exist : %d",exist);
}];
```



##### `setDebugMode:(bool) debug`

设置调试模式。在调试模式时，发生一些错误时，将会以弹窗形式提示，并且原生API如果触发异常将不会被自动捕获，因为在调试阶段应该将问题暴露出来。如果调试模式关闭，错误将不会弹窗，并且会自动捕获API触发的异常，防止crash。强烈建议在开发阶段开启调试模式。



##### `customJavascriptDialogLabelTitles:(NSDictionary*) dic`

custom the  label text of  javascript dialog that includes alert/confirm/prompt, the default text language is Chinese.

自定义 javascript对话框上按钮、标签的文本，默认的文本语言是中文，你可以自定义英文，如：

```objective-c
[dwebview customJavascriptDialogLabelTitles:@{
 @"alertTitle":@"Notification",
 @"alertBtn":@"OK",
 @"confirmTitle":@"",
 @"confirmCancelBtn":@"CANCEL",
 @"confirmOkBtn":@"OK",
 @"promptCancelBtn":@"CANCEL",
 @"promptOkBtn":@"OK"
}];
```



### Javascript API

##### dsBridge 

"dsBridge" 在初始化之后可用 .

##### `dsBridge.call(method,[arg,callback])`

同步或异步的调用Java API。

`method`: Java API 名称， 可以包含命名空间。

`arg`:传递给Java API 的参数。只能传一个，如果需要多个参数时，可以合并成一个json对象参数。

`callback(String returnValue)`: 处理Java API的返回结果. 可选参数，**只有异步调用时才需要提供**.



##### `dsBridge.register(methodName|namespace,function|synApiObject)`

##### `dsBridge.registerAsyn(methodName|namespace,function|asyApiObject)`

注册同步/异步的Javascript API. 这两个方法都有两种调用形式：

1. 注册一个普通的方法，如:

   **In Javascript**

   ```javascript
   dsBridge.register('addValue',function(l,r){
        return l+r;
   })
   dsBridge.registerAsyn('append',function(arg1,arg2,arg3,responseCallback){
        responseCallback(arg1+" "+arg2+" "+arg3);
   })
   ```

   **In Object-c**

   ```objective-c
   // call javascript method
   [dwebview callHandler:@"addValue" arguments:@[@3,@4] completionHandler:^(NSNumber * value){
         NSLog(@"%@",value);
   }];

   [dwebview callHandler:@"append" arguments:@[@"I",@"love",@"you"] completionHandler:^(NSString * _Nullable value) {
        NSLog(@"call succeed, append string is: %@",value);
   }];
   ```

   ​

2. 注册一个对象，指定一个命名空间:

   **In Javascript**

   ```java
   //namespace test for synchronous
   dsBridge.register("test",{
     tag:"test",
     test1:function(){
   	return this.tag+"1"
     },
     test2:function(){
   	return this.tag+"2"
     }
   })
     
   //namespace test1 for asynchronous calls  
   dsBridge.registerAsyn("test1",{
     tag:"test1",
     test1:function(responseCallback){
   	return responseCallback(this.tag+"1")
     },
     test2:function(responseCallback){
   	return responseCallback(this.tag+"2")
     }
   })
   ```

##### `dsBridge.hasNativeMethod(handlerName,[type])`

检测Java中是否存在名为`handlerName`的API, `handlerName` 可以包含命名空间. 

`type`: 可选参数，`["all"|"syn"|"asyn" ]`, 默认是 "all".

```javascript
//检测是否存在一个名为'testAsyn'的API(无论同步还是异步)
dsBridge.hasNativeMethod('testAsyn') 
//检测test命名空间下是否存在一个’testAsyn’的API
dsBridge.hasNativeMethod('test.testAsyn')
// 检测是否存在一个名为"testSyn"的异步API
dsBridge.hasNativeMethod('testSyn','asyn') //false
```
