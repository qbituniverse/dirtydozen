---
title: II. One-trick-pony variables
description: Don't ride it just once
permalink: /one-trick-pony-variables/
---

# II. One-trick-pony variables

## Don't ride it just once

Programming often requires you to store data in memory during code execution. This programmatic memory storage vehicle is called `variable` which also has a `type` defined. For example, variables can be [string](https://en.wikipedia.org/wiki/String_(computer_science)), [integer](https://en.wikipedia.org/wiki/Integer_(computer_science)), [boolean](https://en.wikipedia.org/wiki/Boolean_data_type) types, [plus tons more](https://en.wikipedia.org/wiki/Data_type).

```csharp
var foo = "foo";
var message = "My message sentence";
var age = 35;
var isActive = true;
var temperature = 36.6;
```

> Using variables the right way is a fine balance, which you as programmer, need to strike between [readable code](/too-many-comments) and [memory utilisation](/not-using-using). 

Let's consider this code below which in isolation doesn't look too bad, right?

```csharp
var patient = new Patient();
var nurse = new Nurse();

// some additional code left out for brevity

var patientMorningTemperature = patient.Temperature;
nurse.RecordPatientTemperature(patientMorningTemperature);
```

## Problem Statement

Now let's consider slightly bigger piece of code where hopefully the magnitude of the problem will manifest itself.

```csharp
var patient = new Patient();
var nurse = new Nurse();

// some additional code left out for brevity

var patientMorningTemperature = patient.Temperature;
nurse.RecordPatientTemperature(patientMorningTemperature);

// some additional code left out for brevity

patient.TakenParacetamol();

// some additional code left out for brevity

var patientAfternoonTemperature = patient.Temperature;
nurse.RecordPatientTemperature(patientAfternoonTemperature);
```

What stands out in this code is that we have a number of `One-trick-pony variables` defined for the same piece of data, the temperature: *patientMorningTemperature* [line 6] & *patientAfternoonTemperature* [line 15]. In addition, the temperature variables are then simply passed to a function for Nurse to record [lines 7, 16] and are never re-used anywhere else in the code execution.

> 1. Is there any benefit of storing temperature in both *patientMorningTemperature* and *patientAfternoonTemperature* variables?
> 2. How about if this data was much bigger, perhaps a stream or data set? 
> 3. Are you happy with the memory penalty associated with storing it twice?

## Solution

Let's re-use some of the data that is already available to us in code and prevent instantiating `One-trick-pony variables` unnecessarily. As result, the code will run faster and will be [more readable](/too-many-comments).

##### Variation 1 - Reduction in variable use

```csharp
var patient = new Patient();
var nurse = new Nurse();
var temperature = patient.Temperature;

// some additional code left out for brevity

nurse.RecordPatientTemperature(temperature);

// some additional code left out for brevity

patient.TakenParacetamol();

// some additional code left out for brevity

temperature = patient.Temperature;

// some additional code left out for brevity

nurse.RecordPatientTemperature(temperature);
```

With the code changes above, we've re-used the *temperature* variable [line 3] more than once [lines 7, 15, 19], so it's no longer a `One-trick-pony` unnecessarily. And sometimes that's all you might need to do - all depending on what's happening in between the *some additional code left out for brevity* sections [lines 5, 9, 13, 17].

##### Variation 2 - No variable use

```csharp
var patient = new Patient();
var nurse = new Nurse();

// some additional code left out for brevity

nurse.RecordPatientTemperature(patient.Temperature);

// some additional code left out for brevity

patient.TakenParacetamol();

// some additional code left out for brevity

nurse.RecordPatientTemperature(patient.Temperature);
```

Consider code above now where we've gotten rid of the `One-trick-pony variables` altogether because we've realised these were not required for anything else other than passing a piece of information which was already defined and set on the *Patient* object. Therefore, we could acquire the temperature directly form *patient.Temperature* attribute [lines 6, 14].

## Summary

I understand that assigning a small variable seems innocent at the time of coding and sometimes doing so might be required for [clarity](/too-many-comments).

> However, try not to get into a bad habit of creating too many of these `One-trick-pony variables unnecessarily...`

### [<< Previous](/magic-strings) | [Next >>](/sensitive-config)