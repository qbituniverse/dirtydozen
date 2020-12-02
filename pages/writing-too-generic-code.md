---
title: XI. Writing too generic code
description: Solving all problems at once
permalink: /writing-too-generic-code/
---

# XI. Writing too generic code

## Solving all problems at once

Writing code gives you great opportunity to create something that can be written to address a very specific problem - with a razor sharp focus. Without too much thought and design-time spent upfront, however, there's a risk that your code will be doing [too many different things](/logic-in-wrong-places). In the end code becomes `difficult to understand` as to what the purpose of it was in the first place.

> This is often linked to the [over configuration](/over-configuration) and [no unit tests](/no-unit-tests) dirty `code smells`. Code effectively is written with no safety net and thought. That is often accompanied with `tons of config` that only the *programmer* producing it really understood (only at the time of writing it - of course).

Let's consider this high-level code for a hypothetical *Data API Endpoint*:

```csharp
// Data Controller
[HttpGet("get-data")]
public async Task<IActionResult> GetData(string selectParameter) { ... }
// Data Service
public async Task<Data> RetrieveData(string selectParameter) { ... }
```

And configuration associated with this endpoint:

```json
{
    "databaseConnection": "db://abcdef",
    "clientDataSelect": "SELECT * FROM Clients",
    "shoppingCartDataSelect": "SELECT * FORM ShoppingCarts",
    "productDataSelect": "SELECT * FROM Products"
}
```

## Problem Statement

The *API Endpoint* above demonstrates a simple case where `one single endpoint` has been programmed so that the response the client receives from it depends on the *selectParameter* passed as input to the call. In other words, the API `data context` is driven off API `input parameter`, which can be either:

> 1. Get Clients Data
> 2. Get ShoppingCarts Data
> 3. Get Products Data

As consumer of this `Data API`, all I have to do is to call it as follows:

```text
https://data.api.com?selectParameter=clientDataSelect
https://data.api.com?selectParameter=shoppingCartDataSelect
https://data.api.com?selectParameter=productDataSelect
```

It's hard to believe the above could actually happen, but yes, it does happen when proper [logic separation](/logic-in-wrong-places) is not in place and [SOLID principles](https://en.wikipedia.org/wiki/SOLID) are not considered at all.

## Solution

Simply divide your code into [reusable](/logic-in-wrong-places) and hence [testable](/no-unit-tests) components. Moreover, when it comes to designing APIs consider the concept of [Data, context and interaction](https://en.wikipedia.org/wiki/Data,_context_and_interaction).

Our hypothetical example could now be divided into three separate `controllers` and `services` serving the `data` back to clients.

```csharp
// Client Controller
[HttpGet]
public async Task<IActionResult> GetClients() { ... }
// Client Service
public async Task<List<Client>> RetrieveClients() { ... }

// ShoppingCart Controller
[HttpGet]
public async Task<IActionResult> GetShoppingCarts() { ... }
// ShoppingCart Service
public async Task<List<ShoppingCart>> RetrieveShoppingCarts() { ... }

// Product Controller
[HttpGet]
public async Task<IActionResult> GetProducts() { ... }
// Product Service
public async Task<List<Product>> RetrieveProducts() { ... }
```

As far as [config](/over-configuration) is concerned, it's now just a single database connection entry and the rest of `database connectivity` logic and `data manipulation` is handled in database framework, such as [Microsoft Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/).

```json
{
    "databaseConnection": "db://abcdef"
}
```

## Summary

Don't try to be clever and `don't over engineer` your code. We all know well that almost anything is possible to achieve in the wonderful world of programming. 

> Simply try to apply `common sense` and `standards` in your coding and you'll do just great!

### [<< Previous](/no-inheritance) | [Next >>](/no-focus-on-clean-code)