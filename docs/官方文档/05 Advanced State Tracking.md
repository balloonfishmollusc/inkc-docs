# Part 5: Advanced State Tracking

Games with lots of interaction can get very complex, very quickly and the writer's job is often as much about maintaining continuity as it is about content.

This becomes particularly important if the game text is intended to model anything - whether it's a game of cards, the player's knowledge of the gameworld so far, or the state of the various light-switches in a house.

**ink** does not provide a full world-modelling system in the manner of a classic parser IF authoring language - there are no "objects", no concepts of "containment" or being "open" or "locked". However, it does provide a simple yet powerful system for tracking state-changes in a very flexible way, to enable writers to approximate world models where necessary.

#### Note: New feature alert!

This feature is very new to the language. That means we haven't begun to discover all the ways it might be used - but we're pretty sure it's going to be useful! So if you think of a clever usage we'd love to know!


## 1) Basic Lists

The basic unit of state-tracking is a list of states, defined using the `LIST` keyword. Note that a list is really nothing like a C# list (which is an array).

For instance, we might have:

	LIST kettleState = cold, boiling, recently_boiled

This line defines two things: firstly three new values - `cold`, `boiling` and `recently_boiled` - and secondly, a variable, called `kettleState`, to hold these states.

We can tell the list what value to take:

	~ kettleState = cold

We can change the value:

	*	[Turn on kettle]
		The kettle begins to bubble and boil.
		~ kettleState = boiling

We can query the value:

	*	[Touch the kettle]
		{ kettleState == cold:
			The kettle is cool to the touch.
		- else:
		 	The outside of the kettle is very warm!
		}

For convenience, we can give a list a value when it's defined using a bracket:

	LIST kettleState = cold, (boiling), recently_boiled
	// at the start of the game, this kettle is switched on. Edgy, huh?

...and if the notation for that looks a bit redundant, there's a reason for that coming up in a few subsections time.



## 2) Reusing Lists

The above example is fine for the kettle, but what if we have a pot on the stove as well? We can then define a list of states, but put them into variables - and as many variables as we want.

	LIST daysOfTheWeek = Monday, Tuesday, Wednesday, Thursday, Friday
	VAR today = Monday
	VAR tomorrow = Tuesday

### States can be used repeatedly

This allows us to use the same state machine in multiple places.

	LIST heatedWaterStates = cold, boiling, recently_boiled
	VAR kettleState = cold
	VAR potState = cold
	
	*	{kettleState == cold} [Turn on kettle]
		The kettle begins to boil and bubble.
		~ kettleState = boiling
	*	{potState == cold} [Light stove]
	 	The water in the pot begins to boil and bubble.
	 	~ potState = boiling

But what if we add a microwave as well? We might want start generalising our functionality a bit:

	LIST heatedWaterStates = cold, boiling, recently_boiled
	VAR kettleState = cold
	VAR potState = cold
	VAR microwaveState = cold
	
	=== function boilSomething(ref thingToBoil, nameOfThing)
		The {nameOfThing} begins to heat up.
		~ thingToBoil = boiling
	
	=== do_cooking
	*	{kettleState == cold} [Turn on kettle]
		{boilSomething(kettleState, "kettle")}
	*	{potState == cold} [Light stove]
		{boilSomething(potState, "pot")}
	*	{microwaveState == cold} [Turn on microwave]
		{boilSomething(microwaveState, "microwave")}

or even...

	LIST heatedWaterStates = cold, boiling, recently_boiled
	VAR kettleState = cold
	VAR potState = cold
	VAR microwaveState = cold
	
	=== cook_with(nameOfThing, ref thingToBoil)
	+ 	{thingToBoil == cold} [Turn on {nameOfThing}]
	  	The {nameOfThing} begins to heat up.
		~ thingToBoil = boiling
		-> do_cooking.done
	
	=== do_cooking
	<- cook_with("kettle", kettleState)
	<- cook_with("pot", potState)
	<- cook_with("microwave", microwaveState)
	- (done)

Note that the "heatedWaterStates" list is still available as well, and can still be tested, and take a value.

#### List values can share names

Reusing lists brings with it ambiguity. If we have:

	LIST colours = red, green, blue, purple
	LIST moods = mad, happy, blue
	
	VAR status = blue

... how can the compiler know which blue you meant?

We resolve these using a `.` syntax similar to that used for knots and stitches.

	VAR status = colours.blue

...and the compiler will issue an error until you specify.

Note the "family name" of the state, and the variable containing a state, are totally separate. So

	{ statesOfGrace == statesOfGrace.fallen:
		// is the current state "fallen"
	}

... is correct.


#### Advanced: a LIST is actually a variable

One surprising feature is the statement

	LIST statesOfGrace = ambiguous, saintly, fallen

actually does two things simultaneously: it creates three values, `ambiguous`, `saintly` and `fallen`, and gives them the name-parent `statesOfGrace` if needed; and it creates a variable called `statesOfGrace`.

And that variable can be used like a normal variable. So the following is valid, if horribly confusing and a bad idea:

	LIST statesOfGrace = ambiguous, saintly, fallen
	
	~ statesOfGrace = 3.1415 // set the variable to a number not a list value

...and it wouldn't preclude the following from being fine:

	~ temp anotherStateOfGrace = statesOfGrace.saintly




## 3) List Values

When a list is defined, the values are listed in an order, and that order is considered to be significant. In fact, we can treat these values as if they *were* numbers. (That is to say, they are enums.)

	LIST volumeLevel = off, quiet, medium, loud, deafening
	VAR lecturersVolume = quiet
	VAR murmurersVolume = quiet
	
	{ lecturersVolume < deafening:
		~ lecturersVolume++
	
		{ lecturersVolume > murmurersVolume:
			~ murmurersVolume++
			The murmuring gets louder.
		}
	}

The values themselves can be printed using the usual `{...}` syntax, but this will print their name.

	The lecturer's voice becomes {lecturersVolume}.

### Converting values to numbers

The numerical value, if needed, can be got explicitly using the LIST_VALUE function. Note the first value in a list has the value 1, and not the value 0.

	The lecturer has {LIST_VALUE(deafening) - LIST_VALUE(lecturersVolume)} notches still available to him.

### Converting numbers to values

You can go the other way by using the list's name as a function:

	LIST Numbers = one, two, three
	VAR score = one
	~ score = Numbers(2) // score will be "two"

### Advanced: defining your own numerical values

By default, the values in a list start at 1 and go up by one each time, but you can specify your own values if you need to.

	LIST primeNumbers = two = 2, three = 3, five = 5

If you specify a value, but not the next value, ink will assume an increment of 1. So the following is the same:

	LIST primeNumbers = two = 2, three, five = 5


## 4) Multivalued Lists

The following examples have all included one deliberate untruth, which we'll now remove. Lists - and variables containing list values - do not have to contain only one value.

### Lists are boolean sets

A list variable is not a variable containing a number. Rather, a list is like the in/out nameboard in an accommodation block. It contains a list of names, each of which has a room-number associated with it, and a slider to say "in" or "out".

Maybe no one is in:

	LIST DoctorsInSurgery = Adams, Bernard, Cartwright, Denver, Eamonn

Maybe everyone is:

	LIST DoctorsInSurgery = (Adams), (Bernard), (Cartwright), (Denver), (Eamonn)

Or maybe some are and some aren't:

	LIST DoctorsInSurgery = (Adams), Bernard, (Cartwright), Denver, Eamonn

Names in brackets are included in the initial state of the list.

Note that if you're defining your own values, you can place the brackets around the whole term or just the name:

	LIST primeNumbers = (two = 2), (three) = 3, (five = 5)

#### Assiging multiple values

We can assign all the values of the list at once as follows:

	~ DoctorsInSurgery = (Adams, Bernard)
	~ DoctorsInSurgery = (Adams, Bernard, Eamonn)

We can assign the empty list to clear a list out:

	~ DoctorsInSurgery = ()


#### Adding and removing entries

List entries can be added and removed, singly or collectively.

	~ DoctorsInSurgery = DoctorsInSurgery + Adams
	~ DoctorsInSurgery += Adams  // this is the same as the above
	~ DoctorsInSurgery -= Eamonn
	~ DoctorsInSurgery += (Eamonn, Denver)
	~ DoctorsInSurgery -= (Adams, Eamonn, Denver)

Trying to add an entry that's already in the list does nothing. Trying to remove an entry that's not there also does nothing. Neither produces an error, and a list can never contain duplicate entries.


### Basic Queries

We have a few basic ways of getting information about what's in a list:

	LIST DoctorsInSurgery = (Adams), Bernard, (Cartwright), Denver, Eamonn
	
	{LIST_COUNT(DoctorsInSurgery)} 	//  "2"
	{LIST_MIN(DoctorsInSurgery)} 		//  "Adams"
	{LIST_MAX(DoctorsInSurgery)} 		//  "Cartwright"
	{LIST_RANDOM(DoctorsInSurgery)} 	//  "Adams" or "Cartwright"

#### Testing for emptiness

Like most values in ink, a list can be tested "as it is", and will return true, unless it's empty.

	{ DoctorsInSurgery: The surgery is open today. | Everyone has gone home. }

#### Testing for exact equality

Testing multi-valued lists is slightly more complex than single-valued ones. Equality (`==`) now means 'set equality' - that is, all entries are identical.

So one might say:

	{ DoctorsInSurgery == (Adams, Bernard):
		Dr Adams and Dr Bernard are having a loud argument in one corner.
	}

If Dr Eamonn is in as well, the two won't argue, as the lists being compared won't be equal - DoctorsInSurgery will have an Eamonn that the list (Adams, Bernard) doesn't have.

Not equals works as expected:

	{ DoctorsInSurgery != (Adams, Bernard):
		At least Adams and Bernard aren't arguing.
	}

#### Testing for containment

What if we just want to simply ask if Adams and Bernard are present? For that we use a new operator, `has`, otherwise known as `?`.

	{ DoctorsInSurgery ? (Adams, Bernard):
		Dr Adams and Dr Bernard are having a hushed argument in one corner.
	}

And `?` can apply to single values too:

	{ DoctorsInSurgery has Eamonn:
		Dr Eamonn is polishing his glasses.
	}

We can also negate it, with `hasnt` or `!?` (not `?`). Note this starts to get a little complicated as

	DoctorsInSurgery !? (Adams, Bernard)

does not mean neither Adams nor Bernard is present, only that they are not *both* present (and arguing).


#### Example: basic knowledge tracking

The simplest use of a multi-valued list is for tracking "game flags" tidily.

	LIST Facts = (Fogg_is_fairly_odd), 	first_name_phileas, (Fogg_is_English)
	
	{Facts ? Fogg_is_fairly_odd:I smiled politely.|I frowned. Was he a lunatic?}
	'{Facts ? first_name_phileas:Phileas|Monsieur}, really!' I cried.

In particular, it allows us to test for multiple game flags in a single line.

	{ Facts ? (Fogg_is_English, Fogg_is_fairly_odd):
		<> 'I know Englishmen are strange, but this is *incredible*!'
	}


#### Example: a doctor's surgery

We're overdue a fuller example, so here's one.

	LIST DoctorsInSurgery = (Adams), Bernard, Cartwright, (Denver), Eamonn
	
	-> waiting_room
	
	=== function whos_in_today()
		In the surgery today are {DoctorsInSurgery}.
	
	=== function doctorEnters(who)
		{ DoctorsInSurgery !? who:
			~ DoctorsInSurgery += who
			Dr {who} arrives in a fluster.
		}
	
	=== function doctorLeaves(who)
		{ DoctorsInSurgery ? who:
			~ DoctorsInSurgery -= who
			Dr {who} leaves for lunch.
		}
	
	=== waiting_room
		{whos_in_today()}
		*	[Time passes...]
			{doctorLeaves(Adams)} {doctorEnters(Cartwright)} {doctorEnters(Eamonn)}
			{whos_in_today()}

This produces:

	In the surgery today are Adams, Denver.
	
	> Time passes...
	
	Dr Adams leaves for lunch. Dr Cartwright arrives in a fluster. Dr Eamonn arrives in a fluster.
	
	In the surgery today are Cartwright, Denver, Eamonn.

#### Advanced: nicer list printing

The basic list print is not especially attractive for use in-game. The following is better:

	=== function listWithCommas(list, if_empty)
	    {LIST_COUNT(list):
	    - 2:
	        	{LIST_MIN(list)} and {listWithCommas(list - LIST_MIN(list), if_empty)}
	    - 1:
	        	{list}
	    - 0:
				{if_empty}
	    - else:
	      		{LIST_MIN(list)}, {listWithCommas(list - LIST_MIN(list), if_empty)}
	    }
	
	LIST favouriteDinosaurs = (stegosaurs), brachiosaur, (anklyosaurus), (pleiosaur)
	
	My favourite dinosaurs are {listWithCommas(favouriteDinosaurs, "all extinct")}.

It's probably also useful to have an is/are function to hand:

	=== function isAre(list)
		{LIST_COUNT(list) == 1:is|are}
	
	My favourite dinosaurs {isAre(favouriteDinosaurs)} {listWithCommas(favouriteDinosaurs, "all extinct")}.

And to be pendantic:

	My favourite dinosaur{LIST_COUNT(favouriteDinosaurs) != 1:s} {isAre(favouriteDinosaurs)} {listWithCommas(favouriteDinosaurs, "all extinct")}.


#### Lists don't need to have multiple entries

Lists don't *have* to contain multiple values. If you want to use a list as a state-machine, the examples above will all work - set values using `=`, `++` and `--`; test them using `==`, `<`, `<=`, `>` and `>=`. These will all work as expected.

### The "full" list

Note that `LIST_COUNT`, `LIST_MIN` and `LIST_MAX` are refering to who's in/out of the list, not the full set of *possible* doctors. We can access that using

	LIST_ALL(element of list)

or

	LIST_ALL(list containing elements of a list)
	
	{LIST_ALL(DoctorsInSurgery)} // Adams, Bernard, Cartwright, Denver, Eamonn
	{LIST_COUNT(LIST_ALL(DoctorsInSurgery))} // "5"
	{LIST_MIN(LIST_ALL(Eamonn))} 				// "Adams"

Note that printing a list using `{...}` produces a bare-bones representation of the list; the values as words, delimited by commas.

#### Advanced: "refreshing" a list's type

If you really need to, you can make an empty list that knows what type of list it is.

	LIST ValueList = first_value, second_value, third_value
	VAR myList = ()
	
	~ myList = ValueList()

You'll then be able to do:

	{ LIST_ALL(myList) }

#### Advanced: a portion of the "full" list

You can also retrieve just a "slice" of the full list, using the `LIST_RANGE` function. There are two formulations, both valid:

	LIST_RANGE(list_name, min_integer_value, max_integer_value)

and

	LIST_RANGE(list_name, min_value, max_value)

Min and max values here are inclusive. If the game can’t find the values, it’ll get as close as it can, but never go outside the range. So for example:

	{LIST_RANGE(LIST_ALL(primeNumbers), 10, 20)} 

will produce 
	
	11, 13, 17, 19



### Example: Tower of Hanoi

To demonstrate a few of these ideas, here's a functional Tower of Hanoi example, written so no one else has to write it.


	LIST Discs = one, two, three, four, five, six, seven
	VAR post1 = ()
	VAR post2 = ()
	VAR post3 = ()
	
	~ post1 = LIST_ALL(Discs)
	
	-> gameloop
	
	=== function can_move(from_list, to_list) ===
	    {
	    -   LIST_COUNT(from_list) == 0:
	        // no discs to move
	        ~ return false
	    -   LIST_COUNT(to_list) > 0 && LIST_MIN(from_list) > LIST_MIN(to_list):
	        // the moving disc is bigger than the smallest of the discs on the new tower
	        ~ return false
	    -   else:
	    	 // nothing stands in your way!
	        ~ return true
	
	    }
	
	=== function move_ring( ref from, ref to ) ===
	    ~ temp whichRingToMove = LIST_MIN(from)
	    ~ from -= whichRingToMove
	    ~ to += whichRingToMove
	
	== function getListForTower(towerNum)
	    { towerNum:
	        - 1:    ~ return post1
	        - 2:    ~ return post2
	        - 3:    ~ return post3
	    }
	
	=== function name(postNum)
	    the {postToPlace(postNum)} temple
	
	=== function Name(postNum)
	    The {postToPlace(postNum)} temple
	
	=== function postToPlace(postNum)
	    { postNum:
	        - 1: first
	        - 2: second
	        - 3: third
	    }
	
	=== function describe_pillar(listNum) ==
	    ~ temp list = getListForTower(listNum)
	    {
	    - LIST_COUNT(list) == 0:
	        {Name(listNum)} is empty.
	    - LIST_COUNT(list) == 1:
	        The {list} ring lies on {name(listNum)}.
	    - else:
	        On {name(listNum)}, are the discs numbered {list}.
	    }


	=== gameloop
	    Staring down from the heavens you see your followers finishing construction of the last of the great temples, ready to begin the work.
	- (top)
	    +  [ Regard the temples]
	        You regard each of the temples in turn. On each is stacked the rings of stone. {describe_pillar(1)} {describe_pillar(2)} {describe_pillar(3)}
	    <- move_post(1, 2, post1, post2)
	    <- move_post(2, 1, post2, post1)
	    <- move_post(1, 3, post1, post3)
	    <- move_post(3, 1, post3, post1)
	    <- move_post(3, 2, post3, post2)
	    <- move_post(2, 3, post2, post3)
	    -> DONE
	
	= move_post(from_post_num, to_post_num, ref from_post_list, ref to_post_list)
	    +   { can_move(from_post_list, to_post_list) }
	        [ Move a ring from {name(from_post_num)} to {name(to_post_num)} ]
	        { move_ring(from_post_list, to_post_list) }
	        { stopping:
	        -   The priests far below construct a great harness, and after many years of work, the great stone ring is lifted up into the air, and swung over to the next of the temples.
	            The ropes are slashed, and in the blink of an eye it falls once more.
	        -   Your next decree is met with a great feast and many sacrifices. After the funeary smoke has cleared, work to shift the great stone ring begins in earnest. A generation grows and falls, and the ring falls into its ordained place.
	        -   {cycle:
	            - Years pass as the ring is slowly moved.
	            - The priests below fight a war over what colour robes to wear, but while they fall and die, the work is still completed.
	            }
	        }
	    -> top



## 5) Advanced List Operations

The above section covers basic comparisons. There are a few more powerful features as well, but - as anyone familiar with mathematical   sets will know - things begin to get a bit fiddly. So this section comes with an 'advanced' warning.

A lot of the features in this section won't be necessary for most games.

### Comparing lists

We can compare lists less than exactly using `>`, `<`, `>=` and `<=`. Be warned! The definitions we use are not exactly standard fare. They are based on comparing the numerical value of the elements in the lists being tested.

#### "Distinctly bigger than"

`LIST_A > LIST_B` means "the smallest value in A is bigger than the largest values in B": in other words, if put on a number line, the entirety of A is to the right of the entirety of B. `<` does the same in reverse.

#### "Definitely never smaller than"

`LIST_A >= LIST_B` means - take a deep breath now - "the smallest value in A is at least the smallest value in B, and the largest value in A is at least the largest value in B". That is, if drawn on a number line, the entirety of A is either above B or overlaps with it, but B does not extend higher than A.

Note that `LIST_A > LIST_B` implies `LIST_A != LIST_B`, and `LIST_A >= LIST_B` allows `LIST_A == LIST_B` but precludes `LIST_A < LIST_B`, as you might hope.

#### Health warning!

`LIST_A >= LIST_B` is *not* the same as `LIST_A > LIST_B or LIST_A == LIST_B`.

The moral is, don't use these unless you have a clear picture in your mind.

### Inverting lists

A list can be "inverted", which is the equivalent of going through the accommodation in/out name-board and flipping every switch to the opposite of what it was before.

	LIST GuardsOnDuty = (Smith), (Jones), Carter, Braithwaite
	
	=== function changingOfTheGuard
		~ GuardsOnDuty = LIST_INVERT(GuardsOnDuty)


Note that `LIST_INVERT` on an empty list will return a null value, if the game doesn't have enough context to know what invert. If you need to handle that case, it's safest to do it by hand:

	=== function changingOfTheGuard
		{!GuardsOnDuty: // "is GuardsOnDuty empty right now?"
			~ GuardsOnDuty = LIST_ALL(Smith)
		- else:
			~ GuardsOnDuty = LIST_INVERT(GuardsOnDuty)
		}

#### Footnote

The syntax for inversion was originally `~ list` but we changed it because otherwise the line

	~ list = ~ list

was not only functional, but actually caused list to invert itself, which seemed excessively perverse.

### Intersecting lists

The `has` or `?` operator is, somewhat more formally, the "are you a subset of me" operator, ⊇, which includes the sets being equal, but which doesn't include if the larger set doesn't entirely contain the smaller set.

To test for "some overlap" between lists, we use the overlap operator, `^`, to get the *intersection*.

	LIST CoreValues = strength, courage, compassion, greed, nepotism, self_belief, delusions_of_godhood
	VAR desiredValues = (strength, courage, compassion, self_belief )
	VAR actualValues =  ( greed, nepotism, self_belief, delusions_of_godhood )
	
	{desiredValues ^ actualValues} // prints "self_belief"

The result is a new list, so you can test it:

	{desiredValues ^ actualValues: The new president has at least one desirable quality.}
	
	{LIST_COUNT(desiredValues ^ actualValues) == 1: Correction, the new president has only one desirable quality. {desiredValues ^ actualValues == self_belief: It's the scary one.}}




## 6) Multi-list Lists


So far, all of our examples have included one large simplification, again - that the values in a list variable have to all be from the same list family. But they don't.

This allows us to use lists - which have so far played the role of state-machines and flag-trackers - to also act as general properties, which is useful for world modelling.

This is our inception moment. The results are powerful, but also more like "real code" than anything that's come before.

### Lists to track objects

For instance, we might define:

	LIST Characters = Alfred, Batman, Robin
	LIST Props = champagne_glass, newspaper
	
	VAR BallroomContents = (Alfred, Batman, newspaper)
	VAR HallwayContents = (Robin, champagne_glass)

We could then describe the contents of any room by testing its state:

	=== function describe_room(roomState)
		{ roomState ? Alfred: Alfred is here, standing quietly in a corner. } { roomState ? Batman: Batman's presence dominates all. } { roomState ? Robin: Robin is all but forgotten. }
		<> { roomState ? champagne_glass: A champagne glass lies discarded on the floor. } { roomState ? newspaper: On one table, a headline blares out WHO IS THE BATMAN? AND *WHO* IS HIS BARELY-REMEMBERED ASSISTANT? }

So then:

	{ describe_room(BallroomContents) }

produces:

	Alfred is here, standing quietly in a corner. Batman's presence dominates all.
	
	On one table, a headline blares out WHO IS THE BATMAN? AND *WHO* IS HIS BARELY-REMEMBERED ASSISTANT?

While:

	{ describe_room(HallwayContents) }

gives:

	Robin is all but forgotten.
	
	A champagne glass lies discarded on the floor.

And we could have options based on combinations of things:

	*	{ currentRoomState ? (Batman, Alfred) } [Talk to Alfred and Batman]
		'Say, do you two know each other?'

### Lists to track multiple states

We can model devices with multiple states. Back to the kettle again...

	LIST OnOff = on, off
	LIST HotCold = cold, warm, hot
	
	VAR kettleState = off, cold
	
	=== function turnOnKettle() ===
	{ kettleState ? hot:
		You turn on the kettle, but it immediately flips off again.
	- else:
		The water in the kettle begins to heat up.
		~ kettleState -= off
		~ kettleState += on
		// note we avoid "=" as it'll remove all existing states
	}
	
	=== function can_make_tea() ===
		~ return kettleState ? (hot, off)

These mixed states can make changing state a bit trickier, as the off/on above demonstrates, so the following helper function can be useful.

 	=== function changeStateTo(ref stateVariable, stateToReach)
 		// remove all states of this type
 		~ stateVariable -= LIST_ALL(stateToReach)
 		// put back the state we want
 		~ stateVariable += stateToReach

 which enables code like:

 	~ changeState(kettleState, on)
 	~ changeState(kettleState, warm)


#### How does this affect queries?

The queries given above mostly generalise nicely to multi-valued lists

    LIST Letters = a,b,c
    LIST Numbers = one, two, three
    
    VAR mixedList = (a, three, c)
    
    {LIST_ALL(mixedList)}   // a, one, b, two, c, three
    {LIST_COUNT(mixedList)} // 3
    {LIST_MIN(mixedList)}   // a
    {LIST_MAX(mixedList)}   // three or c, albeit unpredictably
    
    {mixedList ? (a,b) }        // false
    {mixedList ^ LIST_ALL(a)}   // a, c
    
    { mixedList >= (one, a) }   // true
    { mixedList < (three) }     // false
    
    { LIST_INVERT(mixedList) }            // one, b, two


## 7) Long example: crime scene

Finally, here's a long example, demonstrating a lot of ideas from this section in action. You might want to try playing it before reading through to better understand the various moving parts.

	-> murder_scene
	
	// Helper function: popping elements from lists
	=== function pop(ref list)
	   ~ temp x = LIST_MIN(list) 
	   ~ list -= x 
	   ~ return x
	
	//
	//  System: items can have various states
	//  Some are general, some specific to particular items
	//


	LIST OffOn = off, on
	LIST SeenUnseen = unseen, seen
	
	LIST GlassState = (none), steamed, steam_gone
	LIST BedState = (made_up), covers_shifted, covers_off, bloodstain_visible
	
	//
	// System: inventory
	//
	
	LIST Inventory = (none), cane, knife
	
	=== function get(x)
	    ~ Inventory += x
	
	//
	// System: positioning things
	// Items can be put in and on places
	//
	
	LIST Supporters = on_desk, on_floor, on_bed, under_bed, held, with_joe
	
	=== function move_to_supporter(ref item_state, new_supporter) ===
	    ~ item_state -= LIST_ALL(Supporters)
	    ~ item_state += new_supporter


​	
	// System: Incremental knowledge.
	// Each list is a chain of facts. Each fact supersedes the fact before 
	//
	
	VAR knowledgeState = ()
	
	=== function reached (x) 
	   ~ return knowledgeState ? x 
	
	=== function between(x, y) 
	   ~ return knowledgeState? x && not (knowledgeState ^ y)
	
	=== function reach(statesToSet) 
	   ~ temp x = pop(statesToSet)
	   {
	   - not x: 
	      ~ return false 
	
	   - not reached(x):
	      ~ temp chain = LIST_ALL(x)
	      ~ temp statesGained = LIST_RANGE(chain, LIST_MIN(chain), x)
	      ~ knowledgeState += statesGained
	      ~ reach (statesToSet) 	// set any other states left to set
	      ~ return true  	       // and we set this state, so true
	 
	    - else:
	      ~ return false || reach(statesToSet) 
	    }	
	
	//
	// Set up the game
	//
	
	VAR bedroomLightState = (off, on_desk)
	
	VAR knifeState = (under_bed)


​	
	//
	// Knowledge chains
	//


​	
	LIST BedKnowledge = neatly_made, crumpled_duvet, hastily_remade, body_on_bed, murdered_in_bed, murdered_while_asleep
	
	LIST KnifeKnowledge = prints_on_knife, joe_seen_prints_on_knife,joe_wants_better_prints, joe_got_better_prints
	
	LIST WindowKnowledge = steam_on_glass, fingerprints_on_glass, fingerprints_on_glass_match_knife


​	
	//
	// Content
	//
	
	=== murder_scene ===
	    The bedroom. This is where it happened. Now to look for clues.
	- (top)
	    { bedroomLightState ? seen:     <- seen_light  }
	    <- compare_prints(-> top)
	
	*   (dobed) [The bed...]
	    The bed was low to the ground, but not so low something might not roll underneath. It was still neatly made.
	    ~ reach (neatly_made)
	    - - (bedhub)
	    * *     [Lift the bedcover]
	            I lifted back the bedcover. The duvet underneath was crumpled.
	            ~ reach (crumpled_duvet)
	            ~ BedState = covers_shifted
	    * *     (uncover) {reached(crumpled_duvet)}
	            [Remove the cover]
	            Careful not to disturb anything beneath, I removed the cover entirely. The duvet below was rumpled.
	            Not the work of the maid, who was conscientious to a point. Clearly this had been thrown on in a hurry.
	            ~ reach (hastily_remade)
	            ~ BedState = covers_off
	    * *     (duvet) {BedState == covers_off} [ Pull back the duvet ]
	            I pulled back the duvet. Beneath it was a sheet, sticky with blood.
	            ~ BedState = bloodstain_visible
	            ~ reach (body_on_bed)
	            Either the body had been moved here before being dragged to the floor - or this is was where the murder had taken place.
	    * *     {BedState !? made_up} [ Remake the bed ]
	            Carefully, I pulled the bedsheets back into place, trying to make it seem undisturbed.
	            ~ BedState = made_up
	    * *     [Test the bed]
	            I pushed the bed with spread fingers. It creaked a little, but not so much as to be obnoxious.
	    * *     (darkunder) [Look under the bed]
	            Lying down, I peered under the bed, but could make nothing out.
	
	    * *     {TURNS_SINCE(-> dobed) > 1} [Something else?]
	            I took a step back from the bed and looked around.
	            -> top
	    - -     -> bedhub
	
	*   {darkunder && bedroomLightState ? on_floor && bedroomLightState ? on}
	    [ Look under the bed ]
	    I peered under the bed. Something glinted back at me.
	    - - (reaching)
	    * *     [ Reach for it ]
	            I fished with one arm under the bed, but whatever it was, it had been kicked far enough back that I couldn't get my fingers on it.
	            -> reaching
	    * *     {Inventory ? cane} [Knock it with the cane]
	            -> knock_with_cane
	
	    * *     {reaching > 1 } [ Stand up ]
	            I stood up once more, and brushed my coat down.
	            -> top
	
	*   (knock_with_cane) {reaching && TURNS_SINCE(-> reaching) >= 4 &&  Inventory ? cane } [Use the cane to reach under the bed ]
	    Positioning the cane above the carpet, I gave the glinting thing a sharp tap. It slid out from the under the foot of the bed.
	    ~ move_to_supporter( knifeState, on_floor )
	    * *     (standup) [Stand up]
	            Satisfied, I stood up, and saw I had knocked free a bloodied knife.
	            -> top
	
	    * *     [Look under the bed once more]
	            Moving the cane aside, I looked under the bed once more, but there was nothing more there.
	            -> standup
	
	*   {knifeState ? on_floor} [Pick up the knife]
	    Careful not to touch the handle, I lifted the blade from the carpet.
	    ~ get(knife)
	
	*   {Inventory ? knife} [Look at the knife]
	    The blood was dry enough. Dry enough to show up partial prints on the hilt!
	    ~ reach (prints_on_knife)
	
	*   [   The desk... ]
	    I turned my attention to the desk. A lamp sat in one corner, a neat, empty in-tray in the other. There was nothing else out.
	    Leaning against the desk was a wooden cane.
	    ~ bedroomLightState += seen
	
	    - - (deskstate)
	    * *     (pickup_cane) {Inventory !? cane}  [Pick up the cane ]
	            ~ get(cane)
	          I picked up the wooden cane. It was heavy, and unmarked.
	
	    * *    { bedroomLightState !? on } [Turn on the lamp]
	            -> operate_lamp ->
	
	    * *     [Look at the in-tray ]
	            I regarded the in-tray, but there was nothing to be seen. Either the victim's papers were taken, or his line of work had seriously dried up. Or the in-tray was all for show.
	
	    + +     (open)  {open < 3} [Open a drawer]
	            I tried {a drawer at random|another drawer|a third drawer}. {Locked|Also locked|Unsurprisingly, locked as well}.
	
	    * *     {deskstate >= 2} [Something else?]
	            I took a step away from the desk once more.
	            -> top
	
	    - -     -> deskstate
	
	*     {(Inventory ? cane) && TURNS_SINCE(-> deskstate) <= 2} [Swoosh the cane]
	    I was still holding the cane: I gave it an experimental swoosh. It was heavy indeed, though not heavy enough to be used as a bludgeon.
	    But it might have been useful in self-defence. Why hadn't the victim reached for it? Knocked it over?
	
	*   [The window...]
	    I went over to the window and peered out. A dismal view of the little brook that ran down beside the house.
	
	    - - (window_opts)
	    <- compare_prints(-> window_opts)
	    * *     (downy) [Look down at the brook]
	            { GlassState ? steamed:
	                Through the steamed glass I couldn't see the brook. -> see_prints_on_glass -> window_opts
	            }
	            I watched the little stream rush past for a while. The house probably had damp but otherwise, it told me nothing.
	    * *     (greasy) [Look at the glass]
	            { GlassState ? steamed: -> downy }
	            The glass in the window was greasy. No one had cleaned it in a while, inside or out.
	    * *     { GlassState ? steamed && not see_prints_on_glass && downy && greasy }
	            [ Look at the steam ]
	            A cold day outside. Natural my breath should steam. -> see_prints_on_glass ->
	    + +     {GlassState ? steam_gone} [ Breathe on the glass ]
	            I breathed gently on the glass once more. { reached (fingerprints_on_glass): The fingerprints reappeared. }
	            ~ GlassState = steamed
	
	    + +     [Something else?]
	            { window_opts < 2 || reached (fingerprints_on_glass) || GlassState ? steamed:
	                I looked away from the dreary glass.
	                {GlassState ? steamed:
	                    ~ GlassState = steam_gone
	                    <> The steam from my breath faded.
	                }
	                -> top
	            }
	            I leant back from the glass. My breath had steamed up the pane a little.
	           ~ GlassState = steamed
	
	    - -     -> window_opts
	
	*   {top >= 5} [Leave the room]
	    I'd seen enough. I {bedroomLightState ? on:switched off the lamp, then} turned and left the room.
	    -> joe_in_hall
	
	-   -> top


​	
	= operate_lamp
	    I flicked the light switch.
	    { bedroomLightState ? on:
	        <> The bulb fell dark.
	        ~ bedroomLightState += off
	        ~ bedroomLightState -= on
	    - else:
	        { bedroomLightState ? on_floor: <> A little light spilled under the bed.} { bedroomLightState ? on_desk : <> The light gleamed on the polished tabletop. }
	        ~ bedroomLightState -= off
	        ~ bedroomLightState += on
	    }
	    ->->


​	
	= compare_prints (-> backto)
	    *   { between ((fingerprints_on_glass, prints_on_knife),     fingerprints_on_glass_match_knife) } 
	[Compare the prints on the knife and the window ]
	        Holding the bloodied knife near the window, I breathed to bring out the prints once more, and compared them as best I could.
	        Hardly scientific, but they seemed very similar - very similiar indeed.
	        ~ reach (fingerprints_on_glass_match_knife)
	        -> backto
	
	= see_prints_on_glass
	    ~ reach (fingerprints_on_glass)
	    {But I could see a few fingerprints, as though someone hadpressed their palm against it.|The fingerprints were quite clear and well-formed.} They faded as I watched.
	    ~ GlassState = steam_gone
	    ->->
	
	= seen_light
	    *   {bedroomLightState !? on} [ Turn on lamp ]
	        -> operate_lamp ->
	
	    *   { bedroomLightState !? on_bed  && BedState ? bloodstain_visible }
	        [ Move the light to the bed ]
	        ~ move_to_supporter(bedroomLightState, on_bed)
	
	        I moved the light over to the bloodstain and peered closely at it. It had soaked deeply into the fibres of the cotton sheet.
	        There was no doubt about it. This was where the blow had been struck.
	        ~ reach (murdered_in_bed)
	
	    *   { bedroomLightState !? on_desk } {TURNS_SINCE(-> floorit) >= 2 }
	        [ Move the light back to the desk ]
	        ~ move_to_supporter(bedroomLightState, on_desk)
	        I moved the light back to the desk, setting it down where it had originally been.
	    *   (floorit) { bedroomLightState !? on_floor && darkunder }
	        [Move the light to the floor ]
	        ~ move_to_supporter(bedroomLightState, on_floor)
	        I picked the light up and set it down on the floor.
	    -   -> top
	
	=== joe_in_hall
	    My police contact, Joe, was waiting in the hall. 'So?' he demanded. 'Did you find anything interesting?'
	- (found)
	    *   {found == 1} 'Nothing.'
	        He shrugged. 'Shame.'
	        -> done
	    *   { Inventory ? knife } 'I found the murder weapon.'
	        'Good going!' Joe replied with a grin. 'We thought the murderer had gotten rid of it. I'll bag that for you now.'
	        ~ move_to_supporter(knifeState, with_joe)
	
	    *   {reached(prints_on_knife)} { knifeState ? with_joe }
	        'There are prints on the blade[.'],' I told him.
	        He regarded them carefully.
	        'Hrm. Not very complete. It'll be hard to get a match from these.'
	        ~ reach (joe_seen_prints_on_knife)
	    *   { reached((fingerprints_on_glass_match_knife, joe_seen_prints_on_knife)) }
	        'They match a set of prints on the window, too.'
	        'Anyone could have touched the window,' Joe replied thoughtfully. 'But if they're more complete, they should help us get a decent match!'
	        ~ reach (joe_wants_better_prints)
	    *   { between(body_on_bed, murdered_in_bed)}
	        'The body was moved to the bed at some point[.'],' I told him. 'And then moved back to the floor.'
	        'Why?'
	        * *     'I don't know.'
	                Joe nods. 'All right.'
	        * *     'Perhaps to get something from the floor?'
	                'You wouldn't move a whole body for that.'
	        * *     'Perhaps he was killed in bed.'
	                'It's just speculation at this point,' Joe remarks.
	    *   { reached(murdered_in_bed) }
	        'The victim was murdered in bed, and then the body was moved to the floor.'
	        'Why?'
	        * *     'I don't know.'
	                Joe nods. 'All right, then.'
	        * *     'Perhaps the murderer wanted to mislead us.'
	                'How so?'
	            * * *   'They wanted us to think the victim was awake[.'], I replied thoughtfully. 'That they were meeting their attacker, rather than being stabbed in their sleep.'
	            * * *   'They wanted us to think there was some kind of struggle[.'],' I replied. 'That the victim wasn't simply stabbed in their sleep.'
	            - - -   'But if they were killed in bed, that's most likely what happened. Stabbed, while sleeping.'
	                    ~ reach (murdered_while_asleep)
	        * *     'Perhaps the murderer hoped to clean up the scene.'
	                'But they were disturbed? It's possible.'
	
	    *   { found > 1} 'That's it.'
	        'All right. It's a start,' Joe replied.
	        -> done
	    -   -> found
	-   (done)
	    {
	    - between(joe_wants_better_prints, joe_got_better_prints):
	        ~ reach (joe_got_better_prints)
	        <> 'I'll get those prints from the window now.'
	    - reached(joe_seen_prints_on_knife):
	        <> 'I'll run those prints as best I can.'
	    - else:
	        <> 'Not much to go on.'
	    }
	    -> END



## 8) Summary

To summarise a difficult section, **ink**'s list construction provides:

### Flags
* 	Each list entry is an event
* 	Use `+=` to mark an event as having occurred
*  	Test using `?` and `!?`

Example:

	LIST GameEvents = foundSword, openedCasket, metGorgon
	{ GameEvents ? openedCasket }
	{ GameEvents ? (foundSword, metGorgon) }
	~ GameEvents += metGorgon

### State machines
* 	Each list entry is a state
*  Use `=` to set the state; `++` and `--` to step forward or backward
*  Test using `==`, `>` etc

Example:

	LIST PancakeState = ingredients_gathered, batter_mix, pan_hot, pancakes_tossed, ready_to_eat
	{ PancakeState == batter_mix }
	{ PancakeState < ready_to_eat }
	~ PancakeState++

### Properties
*	Each list is a different property, with values for the states that property can take (on or off, lit or unlit, etc)
* 	Change state by removing the old state, then adding in the new
*  Test using `?` and `!?`

Example:

	LIST OnOffState = on, off
	LIST ChargeState = uncharged, charging, charged
	
	VAR PhoneState = (off, uncharged)
	
	*	{PhoneState !? uncharged } [Plug in phone]
		~ PhoneState -= LIST_ALL(ChargeState)
		~ PhoneState += charging
		You plug the phone into charge.
	*	{ PhoneState ? (on, charged) } [ Call my mother ]

