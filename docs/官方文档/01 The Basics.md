# Part 1: The Basics

## 1) Content

### The simplest ink script

The most basic ink script is just text in a .ink file.

	Hello, world!

On running, this will output the content, and then stop.

Text on separate lines produces new paragraphs. The script:

	Hello, world!
	Hello?
	Hello, are you there?

produces output that looks the same.


### Comments

By default, all text in your file will appear in the output content, unless specially marked up.

The simplest mark-up is a comment. **ink** supports two kinds of comment. There's the kind used for someone reading the code, which the compiler ignores:

> 默认情况下，除非特别标记，否则文件中的所有文本都将显示在输出内容中。
>
> 最简单的标记是注释。 **ink** 支持两种注释。有一种是用于某人阅读代码的人，编译器会忽略它：

```
有两种方式添加注释：
1.这种只能作用于这一行
//注释

2.这种类似于括号，将/*....*/内的内容都变成注释
/*
注释
注释
注释
*/

下面是一个例子：
在编辑代码时，你将看到以下内容

"What do you make of this?" she asked.

// Something unprintable...

"I couldn't possibly comment," I replied.

/*
	... or an unlimited block of text
*/

当游戏运行时，注释消失，它将显示为这个：
"What do you make of this?" she asked.


"I couldn't possibly comment," I replied.







```

and there's the kind used for reminding the author what they need to do, that the compiler prints out during compilation:


	TODO: Write this section properly!

### Tags

Text content from the game will appear 'as is' when the engine runs. However, it can sometimes be useful to mark up a line of content with extra information to tell the game what to do with that content.

**ink** provides a simple system for tagging lines of content, with hashtags.

	意思就是，你在写代码的时候，编译器会将一些字标成不同颜色便于阅读，当然，游戏运行的时候是不会将这些字的颜色改变的
	A line of normal game-text. # colour it blue

These don't show up in the main text flow, but can be read off by the game and used as you see fit. See [Running Your Ink](RunningYourInk.md#marking-up-your-ink-content-with-tags) for more information.


## 2) Choices

Input is offered to the player via text choices. A text choice is indicated by an `*` character.

If no other flow instructions are given, once made, the choice will flow into the next line of text.

> 输入通过文本选择提供给玩家。文本选择由 * 字符表示（但我个人推荐用+这个字符，后面会讲到）。
>
> 如果没有给出其他指令，一旦做出，选择将流入下一行文本。

	Hello world!
	*	Hello back!
		Nice to hear from you!
	选项下的代码将在玩家选择该选项后运行

This produces the following game:

> 以上代码将生成以下游戏界面：

	Hello world
	1: Hello back!    这里玩家界面会弹出一个可以点击的选项，就叫Hello back!
	
	 玩家点击了该选项，而后选项名字Hello back!接着出现在了下面，而后原本该选项内的代码运行，Nice to hear from you!接着弹出
	 
	>1 Hello back!
	Nice to hear from you.

By default, the text of a choice appears again, in the output.

> 默认情况下，所选内容的文本将再次显示在输出中。

### Suppressing choice text

Some games separate the text of a choice from its outcome. In **ink**, if the choice text is given in square brackets, the text of the choice will not be printed into response.

> **禁止显示选项文本**
>
> 一些游戏将选择的文本与其结果分开。 如果在方括号中给出选择文本，则所选文本将不会出现在游戏界面中。

	Hello world!
	*	[Hello back!]
		Nice to hear from you!

produces

	Hello world
	1: Hello back!
	
	玩家点击了该选项，但由于代码中Hello back!被加上了方括号，将不会出现在游戏界面中。
	
	>1 Nice to hear from you.

#### Advanced: mixing choice and output text

The square brackets in fact divide up the option content. What's before is printed in both choice and output; what's inside only in choice; and what's after, only in output. Effectively, they provide alternative ways for a line to end.

> **高级：混合选择和输出文本**
>
> 方括号实际上划分了选项内容。之前的内容在选择和输出中都打印出来;内在的东西只有在选择中;以及之后的内容，仅在输出中。实际上，它们为线路的结束提供了替代方法。（这里的意思是，方括号后的内容在选项跳出来时不会出现。）

	Hello world!
	*	Hello [back!] right back to you!
		Nice to hear from you!

produces:

	Hello world
	1: Hello back!
	> 1
	Hello right back to you!
	Nice to hear from you.

This is most useful when writing dialogue choices:

	"What's that?" my master asked.
	*	"I am somewhat tired[."]," I repeated.
		"Really," he responded. "How deleterious."

produces:

	"What's that?" my master asked.
	1: "I am somewhat tired."
	> 1
	"I am somewhat tired," I repeated.
	"Really," he responded. "How deleterious."

### Multiple Choices

To make choices really choices, we need to provide alternatives. We can do this simply by listing them:

> **多种选择**
>
> 要使选择真正成为选择，我们需要提供替代方案。我们只需列出它们即可做到这一点：

	"What's that?" my master asked.
	*	"I am somewhat tired[."]," I repeated.
		"Really," he responded. "How deleterious."
	*	"Nothing, Monsieur!"[] I replied.
		"Very good, then."
	*  "I said, this journey is appalling[."] and I want no more of it."
		"Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."

This produces the following game:

> 选项包含的内容在下一个同级选项开始，或下一个节点开始时截止。
> 上文代码中，我们可以看到有三个标有一个的选项，当玩家选择了	"I am somewhat tired[."]," I repeated.对应在下文游戏时显示在屏幕中的选项时，那么系统会运行该选项包含的内容，也就是显示"Really," he responded. "How deleterious."。而如果玩家选择了其他两个选项，那么系统运行的也是这两个选项下，一直到下个同级选项或节点的那一部分。（至于同级的概念，之后会讲到）

```
"What's that?" my master asked.

1:"I am somewhat tired."
2:"Nothing, Monsieur!"
3:"I said, this journey is appalling."

>1 "Really," he responded. "How deleterious."
>2 "Very good, then."
>3 "I said, this journey is appalling and I want no more of it."
 "Ah," he replied, not unkindly. "I see you are feeling frustrated. Tomorrow, things will improve."
```







The above syntax is enough to write a single set of choices. In a real game, we'll want to move the flow from one point to another based on what the player chooses. To do that, we need to introduce a bit more structure.

## 3) Knots

### Pieces of content are called knots

To allow the game to branch we need to mark up sections of content with names (as an old-fashioned gamebook does with its 'Paragraph 18', and the like.)

These sections are called "knots" and they're the fundamental structural unit of ink content.

### Writing a knot

The start of a knot is indicated by two or more equals signs, as follows.

> **结**（其实我喜欢叫它节点）
>
> **内容片段称为结**
>
> 为了允许游戏分支，我们需要用名称标记内容部分
>
> 这些部分被称为“结”，它们是ink的基本结构单元。
>
> **写结**
>
> 结的开始由两个或多个等号表示，如下所示。

	=== top_knot ===

(The equals signs on the end are optional; and the name needs to be a single word with no spaces.)

The start of a knot is a header; the content that follows will be inside that knot.

> 末尾的等号是可选的
>
> （你可以选择不加，也就是=== top_knot）;
>
> 名称必须是没有空格的单个单词。
>
> 结的开头是标题;接下来的内容将在那个结内。
>
> （如下文例子，这里节点的开头指的就是  === back_in_london ===  ，其中back_in_london就是节点的名字，以后跳转到哪个节点依靠的就是它，而所谓接下来的内容，指的就是这个节点开头下面，直到另一个节点开头的部分。至于同级节点的概念，之后会讲）



	=== back_in_london ===
	
	We arrived into London at 9.45pm exactly.

#### Advanced: a knottier "hello world"

When you start an ink file, content outside of knots will be run automatically. But knots won't. So if you start using knots to hold your content, you'll need to tell the game where to go. We do this with a divert arrow `->`, which is covered properly in the next section.

> 启动ink文件时，节外的内容将自动运行。但结不会。因此，如果您开始使用结来保存内容，则需要告诉游戏该去哪里。我们使用转移箭头 -> 来执行此操作，这将在下一节中正确介绍。.
>
> （所谓节点外的内容，指的就是不属于任何一个节点的内容，一般是指的从上往下数第一个节点之前的内容。）
>
> 



The simplest knotty script is:

	当系统运行到含有箭头的那一行时，系统会检索箭头后的内容，看看所有节点的名字有没有哪个和它相同，然后直接跳转到那个节点的 “开头位置”
	（不过请注意，进入节点要箭头，出节点也是要用箭头跳转到自己或其他节点的，不然游戏就结束了。）
	
	-> top_knot
	
	=== top_knot ===
	Hello world!

However, **ink** doesn't like loose ends, and produces a warning on compilation and/or run-time when it thinks this has happened. The script above produces this on compilation:

> 但是， **ink** 不喜欢松散的结尾，当它认为这种情况已经发生时，它会在编译和/或运行时生成警告。上面的脚本在编译时生成以下内容：
>
> （也就算是说，当一个节点走完，你必须要使用箭头跳转出去，否则就会报错。而如果你想让游戏在运行完这个节点后直接结束，那么你可以在节点最后加上-> END直接跳转出游戏



以下是节点运行到底而没有任何跳转时的报错：

	WARNING: Apparent loose end exists where the flow runs out. Do you need a '-> END' statement, choice or divert? on line 3 of tests/test.ink

and this on running:

	Runtime error in tests/test.ink line 3: ran out of content. Do you need a '-> DONE' or '-> END'?



The following plays and compiles without error:

这是正确的做法，如此一来，当进入了这个节点后，屏幕上会显示Hello world!而如果玩家再点一下屏幕，游戏会直接结束，屏幕中央会弹出 “游戏结束” 的白色方框

	=== top_knot ===
	Hello world!
	-> END

`-> END` is a marker for both the writer and the compiler; it means "the story flow should now stop".

## 4) Diverts

### Knots divert to knots

You can tell the story to move from one knot to another using `->`, a "divert arrow". Diverts happen immediately without any user input.

> **分流**
>
> **结转移到结**
>
> 你可以用 ->（一种“转移箭头”）讲述从一个结移动到另一个结的故事。无需任何用户输入即可立即进行分流。
>
> （在一个节点内使用箭头进行跳转，会跳转到另外一个节点，甚至也可以跳转到自己本身的节点开头位置）



	=== back_in_london ===
	
	We arrived into London at 9.45pm exactly.
	-> hurry_home
	
	=== hurry_home ===
	We hurried home to Savile Row as fast as we could.
	
	当系统在节点back_in_london中运行时，它看到了-> hurry_home，于是系统便跳转到了节点 hurry_home的开头

#### Diverts are invisible

Diverts are intended to be seamless and can even happen mid-sentence:

> **分流是看不见的**
>
> 转移旨在无缝衔接，甚至可能发生在句子中间：

	=== hurry_home ===
	We hurried home to Savile Row -> as_fast_as_we_could
	
	=== as_fast_as_we_could ===
	as fast as we could.

produces the same line as above:

	We hurried home to Savile Row as fast as we could.

#### Glue

The default behaviour inserts line-breaks before every new line of content. In some cases, however, content must insist on not having a line-break, and it can do so using `<>`, or "glue".

> 默认行为在每行新内容之前插入换行符。但是，在某些情况下，内容必须坚持没有换行符，并且可以使用<>或“胶水”来执行此操作。
>
> （意思就是，符号<>能够消除紧跟在之后的换行行为）
>
> （这还意味着，原本玩家需要点好几下才能逐条显示完整的文本，只要使用这个符号链接上下两行文本，那么玩家只要点一下就可以显示一串了）

	=== hurry_home ===
	We hurried home <>
	-> to_savile_row
	
	=== to_savile_row ===
	to Savile Row
	-> as_fast_as_we_could
	
	=== as_fast_as_we_could ===
	<> as fast as we could.

also produces:

	We hurried home to Savile Row as fast as we could.

You can't use too much glue: multiple glues next to each other have no additional effect. (And there's no way to "negate" a glue; once a line is sticky, it'll stick.)


## 5) Branching The Flow

### Basic branching

Combining knots, options and diverts gives us the basic structure of a choose-your-own game.

> **分支流程**
>
> **基本分支**
>
> 结合结，选项和转移为我们提供了选择自己的游戏的基本结构。
>
> （如下面这个例子，当玩家选择* [Open the gate]这个选项时，游戏会跳转到节点paragraph_2，因为选项* [Open the gate]的内容就是  -> paragraph_2  ，它会让游戏跳转到节点paragraph_2

	=== paragraph_1 ===
	You stand by the wall of Analand, sword in hand.
	* [Open the gate] -> paragraph_2
	* [Smash down the gate] -> paragraph_3
	* [Turn back and go home] -> paragraph_4
	
	=== paragraph_2 ===
	You open the gate, and step out onto the path.
	
	...

### Branching and joining

Using diverts, the writer can branch the flow, and join it back up again, without showing the player that the flow has rejoined.

	=== back_in_london ===
	
	We arrived into London at 9.45pm exactly.
	
	*	"There is not a moment to lose!"[] I declared.
		-> hurry_outside
	
	*	"Monsieur, let us savour this moment!"[] I declared.
		My master clouted me firmly around the head and dragged me out of the door.
		-> dragged_outside
	
	*	[We hurried home] -> hurry_outside


	=== hurry_outside ===
	We hurried home to Savile Row -> as_fast_as_we_could


	=== dragged_outside ===
	He insisted that we hurried home to Savile Row
	-> as_fast_as_we_could


	=== as_fast_as_we_could ===
	<> as fast as we could.


### The story flow

Knots and diverts combine to create the basic story flow of the game. This flow is "flat" - there's no call-stack, and diverts aren't "returned" from.

In most ink scripts, the story flow starts at the top, bounces around in a spaghetti-like mess, and eventually, hopefully, reaches a `-> END`.

The very loose structure means writers can get on and write, branching and rejoining without worrying about the structure that they're creating as they go. There's no boiler-plate to creating new branches or diversions, and no need to track any state.

> **故事流程**
>
> 结和转移相结合，创造了游戏的基本故事流程。此流是“平坦的” - 没有调用堆栈，并且不会从中“返回”转移。
>
> 在大多数墨迹脚本中，故事流从顶部开始，在意大利面条般的混乱中反弹，最终，希望达到 ->结束。
>
> 非常松散的结构意味着作家可以继续写作，分支和重新加入，而不必担心他们正在创建的结构。没有用于创建新分支或转移的样板，也无需跟踪任何状态。
>
> （当然，还有一种叫做隧道的跳转方法，在两个箭头直接输入一个节点的名字   ->b->  ，那么系统运行到这里就会跳转到那个节点，若继续运行时找到中间没有东西的两个箭头时  -> ->  ，系统会回到最近一次使用隧道跳转的那一行继续走下去
>
> ```
> ==a==
> 老师：一加一等于多少？
> ->b->
> 老师：同学你答对了！
> 
> ==b==
> 同学：等于二！
> ->->
> ```
>
> 这虽然是非常 常用且方便的一种工具，不过使用这种跳转时一定一定要理清自己的思路，不要跳转出去了就以为没事了，特别是当你连续用隧道跳转了多次之后，因为这种跳转最终会回到跳转开始时的那一行。



#### Advanced: Loops

You absolutely can use diverts to create looped content, and **ink** has several features to exploit this, including ways to make the content vary itself, and ways to control how often options can be chosen.

See the sections on Varying Text and [Conditional Choices](#conditional-choices) for more information.

Oh, and the following is legal and not a great idea:

> **高级：循环**
>
> 您绝对可以使用转移来创建循环内容，而 **Ink** 具有多种功能可以利用这一点，包括使内容本身变化的方法，以及控制选择选项的频率的方法。
>
> （这里指的就是，在一个节点中，对着自己进行跳转，于是这就构成了一个闭环）
>
> 有关详细信息，请参阅变化文本和[条件选择](#conditional-choices)部分。
>
> 哦，以下是合法的，不是一个好主意：
>
> （其实节点的循环是比较常用的，你可以不用听他
>
> （￣︶￣）↗　）

	=== round ===
	and
	-> round

## 6) Includes and Stitches

### Knots can be subdivided

As stories get longer, they become more confusing to keep organised without some additional structure.

Knots can include sub-sections called "stitches". These are marked using a single equals sign.

> **包含和缝合**
>
> **结可以细分**
>
> 随着故事变得越来越长，它们变得更加混乱，以便在没有额外结构的情况下保持井井有条。
>
> 结可以包括称为“针脚”的子部分。（我个人喜欢叫它 “子节点” ）这些使用“单个等号”进行标记。

	=== the_orient_express ===
	= in_first_class
		...
	= in_third_class
		...
	= in_the_guards_van
		...
	= missed_the_train
		...

One could use a knot for a scene, for instance, and stitches for the events within the scene.

### Stitches have unique names

A stitch can be diverted to using its "address".

> **缝线有唯一的名称**
>
> 缝线可以转移到使用其“地址”上。
>
> （这里的意思是，如果你想跳转到一个节点的子节点内，你必须得先让系统找到这个子节点所属的父节点，而后系统才会在这个父节点内寻找那个子节点。可以用点来描述父节点和子节点的关系。
>
> 这里举个栗子：
>
> ```
> == a ==
> = a1 
> = a2
> ```
>
> 假如你要跳转到a2，那么需要这样写跳转  -> a.a2

	*	[Travel in third class]
		-> the_orient_express.in_third_class
	
	*	[Travel in the guard's van]
		-> the_orient_express.in_the_guards_van

### The first stitch is the default

Diverting to a knot which contains stitches will divert to the first stitch in the knot. So:

> **第一针是默认的**
>
> 转移到包含针脚的结上将转移到结中的第一针。所以：

	*	[Travel in first class]
		"First class, Monsieur. Where else?"
		-> the_orient_express

is the same as:



	*	[Travel in first class]
		"First class, Monsieur. Where else?"
		-> the_orient_express.in_first_class

> （如果父节点the_orient_express与第一个子节点in_first_class之间没有任何东西，那么以上两个例子当然是等效的，因为-> the_orient_express将默认跳转到the_orient_express下的第一个子节点in_first_class，
>
> 而如果the_orient_express与第一个子节点in_first_class之间有东西，那么系统当然会跳转到the_orient_express与in_first_class之间内容的第一行）



(...unless we move the order of the stitches around inside the knot!)

You can also include content at the top of a knot outside of any stitch. However, you need to remember to divert out of it - the engine *won't* automatically enter the first stitch once it's worked its way through the header content.

> 您还可以在任何针脚之外的结的顶部包含内容。但是，您需要记住要转移它 - 一旦引擎通过标题内容工作，它就不会自动进入第一针。
>
> （如果你处在父节点与子节点之间的内容时，你可以直接用箭头跳转到该父节点下的任意子节点，而不用描述这个父节点，因为系统会在你所在父节点下的所有子节点中寻找名字匹配的子节点而后跳转。）

	=== the_orient_express ===
	
	We boarded the train, but where?
	*	[First class] -> in_first_class
	*	[Second class] -> in_second_class
	
	= in_first_class
		...
	= in_second_class
		...

> 在这个例子中，如果你处于the_orient_express外，而你又想跳转到它的in_first_class子节点，那么你需要先写出这个父节点，再在后面加上这个子节点：  
>
> ->the_orient_express.in_first_class
>
> 但是这个例子中你处于父节点the_orient_express和其第一个子节点之间，那么你就不必浪费口舌了，你可以直接：
>
> -> in_first_class





### Local diverts

From inside a knot, you don't need to use the full address for a stitch.

> **本地分流**
>
> 从结的内部，您不需要使用完整的地址进行缝合。
>
> （你看，这就是我在上文中提到的）

	-> the_orient_express
	
	=== the_orient_express ===
	= in_first_class
		I settled my master.
		*	[Move to third class]
			-> in_third_class
	
	= in_third_class
		I put myself in third.

This means stitches and knots can't share names, but several knots can contain the same stitch name. (So both the Orient Express and the SS Mongolia can have first class.)

The compiler will warn you if ambiguous names are used.

### Script files can be combined

You can also split your content across multiple files, using an include statement.

	INCLUDE newspaper.ink
	INCLUDE cities/vienna.ink
	INCLUDE journeys/orient_express.ink

Include statements should always go at the top of a file, and not inside knots.

There are no rules about what file a knot must be in to be diverted to. (In other words, separating files has no effect on the game's namespacing).


## 7) Varying Choices

### Choices can only be used once

By default, every choice in the game can only be chosen once. If you don't have loops in your story, you'll never notice this behaviour. But if you do use loops, you'll quickly notice your options disappearing...

> **选择只能使用一次**
>
> 默认情况下，游戏中的每个选项只能选择一次。如果你的故事中没有循环，你永远不会注意到这种行为。但是，如果您确实使用循环，您很快就会注意到您的选项消失了......
>
> （因为这个原因，所以我才会在文档开篇提到不推荐使用*这种一次性选项，反之我们可以用+这种能够无限使用的选项。）

	=== find_help ===
	
		You search desperately for a friendly face in the crowd.
		*	The woman in the hat[?] pushes you roughly aside. -> find_help
		*	The man with the briefcase[?] looks disgusted as you stumble past him. -> find_help

produces:

	You search desperately for a friendly face in the crowd.
	
	1: The woman in the hat?
	2: The man with the briefcase?
	
	> 1
	The woman in the hat pushes you roughly aside.
	You search desperately for a friendly face in the crowd.
	
	1: The man with the briefcase?
	
	>

... and on the next loop you'll have no options left.

#### Fallback choices

The above example stops where it does, because the next choice ends up in an "out of content" run-time error.

> **回退选项**
>
> 上面的示例在实际操作时停止，因为下一个选择最终会导致“内容不足”运行时错误。

	> 1
	The man with the briefcase looks disgusted as you stumble past him.
	You search desperately for a friendly face in the crowd.
	
	Runtime error in tests/test.ink line 6: ran out of content. Do you need a '-> DONE' or '-> END'?

We can resolve this with a 'fallback choice'. Fallback choices are never displayed to the player, but are 'chosen' by the game if no other options exist.

A fallback choice is simply a "choice without choice text":

> 我们可以通过“回退选择”来解决此问题。后备选项永远不会显示给玩家，但如果没有其他选项存在，则由游戏“选择”。
>
> 回退选项只是“没有选项文本的选项
>
> （就是说，当这里的所有选项都用完之后，玩家将没有选项可以选，游戏就会报错，因此你可以使用这个符号  *->   （这里的箭头后不能加任何东西）如此一来，当选项都被选完后，系统会自动进入这个回退选项）

	*	-> out_of_options

And, in a slight abuse of syntax, we can make a default choice with content in it, using an "choice then arrow":



	* 	->
		Mulder never could explain how he got out of that burning box car. -> season_2

#### Example of a fallback choice

Adding this into the previous example gives us:

	=== find_help ===
	
		You search desperately for a friendly face in the crowd.
		*	The woman in the hat[?] pushes you roughly aside. -> find_help
		*	The man with the briefcase[?] looks disgusted as you stumble past him. -> find_help
		*	->
			But it is too late: you collapse onto the station platform. This is the end.
			-> END

and produces:

	You search desperately for a friendly face in the crowd.
	
	1: The woman in the hat?
	2: The man with the briefcase?
	
	> 1
	The woman in the hat pushes you roughly aside.
	You search desperately for a friendly face in the crowd.
	
	1: The man with the briefcase?
	
	> 1
	The man with the briefcase looks disgusted as you stumble past him.
	You search desperately for a friendly face in the crowd.
	But it is too late: you collapse onto the station platform. This is the end.


### Sticky choices

The 'once-only' behaviour is not always what we want, of course, so we have a second kind of choice: the "sticky" choice. A sticky choice is simply one that doesn't get used up, and is marked by a `+` bullet.

	=== homers_couch ===
		+	[Eat another donut]
			You eat another donut. -> homers_couch
		*	[Get off the couch]
			You struggle up off the couch to go and compose epic poetry.
			-> END

Fallback choices can be sticky too.

	=== conversation_loop
		*	[Talk about the weather] -> chat_weather
		*	[Talk about the children] -> chat_children
		+	-> sit_in_silence_again

### Conditional Choices

You can also turn choices on and off by hand. **ink** has quite a lot of logic available, but the simplest tests is "has the player seen a particular piece of content".

Every knot/stitch in the game has a unique address (so it can be diverted to), and we use the same address to test if that piece of content has been seen.

	*	{ not visit_paris } 	[Go to Paris] -> visit_paris
	+ 	{ visit_paris 	 } 		[Return to Paris] -> visit_paris
	
	*	{ visit_paris.met_estelle } [ Telephone Mme Estelle ] -> phone_estelle

Note that the test `knot_name` is true if *any* stitch inside that knot has been seen.

Note also that conditionals don't override the once-only behaviour of options, so you'll still need sticky options for repeatable choices.

#### Advanced: multiple conditions

You can use several logical tests on an option; if you do, *all* the tests must all be passed for the option to appear.

	*	{ not visit_paris } 	[Go to Paris] -> visit_paris
	+ 	{ visit_paris } { not bored_of_paris }
		[Return to Paris] -> visit_paris

#### Logical operators: AND and OR

The above "multiple conditions" are really just conditions with an the usual programming AND operator. Ink supports `and` (also written as `&&`) and `or` (also written as `||`) in the usual way, as well as brackets.

	*	{ not (visit_paris or visit_rome) && (visit_london || visit_new_york) } [ Wait. Go where? I'm confused. ] -> visit_someplace

For non-programmers `X and Y` means both X and Y must be true. `X or Y` means either or both. We don't have a `xor`.

You can also use the standard `!` for `not`, though it'll sometimes confuse the compiler which thinks `{!text}` is a once-only list. We recommend using `not` because negated boolean tests are never that exciting.

#### Advanced: knot/stitch labels are actually read counts

The test:

	*	{seen_clue} [Accuse Mr Jefferson]

is actually testing an *integer* and not a true/false flag. A knot or stitch used this way is actually an integer variable containing the number of times the content at the address has been seen by the player.

If it's non-zero, it'll return true in a test like the one above, but you can also be more specific as well:

	* {seen_clue > 3} [Flat-out arrest Mr Jefferson]


#### Advanced: more logic

**ink** supports a lot more logic and conditionality than covered here - see the section on [variables and logic](#part-3-variables-and-logic).


## 8) Variable Text

### Text can vary

So far, all the content we've seen has been static, fixed pieces of text. But content can also vary at the moment of being printed.

### Sequences, cycles and other alternatives

The simplest variations of text are provided by alternatives, which are selected from depending on some kind of rule. **ink** supports several types. Alternatives are written inside `{`...`}` curly brackets, with elements separated by `|` symbols (vertical divider lines).

These are only useful if a piece of content is visited more than once!

#### Types of alternatives

**Sequences** (the default):

A sequence (or a "stopping block") is a set of alternatives that tracks how many times its been seen, and each time, shows the next element along. When it runs out of new content it continues the show the final element.

	The radio hissed into life. {"Three!"|"Two!"|"One!"|There was the white noise racket of an explosion.|But it was just static.}
	
	{I bought a coffee with my five-pound note.|I bought a second coffee for my friend.|I didn't have enough money to buy any more coffee.}

**Cycles** (marked with a `&`):

Cycles are like sequences, but they loop their content.

	It was {&Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday} today.


**Once-only** (marked with a `!`):

Once-only alternatives are like sequences, but when they run out of new content to display, they display nothing. (You can think of a once-only alternative as a sequence with a blank last entry.)

	He told me a joke. {!I laughed politely.|I smiled.|I grimaced.|I promised myself to not react again.}

**Shuffles** (marked with a `~`):

Shuffles produce randomised output.

	I tossed the coin. {~Heads|Tails}.

#### Features of Alternatives

Alternatives can contain blank elements.

	I took a step forward. {!||||Then the lights went out. -> eek}

Alternatives can be nested.

	The Ratbear {&{wastes no time and |}swipes|scratches} {&at you|into your {&leg|arm|cheek}}.

Alternatives can include divert statements.

	I {waited.|waited some more.|snoozed.|woke up and waited more.|gave up and left. -> leave_post_office}

They can also be used inside choice text:

	+ 	"Hello, {&Master|Monsieur Fogg|you|brown-eyes}!"[] I declared.

(...with one caveat; you can't start an option's text with a `{`, as it'll look like a conditional.)

(...but the caveat has a caveat, if you escape a whitespace `\ ` before your `{` ink will recognise it as text.)

	+\	{&They headed towards the Sandlands|They set off for the desert|The party followed the old road South}

#### Examples

Alternatives can be used inside loops to create the appearance of intelligent, state-tracking gameplay without particular effort.

Here's a one-knot version of whack-a-mole. Note we use once-only options, and a fallback, to ensure the mole doesn't move around, and the game will always end.

	=== whack_a_mole ===
		{I heft the hammer.|{~Missed!|Nothing!|No good. Where is he?|Ah-ha! Got him! -> END}}
		The {&mole|{&nasty|blasted|foul} {&creature|rodent}} is {in here somewhere|hiding somewhere|still at large|laughing at me|still unwhacked|doomed}. <>
		{!I'll show him!|But this time he won't escape!}
		* 	[{&Hit|Smash|Try} top-left] 	-> whack_a_mole
		*  [{&Whallop|Splat|Whack} top-right] -> whack_a_mole
		*  [{&Blast|Hammer} middle] -> whack_a_mole
		*  [{&Clobber|Bosh} bottom-left] 	-> whack_a_mole
		*  [{&Nail|Thump} bottom-right] 	-> whack_a_mole
		*   ->
	    	    Then you collapse from hunger. The mole has defeated you!
	            -> END


produces the following 'game':

	I heft the hammer.
	The mole is in here somewhere. I'll show him!
	
	1: Hit top-left
	2: Whallop top-right
	3: Blast middle
	4: Clobber bottom-left
	5: Nail bottom-right
	
	> 1
	Missed!
	The nasty creature is hiding somewhere. But this time he won't escape!
	
	1: Splat top-right
	2: Hammer middle
	3: Bosh bottom-left
	4: Thump bottom-right
	
	> 4
	Nothing!
	The mole is still at large.
	1: Whack top-right
	2: Blast middle
	3: Clobber bottom-left
	
	> 2
	Where is he?
	The blasted rodent is laughing at me.
	1: Whallop top-right
	2: Bosh bottom-left
	
	> 1
	Ah-ha! Got him!


And here's a bit of lifestyle advice. Note the sticky choice - the lure of the television will never fade:

	=== turn_on_television ===
	I turned on the television {for the first time|for the second time|again|once more}, but there was {nothing good on, so I turned it off again|still nothing worth watching|even less to hold my interest than before|nothing but rubbish|a program about sharks and I don't like sharks|nothing on}.
	+	[Try it again]	 		-> turn_on_television
	*	[Go outside instead]	-> go_outside_instead
	
	=== go_outside_instead ===
	-> END



#### Sneak Preview: Multiline alternatives

**ink** has another format for making alternatives of varying content blocks, too. See the section on [multiline blocks](#multiline-blocks) for details.



### Conditional Text

Text can also vary depending on logical tests, just as options can.

	{met_blofeld: "I saw him. Only for a moment." }

and

	"His real name was {met_blofeld.learned_his_name: Franz|a secret}."

These can appear as separate lines, or within a section of content. They can even be nested, so:

	{met_blofeld: "I saw him. Only for a moment. His real name was {met_blofeld.learned_his_name: Franz|kept a secret}." | "I missed him. Was he particularly evil?" }

can produce either:

	"I saw him. Only for a moment. His real name was Franz."

or:

	"I saw him. Only for a moment. His real name was kept a secret."

or:

	"I missed him. Was he particularly evil?"

## 9) Game Queries and Functions

**ink** provides a few useful 'game level' queries about game state, for use in conditional logic. They're not quite parts of the language, but they're always available, and they can't be edited by the author. In a sense, they're the "standard library functions" of the language.

The convention is to name these in capital letters.

### CHOICE_COUNT()

`CHOICE_COUNT` returns the number of options created so far in the current chunk. So for instance.

	*	{false} Option A
	* 	{true} Option B
	*  {CHOICE_COUNT() == 1} Option C

produces two options, B and C. This can be useful for controlling how many options a player gets on a turn.

### TURNS()

This returns the number of game turns since the game began.

### TURNS_SINCE(-> knot)

`TURNS_SINCE` returns the number of moves (formally, player inputs) since a particular knot/stitch was last visited.

A value of 0 means "was seen as part of the current chunk". A value of -1 means "has never been seen". Any other positive value means it has been seen that many turns ago.

	*	{TURNS_SINCE(-> sleeping.intro) > 10} You are feeling tired... -> sleeping
	* 	{TURNS_SINCE(-> laugh) == 0}  You try to stop laughing.

Note that the parameter passed to `TURNS_SINCE` is a "divert target", not simply the knot address itself (because the knot address is a number - the read count - not a location in the story...)

TODO: (requirement of passing `-c` to the compiler)

#### Sneak preview: using TURNS_SINCE in a function

The `TURNS_SINCE(->x) == 0` test is so useful it's often worth wrapping it up as an ink function.

	=== function came_from(-> x)
		~ return TURNS_SINCE(x) == 0

The section on [functions](#5-functions) outlines the syntax here a bit more clearly but the above allows you to say things like:

	* {came_from(->  nice_welcome)} 'I'm happy to be here!'
	* {came_from(->  nasty_welcome)} 'Let's keep this quick.'

... and have the game react to content the player saw *just now*.

### SEED_RANDOM()

For testing purposes, it's often useful to fix the random number generator so ink will produce the same outcomes every time you play. You can do this by "seeding" the random number system.

	~ SEED_RANDOM(235)

The number you pass to the seed function is arbitrary, but providing different seeds will result in different sequences of outcomes.

#### Advanced: more queries

You can make your own external functions, though the syntax is a bit different: see the section on [functions](#5-functions) below.

