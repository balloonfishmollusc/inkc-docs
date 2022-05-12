# 数组和字典

为使用数组和字典功能，确保`main.ink`开头加入了数组插件的包含文件。

```
INCLUDE array.ink
```

## 数组和字典的创建

#### `array(...)`

创建空数组，或包含若干初始值的数组。数组元素可以是字符串/数字/指针。

返回创建的数组指针。

```
~ temp a = array()
~ a = array(1,2,3)	// [1,2,3]
~ a = array("a","b")	// [a, b]
```

#### `range(m, n, step)`

创建由区间`[m, n)`的连续整数组成的数组。

+ `m` (`int`): 区间左端点
+ `n` (`int`): 区间右端点
+ `step` (`int`): 步长

三个参数不是必须的。如果只提供一个参数，则表示`[0, n]`；提供两个参数表示`[m, n)`。

```
VAR a = 0
~ a = range(4)		// [0,1,2,3]，只提供一个参数表示从0开始
~ a = range(1,3)	// [1,2]，提供两个参数
~ a = range(5,14,2)	// [5,7,9,11,13]，第三个参数指定步长
```

#### `zeros(n)`

创建一个数组，并将所有值初始化为0。

+ `n` (`int`): 数组的长度

```
~ temp a = zeros(5) // [0,0,0,0,0]
```

#### `dict()`

创建空字典，返回创建的字典的指针。

```
~ temp a = dict()	// {}
```



## 获取和设置元素的值

#### `get(obj, key)`

获取数组或字典对应位置的值。

+ `obj` (`array` or `dict`): 待操作的数组或字典
+ `key` (`int` or `str`): 数组的索引或字典的键

#### `set(obj, key, val)`

设置数组或字典对应位置的值。

+ `obj` (`array` or `dict`): 待操作的数组或字典
+ `key` (`int` or `str`): 数组的索引或字典的键
+ `val`: 你想要设置的值



## 添加与删除元素

#### `push(obj, val)`

向数组末尾添加元素。返回`obj`本身。

#### `pop(obj)`

移除数组最后一个元素，并返回其值。

#### `remove(obj, val)`

+ `obj` (`array` or `dict`): 待操作的数组或字典
+ `val`: 待移除的数组元素，或字典的键

无返回值。



## 查询与统计

#### `contains(obj, val)`

判断数组是否包含某个值，或字典是否包含某个键。返回`bool`值。

+ `obj` (`array` or `dict`): 待操作的数组或字典
+ `val`: 待检查的数组元素，或字典的键

#### `str(obj)`

返回数组或字典的可读表示。

#### `len(obj)`

返回数组或字典的长度。

#### `sum(obj)`

返回数组中所有元素的和。

#### `min(obj)`

返回数组中的最小值。

#### `max(obj)`

返回数组中的最大值。

#### `keys(obj)`

返回字典的所有键构成的数组。

#### `values(obj)`

返回字典的所有值构成的数组。



## 切片与拼接

#### `concat(obj1, obj2)`

拼接两个数组，返回一个新数组。

```
~ temp a = range(0, 3)	// [1,2,3]
~ temp b = range(3, 6)	// [3,4,5]
{concat(a, b)}	// [0,1,2,3,4,5]
```

#### `join(obj, sep)`

用给定的连接符拼接数组。

```
~ temp a = array(1,2,3)
{a.join("-")}	// 1,2,3
{a.join(__newline__)}	// __newline__表示换行符
// 1
// 2
// 3
```

#### `slice(obj, start, end)`

对数组进行切片，返回一个新数组。

+ `obj` (`array`): 待操作的数组

+ `start` (`int`): 起始索引
+ `end` (`int`): 结束索引

```
~ temp a = array(1,3,4,5,6)
{a.slice(1,3)}	// [3,4]
```



## 复制和释放

#### `copy(obj)`

复制一个数组或字典，返回复制的新对象指针。

#### `free(obj)`

释放数组或字典对应的内存空间。返回`bool`，表示是否成功。



## 高级数组操作

#### `map(obj, ->fn, ...)`

对数组每个元素执行`fn`，返回由`fn`的结果组成的新数组

__例：使用`map`对数组元素平方__

```
INCLUDE array.ink
-> init
== function sqr(x)
~ return x*x

== main ==
~ temp a = range(1, 5)	// [1,2,3,4]
~ a = map(a, ->sqr)
{str(a)}	// [1,4,9,16]
```

#### `filter(obj, ->fn, ...)`

对数组每个元素执行`fn`，返回使`fn`为`true`的元素构成的子数组

__例：使用`filter`选取奇数__

```
INCLUDE array.ink
-> init
== function is_odd(x)
~ return x mod 2

== init ==
~ temp a = range(1, 7)	// [1,2,3,4,5,6]
~ a = filter(a, ->is_odd)
{str(a)}	// [1,3,5]
```
