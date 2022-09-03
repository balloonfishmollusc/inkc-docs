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
// 画图

== function _on_tap(i)
// 处理格子点击事件

// 设置最大玩家数
== function _get_max_players()
~ return 1

// 设置画布尺寸
== function _get_canvas_size()
~ return array(5, 5)
```

#### 内置变量

#### `__player__`

一个整数，表示当前玩家的序号。例如两人游玩时，一名玩家为0，另一名玩家为1。

## 新增函数

#### `sync()`

用于多人游戏，所有玩家同步所有以`_`开头的变量。

#### `refresh()`

刷新屏幕，重新调用`_draw`进行绘图
