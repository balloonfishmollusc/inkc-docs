# 编写ink

目录 
    * [简介](#introduction)
    * [第一部分：基础知识](#part-one-the-basics)
        * [1) 内容](#1-content)
        * [2) 选择](#2-choices)
        * [3) Knots](#3-knots)
        * [4) Diverts](#4-diverts)
        * [5) Branching The Flow](#5-branching-the-flow)
        * [6) 包含和缝合](#6-includes-and-stitches)
        * [7) 变化选择](#7-variing-choices)
        * [8) 可变文本](#8-variable-text)
        * [9 ) 游戏查询和函数](#9-game-queries-and-functions)
    * [第 2 部分：编织](#part-2-weave)
        * [1) 收集](#1-gathers)
        * [2) 嵌套Flow](#2-nested-flow)
        * [3) 跟踪编织](#3-tracking-a-weave)
    * [第 3 部分：变量和逻辑](#part-3-variables-and-logic)
        * [1) 全局变量](#1-global-variables)
        * [2) 逻辑](#2-logic) 
        * [3) 条件块 (if/else)](#3-conditional-blocks-ifelse)
        * [ 4) 临时变量](#4-temporary-variables)
        * [5) 函数](#5-functions)
        * [6) 常量](#6-constants)
        * [7) 高级：游戏端逻辑](#7-advanced-game-side-logic)
    * [第 4 部分：高级流控制](#part-4-advanced-flow-control)
        * [1) 隧道] (#1-tunnels)
        * [2) 线程](#2-threads)
    * [第 5 部分：高级状态跟踪](#part-5-advanced-state-tracking)
        * [1) 基本列表](#1- basic-lists)
        * [2) Reusing Lists](#2-reusing-lists)
        * [3) List Values](#3-list-values)
        * [5) 高级列表操作](#5-advanced-list-operations)
        * [6) 多列表列表](#6-multi-list-lists)
        * [7) 长示例：犯罪现场](#7- long-example-crime-scene)
        * [8) 摘要](#8-summary) 
    * [第 6 部分：标识符中的国际字符支持](#part-6-international-character-support-in-identifiers)

# Introduction

**ink** 是一种脚本语言，它围绕使用流标记纯文本以生成交互式脚本的想法而构建。在最基本的情况下，它可以用来编写一个选择你自己风格的故事，或者一个分支对话树。但它的真正优势在于编写有很多选项和大量流程重组的对话。 **ink** 提供了几个功能，使非技术作家能够经常分支，并以次要和主要方式发挥这些分支的后果，而无需大惊小怪。该脚本旨在简洁且逻辑有序，因此可以“通过肉眼”测试分支对话。尽可能以声明方式描述流程。它的设计也考虑到了重新起草；所以编辑流程应该很快。

# 第一部分：基础知识

## 1) 内容

### 最简单的ink脚本

最基本的ink脚本只是.ink 文件中的文本。

    你好世界！

运行时，这将输出内容，然后停止。单独行上的文本会产生新的段落。脚本：

    你好，世界！
    你好？
    你好你在听吗？
    
产生看起来相同的输出。
### 注释 默认情况下，文件中的所有文本都将出现在输出内容中，除非特别标记。最简单的标记是注释。 **ink** 支持两种注释。有一种用于阅读代码的人，编译器会忽略它：

    “你对此有何看法？”她问。

    // 一些无法打印的东西...

    “我不可能发表评论，”我回答道。

    /*
        ... 或无限的文本块
    */

还有一种用于提醒作者他们需要做什么的类型，编译器在编译过程中打印出来：

    TODO：正确编写此部分！ 

### 标签 

等待翻译.........