---
title: X. No inheritance
description: Going it alone
permalink: ./no-inheritance/
---

# X. No inheritance

## Going it alone

With the power of [Object oriented programming (OO, OOP)](https://en.wikipedia.org/wiki/Object-oriented_programming), you as programmer, have the unique ability to work with `objects` in your code. That means, you can shape these objects so they resemble `real world` items, such as Cars.

> Object in code can contain `Data`, `Properties` and `Events` that will make it behave as the "real thing". 

For example, a BMW vehicle can be defined as follows.

```csharp
public class Bmw
{
    public int NumberOfDoors { get; set; }
    public double EngineSize { get; set; }

    public void LockDoors() { ... }
    public void StartUp() { ... }
    public void Park() { ... }
}
```

The BMW above doesn't look too offensive, right? We can now `new it up` in our code [line 1] and use the `object` and its features [lines 7, 8, 9] - as the next example demonstrates.

```csharp
var bmw = new Bmw
{
    NumberOfDoors = 5,
    EngineSize = 2.2
};

bmw.LockDoors();
bmw.StartUp();
bmw.Park();
```

## Problem Statement

Let's now assume we work for used car dealership where we have 100s of different car brands and models in stock. Our software needs to be able to track all these different car movements and specifications. Therefore, one moment we'd need to start up *BMW*, next time *Mercedes* etc. 

Less aware programmer will quickly end up doing this:

```csharp
public class Mercedes
{
    public int NumberOfDoors { get; set; }
    public double EngineSize { get; set; }
    
    public void LockDoors() { ... }
    public void StartUp() { ... }
    public void Park() { ... }
}
```

And then instantiating it:


```csharp
var merc = new Mercedes
{
    NumberOfDoors = 2,
    EngineSize = 5.0
};

merc.LockDoors();
merc.StartUp();
merc.Park();
```

And so on... new Class per new *Car* model... your code will quickly start getting out of control, particularly when it comes to [mocking](https://en.wikipedia.org/wiki/Mock_object) and [unit testing](/no-unit-tests). Also, the approach above brings the risk of [defining logic in wrong places](/logic-in-wrong-places) as well as writing [methods that are too large](/large-method-bodies) to maintain going forward.

> As programmers, we want to able treat all cars as the `same objects` preserving and re-using their `core functionality`. 

For example the *LockDoors()* method should lock doors on any car without too much `if-else-then` logic. Likewise, passing the *Car* objects around your code should also mean treating all cars the same with limited or no use of `if Bmw then do this` type of syntax.

## Solution

Our main objective here is:

> 1. Less code to maintain by reducing code duplication
> 2. Code reusability by inheriting as much code as possible
> 3. Flexibility by switching car implementations at runtime

Meet `interfaces` and the concept of [Inheritance](https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)). To start with, let's define our `Car Interface` as this will ensure the three points above are met.

The new *ICar* `interface` provides default *LockDoors()* [line 6] and *StartUp()* [line 7] implementations. Therefore, *Cars* implementing *ICar* `interface` will have these methods at their disposal simply by the virtue of inheriting them from *ICar*. All our *Cars* will only require to implement is their own *Park()* method [line 8].

```csharp
public interface ICar
{
    int NumberOfDoors { get; set; }
    double EngineSize { get; set; }

    void LockDoors() { Console.WriteLine($"Locking all {NumberOfDoors} doors."); }
    void StartUp() { Console.WriteLine($"Starting {EngineSize} engine now."); }
    void Park();
}
```

The *Mercedes Class* below `inherits` default *LockDoors()* and *StartUp()* car implementation and it only provides its own *Park()* method [line 6] as this is enforced by the `interface contract`.

```csharp
public class Mercedes : ICar
{
    public double EngineSize { get; set; }
    public int NumberOfDoors { get; set; }

    public void Park() { Console.WriteLine("Parking your Mercedes."); }
}
```

Now it's time to consider BMW which also had to implement its own *Park()* method [line 7] and it has also `overridden` *LockDoors()* method [line 6] with its `own implementation`.

```csharp
public class Bmw : ICar
{
    public double EngineSize { get; set; }
    public int NumberOfDoors { get; set; }

    public void LockDoors() { Console.WriteLine($"{NumberOfDoors} doors locked."); }
    public void Park() { Console.WriteLine("Parking your BMW."); }
}
```

And finally, using our *Cars* is as simple as this:

```csharp
// app starts with driver and car definition
var driver = new Driver();
ICar car;

// BMW is created
car = new Bmw
{
    NumberOfDoors = 5,
    EngineSize = 2.2
};

// driver starts operating the car
// notice the "car" being passed rather than "Bmw"
driver.EnterCar(car);
car.LockDoors();
car.StartUp();
car.Park();
driver.LeaveCar(car);

// Mercedes is now created
car = new Mercedes
{
    NumberOfDoors = 2,
    EngineSize = 5.0
};

// driver starts operating the car
// same here driver just works on "another car"
driver.EnterCar(car);
car.LockDoors();
car.StartUp();
car.Park();
driver.LeaveCar(car);
```

And just for completeness, the *Driver* `class` will look something like below.

```csharp
public class Driver
{
    public void EnterCar(ICar car) { ... }
    public void LeaveCar(ICar car) { ... }
}
```

Of course now the *Driver* could also `implement` either *IDriver* `interface` or `inherit` some sort of *BaseDriver* `base class` which would provide core `object structure`, `contract` and `functionality`.

## Summary

The examples presented here are literally scratching the surface of `many benefits` that you can achieve with implementing `Inheritance`.

> Simply start using `interfaces` in your code and begin future proofing your apps now...

### [<< Previous](/not-using-using) | [Next >>](/writing-too-generic-code)