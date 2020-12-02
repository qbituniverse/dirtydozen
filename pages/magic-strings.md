---
title: I. Magic strings
description: Don't lose it, re-use it
permalink: /magic-strings/
---

# I. Magic strings

## Don't lose it, re-use it

There'll be a point in your programming life where you'll come across `string` data types. These are normally defined as double quoted `"..."` pieces of text, like the examples below.

```csharp
"foo"
"My message sentence"
"123"
"true"
```

As you can see, strings can be quite powerful, right? You can wrap the actual text in these, numbers and even boolean types.

> The problem called `Magic strings` arises when you have code written where you check if one value, perhaps assigned in a variable, equals another value, perhaps written in the string.

For example, this small code snippet in isolation doesn't look too offensive, right?

```csharp
var coffeeName = "americano";
if (coffeeName == "latte")
{
    return "Good choice with the Latte!";
}
```

## Problem Statement

Now let's consider slightly bigger piece of code where hopefully the magnitude of the problem will manifest itself.


```csharp
namespace CoffeShop
{
    public class CoffeeMaker
    {
        public int CoffeeSelector(string coffeeName)
        {
            switch (coffeeName)
            {
                case "americano": return 1;
                case "latte": return 2;
                case "cappuccino": return 3;
                default: return 0;
            }
        }

        public string MessagePrinter(string coffeeName)
        {
            switch (coffeeName)
            {
                case "americano": return "One Americano is coming right now sir!";
                case "latte": return "Good choice with the Latte!";
                case "cappucino": return "Nothing beats the good old Cappuccino!";
                default: return "NA";
            }
        }
    }
}
```

We can clearly spot a `lot of strings` in the code above. We have coffee names duplication, as well as some hard-coded string responses. Imagine this being just a snippet of a bigger class or part of a project where these coffee names are scattered everywhere.

> 1. Is this maintainable?
> 2. How about having to replace a particular coffee name?
> 3. Did you notice spelling mistake I made in "cappucino" case statement [line 22] inside of the *MessagePrinter* function?
> 4. Imagine the time waste due to random code behaviours (bugs) resulting from mistakes like the one above?

## Solution

Ideally, anything that you see `duplicated` in your code should be defined once. This is acutely apparent when it comes to strings as these are effectively at the mercy of your `copy & paste` skills to ensure any changes to these `Magic strings` happen as expected.

However, we all know that the copy & paste is not the way serious coding should be done. Better approach would be to re-structure your code so that the `Magic strings` are limited to ideally just once place where these are defined. 

Therefore, let’s consider the example below.

```csharp
namespace CoffeShop
{
    public static class CoffeeHelper
    {
        public const string americano = "americano";
        public const string latte = "latte";
        public const string cappuccino = "cappuccino";

        public static Dictionary<string, int> selector = new Dictionary<string, int>()
        {
            { americano, 1 },
            { latte, 2 },
            { cappuccino, 3 }
        };

        public static Dictionary<string, string> messages = new Dictionary<string, string>()
        {
            { americano, "One Americano is coming right now sir!" },
            { latte, "Good choice with the Latte!" },
            { cappuccino, "Nothing beats the good old Cappuccino!" }
        };
    }

    public class CoffeeMaker
    {
        public int CoffeeSelector(string coffeeName)
        {
            return CoffeeHelper.selector[coffeeName];
        }

        public string MessagePrinter(string coffeeName)
        {
            return CoffeeHelper.messages[coffeeName];
        }
    }
}
```

With the changes above our code has now got simplified where `Magic strings` are managed and defined in one place, the *CoffeeHelper* class [lines 3:22]. From that point onwards we reference our `constants` in *CoffeeMaker* class [lines 24:35]. 

As an added bonus, that class is now [serving a specific purpose](/logic-in-wrong-places) in our codebase, it's [small enough to maintain](/large-method-bodies) and [unit test](/no-unit-tests).

## Summary

And now if I had to fix that "cappucino" typo I only need to go to one place to do this and it's `auto-magically` reflected everywhere my *cappuccino* variable is referenced in the codebase. 

> Now, that's what I call `Magic...`

### [Next >>](/one-trick-pony-variables)