---
title: VIII. Logic in wrong places
description: Keep it structured
permalink: ./logic-in-wrong-places/
---

# VIII. Logic in wrong places

## Keep it structured

Sometimes when you write code it's easy to get fixed on a requirement, completely forgetting about the `bigger picture`. It's only after the dust settles you look back into your codebase and realise:

> Who's put so much irrelevant code into that class or method? 

The [SOLID Principles](https://en.wikipedia.org/wiki/SOLID) define this as [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single-responsibility_principle) whereby you `structure your code` into `meaningful` and `usable` chunks, or functionality context.

Let's consider this example of our hypothetical *ShoppingCart* class.

```csharp
public class ShoppingCart
{
    public double CalculatePostageCost(int zone, double distance) {...}

    public void CompleteCheckout(Customer customer, Basket basket) {...}

    public void SendWelcomeEmail() {...}

    public void SendReceiptEmail() {...}

    public void CreateInvoice() {...}

    public void SaveInvoice() {...}
}
```

## Problem Statement

On the face of it, code above looks good, right? We have all necessary functionality there to complete the purchase in our *ShoppingCart* class. 

However, closer inspection reveals that some `re-usable methods` could be abstracted out into their own purpose classes:

> 1. New *EmailEngine* class: *SendWelcomeEmail* and *SendReceiptEmail* methods
> 2. New *InvoiceEngine* class: *CreateInvoice* and *SaveInvoice* methods

## Solution

Refactored code to address the `Logic in wrong places` would look something like this now.

```csharp
public class ShoppingCart
{
    readonly EmailEngine _emailEngine;
    readonly InvoiceEngine _invoiceEngine;

    public void CompleteCheckout(Customer customer, Basket basket) {...}

    public double CalculatePostageCost(int zone, double distance) {...}
}

public class EmailEngine
{
    public void SendWelcomeEmail() {...}

    public void SendReceipt() {...}
}

public class InvoiceEngine
{
    public void CreateInvoice() {...}

    public void SaveInvoice() {...}
}
```

With the change above we can `instantiate the purpose built classes` *EmailEngine* & *InvoiceEngine* inside *ShoppingCart* class [lines 3, 4]. Furthermore, we can now [unit test](no-unit-tests.md) these classes as well as re-use these somewhere else in our codebase. Potentially even move these to [Nuget](https://docs.microsoft.com/en-us/nuget/) repository for even wider `re-use`.

The change also takes us step closer towards more powerful concepts in programming such as [inheritance](no-inheritance.md) and [Object oriented programming (OO, OOP)](https://en.wikipedia.org/wiki/Object-oriented_programming).

## Summary

If a certain *class* serves `too many purposes` then it's probably overcomplicated and it should be broken down into `smaller`, structured components.

> Give the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single-responsibility_principle) a go here...

### [<< Previous](too-many-comments.md) | [Next >>](not-using-using.md)