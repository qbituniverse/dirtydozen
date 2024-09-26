---
title: IX. Not using "using"
description: Who is destroying it then?
permalink: ./not-using-using/
---

# IX. Not using "using"

## Who is destroying it then?

Certain programmatic operations, such as reading files or making [HTTP API](https://en.wikipedia.org/wiki/Web_API) calls over the network would require you to instantiate objects in order to achieve it. As with everything in programming, these objects or [variables](one-trick-pony-variables.md) will `require memory` to function properly.

For example consider the following *HttpClient()* call:

```csharp
var client = new HttpClient();
var response = await client.GetAsync("https://my.api.com");
```

## Problem Statement

The code above will work as expected, we'll issue API call and get our response back. Where `problems would normally arise` is when we have so many of these `client` objects span up to the point where our host has no memory left to accommodate these.

> This is also known as [Memory Leak](https://en.wikipedia.org/wiki/Memory_leak) whereby your application `slows down` or eventually stops working if enough memory is not released back.

## Solution

Modern programming languages and frameworks allow programmers to ensure objects are `destroyed` and memory is released properly as soon as a particular piece of code `finishes execution`. The process is also known as [Garbage Collection (GC)](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)).

Let's now consider revised examples introducing the `using` construct. 

##### Example 1 - Encapsulating code inside *using* block

```csharp
using (var client = new HttpClient())
{
    var response = await httpClient.GetAsync("https://my.api.com");
}
```

##### Example 2 - Compact version of *using*

```csharp
using var client = new HttpClient();
var response = await client.GetAsync("https://my.api.com");
```

## Summary

You don't have to write any special code these days in order to ensure your objects are `properly destroyed`, this is taken care of by your chosen language and its framework.

> `Using` the `using` is as straightforward as `typing using` so no excuse really should be made for `not using it...`

### [<< Previous](logic-in-wrong-places.md) | [Next >>](no-inheritance.md)