## 隐藏导航栏(hide navigation bar)

```
someview
.navigationTitle("")
.navigationBarTitle("")
.navigationBarHidden(true)
.navigationBarBackButtonHidden(true)
```



## EnvironmentObject && someview.envorinmentObject(store)

尽量在最外层调用envorinmentObject， 如果遇到navigationLink的情况， 如果不work， 可以使用一下方法
```
NavigationLink(destination: WRLoginCodeView().environmentObject(store), isActive: $waitingForCode) {
                EmptyView()
            }
```

## NavigationLink会影响destination的navigationBar的样式



## onAppear会调用多次（called multi times）

如果使用了多层路由， 那么父页面的onAppear可能调用多次， 一个解决方法就是在父页面设置一个状态位， 记录下是否已经执行过。

## swift Date() & Dateformatter()

Date()返回的是0时区的时间
Dateformatter().string 返回的是系统时区的时间

## fullScreenCover 只能用在Button上？
