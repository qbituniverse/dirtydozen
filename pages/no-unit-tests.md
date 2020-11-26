---
title: VI. No unit tests
description: Driving without headlights
permalink: /no-unit-tests/
---

# VI. No unit tests

## Driving without headlights

In modern day it's almost unacceptable to deliver code in any form or shape without `testing it`. A concept called [Test-driven development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development) has been born to accommodate the inclusion of tests into requirements and effectively baking these into the process of producing `testable code`.

Let's first look at this code example below, a simple method returns some sort of calculation result - in this instance calculating postage cost.

```csharp
public class ShoppingCart
{
    public double CalculatePostageCost(int zone, double distance)
    {
        return zone * distance;
    }
}
```

## Problem Statement

There's nothing extraordinary about the piece of code above, it simply multiplies two numbers and returns the result back. However, think about the requirement for a moment, which might look something like this:

> 1. Postage cost returned must be a positive number of double data type
> 2. Zone must be integer within 1 - 7 range
> 3. Distance must be positive number of double data type

In modern day the requirement above would be translated into a `unit test` for which [structured](/logic-in-wrong-places) and [testable](/large-method-bodies) code would be produced to ensure it meets the requirement.

## Solution

Let's now consider our `revised code` which has the `requirements` implemented, as per above.

```csharp
public class ShoppingCart
{
    public double CalculatePostageCost(int zone, double distance)
    {
        if (zone < 1 || zone > 7) 
            throw new ArgumentOutOfRangeException("Argument zone has to be between 1 - 7");
        if (distance <= 0) 
            throw new ArgumentOutOfRangeException("Argument distance has to be more than 0");

        return zone * distance;
    }
}
```

Finally, to complete our example we've now written three `unit tests` inside *ShoppingCartUnitTests* test class to make sure the code only does what's supposed to do.

##### Test Class

```csharp
[TestClass]
public class ShoppingCartUnitTests
{
    // Unit Tests go here
}
```

##### Unit Test 1 - Numbers are calculated correctly

```csharp
[TestMethod]
public void CalculatePostageCost_Returns_CorrectCalculation()
{
    // Arrange
    var shoppingCart = new ShoppingCart();
    int zone = 2;
    double distance = 45.77;

    // Act
    var postageCost = shoppingCart.CalculatePostageCost(zone, distance);

    // Assert
    Assert.AreEqual(zone * distance, postageCost);
}
```


##### Unit Test 2 - Argument *zone* can only be between 1 - 7

```csharp
[TestMethod]
public void CalculatePostageCost_Zone_0_Exception()
{
    // Arrange
    var shoppingCart = new ShoppingCart();
    int zone = 0;
    double distance = 45.77;
    string exception = "Argument zone has to be between 1 - 7";

    // Act
    try
    {
        var postageCost = shoppingCart.CalculatePostageCost(zone, distance);
    }
    catch (ArgumentOutOfRangeException e)
    {
        // Assert
        StringAssert.Contains(e.Message, exception);
    }
}

[TestMethod]
public void CalculatePostageCost_Zone_8_Exception()
{
    // Arrange
    var shoppingCart = new ShoppingCart();
    int zone = 8;
    double distance = 45.77;
    string exception = "Argument zone has to be between 1 - 7";

    // Act
    try
    {
        var postageCost = shoppingCart.CalculatePostageCost(zone, distance);
    }
    catch (ArgumentOutOfRangeException e)
    {
        // Assert
        StringAssert.Contains(e.Message, exception);
    }
}
```

##### Unit Test 3 - Argument *distance* cannot be 0 or less


```csharp
[TestMethod]
public void CalculatePostageCost_Distance_0_Exception()
{
    // Arrange
    var shoppingCart = new ShoppingCart();
    int zone = 6;
    double distance = 0;
    string exception = "Argument distance has to be more than 0";

    // Act
    try
    {
        var postageCost = shoppingCart.CalculatePostageCost(zone, distance);
    }
    catch (ArgumentOutOfRangeException e)
    {
        // Assert
        StringAssert.Contains(e.Message, exception);
    }
}
```

## Summary

And now when you make future code changes to the *CalculatePostageCost* method and its behaviour diverge from the unit tests then your code `won't build`.

> It's like with the headlights, you `keep the headlights on` while driving in the dark, otherwise you won't really know where the next turn will take you...

### [<< Previous](/large-method-bodies) | [Next >>](/too-many-comments)