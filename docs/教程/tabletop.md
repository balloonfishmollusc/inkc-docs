# 桌游模式

为应用桌游渲染器，确保`main.ink`开头加入了以下包含文件。

```
INCLUDE tabletop.ink
```

并且你在`main.ink`中至少定义了`_init`和`_draw`两个`function`。

```
== function _init()
// 用于初始化

== function _draw()
// 在图层0画图

== function _draw_1()
// 在图层1画图

== function _draw_2()
// 在图层1画图

== function _on_tap(i)
// 处理格子点击事件

```

